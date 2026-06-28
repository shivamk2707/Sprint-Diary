import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/loading_state.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/empty_state.dart';
import '../providers/reminder_provider.dart';

class ReminderListScreen extends ConsumerWidget {
  const ReminderListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remindersAsync = ref.watch(remindersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Reminders')),
      body: remindersAsync.when(
        loading: () => const LoadingState(),
        error: (err, _) => ErrorState(
            message: err.toString(),
            onRetry: () => ref.invalidate(remindersProvider)),
        data: (reminders) {
          if (reminders.isEmpty)
            return const EmptyState(
                message: 'No reminders.', icon: Icons.alarm);
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reminders.length,
            itemBuilder: (context, index) {
              final r = reminders[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  title: Text(r.title),
                  subtitle:
                      Text('${r.date.toString().split(' ')[0]} - ${r.time}'),
                  trailing:
                      Switch(value: r.notificationEnabled, onChanged: (v) {}),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
