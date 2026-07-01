import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/training_log_model.dart';
import '../providers/training_provider.dart';
import 'package:intl/intl.dart';

class TrainingFormScreen extends ConsumerStatefulWidget {
  final TrainingLogModel? logToEdit;

  const TrainingFormScreen({super.key, this.logToEdit});

  @override
  ConsumerState<TrainingFormScreen> createState() => _TrainingFormScreenState();
}

class _TrainingFormScreenState extends ConsumerState<TrainingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _selectedType;
  late DateTime _selectedDate;
  final _distanceController = TextEditingController();
  final _setsController = TextEditingController();
  final _repsController = TextEditingController();
  final _intensityController = TextEditingController();
  final _notesController = TextEditingController();

  final List<String> _trainingTypes = [
    'Sprint',
    'Gym',
    'Recovery',
    'Stretching',
    'Rest Day',
    'Warm-up',
    'Cooldown'
  ];

  @override
  void initState() {
    super.initState();
    _selectedType = widget.logToEdit?.trainingType ?? _trainingTypes.first;
    _selectedDate = widget.logToEdit?.date ?? DateTime.now();
    _distanceController.text = widget.logToEdit?.distance?.toString() ?? '';
    _setsController.text = widget.logToEdit?.sets?.toString() ?? '';
    _repsController.text = widget.logToEdit?.reps?.toString() ?? '';
    _intensityController.text = widget.logToEdit?.intensity?.toString() ?? '';
    _notesController.text = widget.logToEdit?.notes ?? '';
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final log = TrainingLogModel(
      id: widget.logToEdit?.id,
      userId: user.id,
      date: _selectedDate,
      trainingType: _selectedType,
      distance: double.tryParse(_distanceController.text),
      sets: int.tryParse(_setsController.text),
      reps: int.tryParse(_repsController.text),
      intensity: int.tryParse(_intensityController.text),
      notes: _notesController.text,
    );

    if (widget.logToEdit == null) {
      await ref.read(trainingControllerProvider.notifier).addLog(log);
    } else {
      await ref.read(trainingControllerProvider.notifier).updateLog(log);
    }

    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    if (widget.logToEdit?.id == null) return;
    await ref
        .read(trainingControllerProvider.notifier)
        .deleteLog(widget.logToEdit!.id!);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(trainingControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.logToEdit == null ? 'New Training' : 'Edit Training'),
        actions: widget.logToEdit != null
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
              ListTile(
                title: const Text('Date'),
                subtitle: Text(DateFormat.yMMMd().format(_selectedDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) setState(() => _selectedDate = date);
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(labelText: 'Training Type'),
                items: _trainingTypes
                    .map((type) =>
                        DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedType = val!),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _setsController,
                      label: 'Sets',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: _repsController,
                      label: 'Reps',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _distanceController,
                      label: 'Distance (m)',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: _intensityController,
                      label: 'Intensity (1-10)',
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        if (val != null && val.isNotEmpty) {
                          final i = int.tryParse(val);
                          if (i == null || i < 1 || i > 10) return '1-10';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _notesController,
                label: 'Notes',
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Save Log',
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
