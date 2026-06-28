import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/sprint_timing_model.dart';
import '../providers/timing_provider.dart';

class TimingFormScreen extends ConsumerStatefulWidget {
  final SprintTimingModel? timingToEdit;

  const TimingFormScreen({super.key, this.timingToEdit});

  @override
  ConsumerState<TimingFormScreen> createState() => _TimingFormScreenState();
}

class _TimingFormScreenState extends ConsumerState<TimingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _selectedDate;
  final _distanceController = TextEditingController();
  final _timingController = TextEditingController();
  final _locationController = TextEditingController();
  final _weatherController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.timingToEdit?.date ?? DateTime.now();
    _distanceController.text = widget.timingToEdit?.distance.toString() ?? '';
    _timingController.text = widget.timingToEdit?.timing.toString() ?? '';
    _locationController.text = widget.timingToEdit?.location ?? '';
    _weatherController.text = widget.timingToEdit?.weather ?? '';
    _notesController.text = widget.timingToEdit?.notes ?? '';
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final timing = SprintTimingModel(
      id: widget.timingToEdit?.id,
      userId: user.id,
      date: _selectedDate,
      distance: double.parse(_distanceController.text),
      timing: double.parse(_timingController.text),
      location: _locationController.text,
      weather: _weatherController.text,
      notes: _notesController.text,
      previousTime: widget.timingToEdit?.previousTime,
      improvement: widget.timingToEdit?.improvement,
    );

    if (widget.timingToEdit == null) {
      await ref.read(timingControllerProvider.notifier).addTiming(timing);
    } else {
      await ref.read(timingControllerProvider.notifier).updateTiming(timing);
    }

    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    if (widget.timingToEdit?.id == null) return;
    await ref
        .read(timingControllerProvider.notifier)
        .deleteTiming(widget.timingToEdit!.id!);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(timingControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.timingToEdit == null ? 'Record Timing' : 'Edit Timing'),
        actions: widget.timingToEdit != null
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
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _distanceController,
                      label: 'Distance (m)',
                      keyboardType: TextInputType.number,
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: _timingController,
                      label: 'Time (s)',
                      keyboardType: TextInputType.number,
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _locationController,
                label: 'Location / Venue',
                prefixIcon: Icons.location_on_outlined,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _weatherController,
                label: 'Weather (e.g. Sunny, +2.0w)',
                prefixIcon: Icons.cloud_outlined,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _notesController,
                label: 'Notes',
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Save Timing',
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
