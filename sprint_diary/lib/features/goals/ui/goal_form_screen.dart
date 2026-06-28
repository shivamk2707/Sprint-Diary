import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/goal_model.dart';
import '../providers/goal_provider.dart';

class GoalFormScreen extends ConsumerStatefulWidget {
  final GoalModel? goalToEdit;

  const GoalFormScreen({super.key, this.goalToEdit});

  @override
  ConsumerState<GoalFormScreen> createState() => _GoalFormScreenState();
}

class _GoalFormScreenState extends ConsumerState<GoalFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _targetController = TextEditingController();
  DateTime? _selectedDate;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.goalToEdit?.title ?? '';
    _descController.text = widget.goalToEdit?.description ?? '';
    _targetController.text = widget.goalToEdit?.target ?? '';
    _selectedDate = widget.goalToEdit?.targetDate;
    _progress = widget.goalToEdit?.progress ?? 0.0;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final goal = GoalModel(
      id: widget.goalToEdit?.id,
      userId: user.id,
      title: _titleController.text,
      description: _descController.text,
      target: _targetController.text,
      targetDate: _selectedDate,
      progress: _progress,
      completed: _progress >= 100 || (widget.goalToEdit?.completed ?? false),
    );

    if (widget.goalToEdit == null) {
      await ref.read(goalControllerProvider.notifier).addGoal(goal);
    } else {
      await ref.read(goalControllerProvider.notifier).updateGoal(goal);
    }

    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    if (widget.goalToEdit?.id == null) return;
    await ref
        .read(goalControllerProvider.notifier)
        .deleteGoal(widget.goalToEdit!.id!);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(goalControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.goalToEdit == null ? 'New Goal' : 'Edit Goal'),
        actions: widget.goalToEdit != null
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
                label: 'Goal Title',
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _targetController,
                label: 'Target (e.g. 100m under 11s)',
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Target Date (Optional)'),
                subtitle: Text(_selectedDate != null
                    ? DateFormat.yMMMd().format(_selectedDate!)
                    : 'Not set'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) setState(() => _selectedDate = date);
                },
              ),
              const SizedBox(height: 16),
              if (widget.goalToEdit != null) ...[
                Text('Progress: ${_progress.toInt()}%'),
                Slider(
                  value: _progress,
                  min: 0,
                  max: 100,
                  divisions: 10,
                  label: '${_progress.toInt()}%',
                  onChanged: (val) => setState(() => _progress = val),
                ),
                const SizedBox(height: 16),
              ],
              CustomTextField(
                controller: _descController,
                label: 'Description / Notes',
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Save Goal',
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
