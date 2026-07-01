import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/widgets/loading_state.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/empty_state.dart';
import '../providers/note_provider.dart';
import 'note_form_screen.dart';

class NotesListScreen extends ConsumerWidget {
  const NotesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(notesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Journal Notes')),
      body: notesAsync.when(
        loading: () => const LoadingState(),
        error: (err, _) => ErrorState(
            message: err.toString(),
            onRetry: () => ref.invalidate(notesProvider)),
        data: (notes) {
          if (notes.isEmpty) {
            return EmptyState(
              message: 'No notes yet.',
              icon: Icons.book,
              actionLabel: 'Write First Note',
              onAction: () => _navigateToAdd(context),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  title: Text(note.title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    '${DateFormat.yMMMd().format(note.date)}\n${note.description}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  isThreeLine: true,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => NoteFormScreen(noteToEdit: note)));
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAdd(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToAdd(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const NoteFormScreen()));
  }
}
