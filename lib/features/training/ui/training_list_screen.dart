import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/widgets/loading_state.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/empty_state.dart';
import '../providers/training_provider.dart';
import 'training_form_screen.dart';

class TrainingListScreen extends ConsumerWidget {
  const TrainingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(trainingLogsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Training Logs')),
      body: logsAsync.when(
        loading: () => const LoadingState(),
        error: (err, _) => ErrorState(
          message: err.toString(),
          onRetry: () => ref.invalidate(trainingLogsProvider),
        ),
        data: (logs) {
          if (logs.isEmpty) {
            return EmptyState(
              message: 'No training logs found.',
              icon: Icons.list_alt,
              actionLabel: 'Add First Log',
              onAction: () => _navigateToAdd(context),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(trainingLogsProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    title: Text(log.trainingType),
                    subtitle: Text(DateFormat.yMMMd().format(log.date)),
                    trailing: Text('Int: ${log.intensity ?? '-'} / 10'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  TrainingFormScreen(logToEdit: log)));
                    },
                  ),
                );
              },
            ),
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
        context, MaterialPageRoute(builder: (_) => const TrainingFormScreen()));
  }
}
