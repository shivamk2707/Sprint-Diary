import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/note_model.dart';
import '../providers/note_provider.dart';

class NoteFormScreen extends ConsumerStatefulWidget {
  final NoteModel? noteToEdit;

  const NoteFormScreen({super.key, this.noteToEdit});

  @override
  ConsumerState<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends ConsumerState<NoteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.noteToEdit?.title ?? '';
    _descController.text = widget.noteToEdit?.description ?? '';
    _selectedDate = widget.noteToEdit?.date ?? DateTime.now();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final note = NoteModel(
      id: widget.noteToEdit?.id,
      userId: user.id,
      title: _titleController.text,
      description: _descController.text,
      date: _selectedDate,
    );

    if (widget.noteToEdit == null) {
      await ref.read(noteControllerProvider.notifier).addNote(note);
    } else {
      await ref.read(noteControllerProvider.notifier).updateNote(note);
    }

    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    if (widget.noteToEdit?.id == null) return;
    await ref
        .read(noteControllerProvider.notifier)
        .deleteNote(widget.noteToEdit!.id!);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(noteControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.noteToEdit == null ? 'New Note' : 'Edit Note'),
        actions: widget.noteToEdit != null
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
              CustomTextField(
                controller: _titleController,
                label: 'Title',
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _descController,
                label: 'Description / Content',
                maxLines: 8,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Save Note',
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
