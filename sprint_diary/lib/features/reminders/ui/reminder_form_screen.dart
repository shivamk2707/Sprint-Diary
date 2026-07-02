import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/reminder_model.dart';
import '../providers/reminder_provider.dart';

class ReminderFormScreen extends ConsumerStatefulWidget {
  final ReminderModel? reminderToEdit;

  const ReminderFormScreen({super.key, this.reminderToEdit});

  @override
  ConsumerState<ReminderFormScreen> createState() => _ReminderFormScreenState();
}

class _ReminderFormScreenState extends ConsumerState<ReminderFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String? _selectedCategory;

  final List<String> _categories = [
    'Workout',
    'Water',
    'Stretch',
    'Sleep',
    'Competition'
  ];

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.reminderToEdit?.title ?? '';
    _selectedDate = widget.reminderToEdit?.date ?? DateTime.now();
    if (widget.reminderToEdit != null) {
      final parts = widget.reminderToEdit!.time.split(':');
      if (parts.length >= 2) {
        _selectedTime = TimeOfDay(
            hour: int.tryParse(parts[0]) ?? 0,
            minute: int.tryParse(parts[1]) ?? 0);
      }
    }
    _selectedCategory = widget.reminderToEdit?.category ?? _categories.first;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final timeString =
        '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}:00';

    final reminder = ReminderModel(
      id: widget.reminderToEdit?.id,
      userId: user.id,
      title: _titleController.text,
      date: _selectedDate,
      time: timeString,
      category: _selectedCategory,
      notificationEnabled: widget.reminderToEdit?.notificationEnabled ?? true,
    );

    if (widget.reminderToEdit == null) {
      await ref.read(reminderControllerProvider.notifier).addReminder(reminder);
    } else {
      await ref
          .read(reminderControllerProvider.notifier)
          .updateReminder(reminder);
    }

    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    if (widget.reminderToEdit?.id == null) return;
    await ref
        .read(reminderControllerProvider.notifier)
        .deleteReminder(widget.reminderToEdit!.id!);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(reminderControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.reminderToEdit == null ? 'New Reminder' : 'Edit Reminder'),
        actions: widget.reminderToEdit != null
            ? [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: isLoading ? null : _delete,
                )
              ]
            : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: _titleController,
                label: 'Reminder Title',
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Date'),
                subtitle: Text(DateFormat.yMMMd().format(_selectedDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) setState(() => _selectedDate = date);
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Time'),
                subtitle: Text(_selectedTime.format(context)),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: _selectedTime,
                  );
                  if (time != null) setState(() => _selectedTime = time);
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedCategory = val),
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Save Reminder',
                onPressed: _save,
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
