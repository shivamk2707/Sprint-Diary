import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/widgets/loading_state.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/empty_state.dart';
import '../providers/note_provider.dart';

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
          if (notes.isEmpty)
            return const EmptyState(message: 'No notes.', icon: Icons.book);
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  title: Text(note.title),
                  subtitle: Text(DateFormat.yMMMd().format(note.date)),
                  onTap: () {
                    // Open Note Form
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
