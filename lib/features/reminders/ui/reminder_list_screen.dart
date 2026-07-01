import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/loading_state.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/empty_state.dart';
import '../models/reminder_model.dart';
import '../providers/reminder_provider.dart';
import 'reminder_form_screen.dart';

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
          if (reminders.isEmpty) {
            return EmptyState(
              message: 'No reminders.',
              icon: Icons.alarm,
              actionLabel: 'Add First Reminder',
              onAction: () => _navigateToAdd(context),
            );
          }
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
                  trailing: Switch(
                    value: r.notificationEnabled,
                    onChanged: (v) {
                      ref
                          .read(reminderControllerProvider.notifier)
                          .updateReminder(ReminderModel(
                            id: r.id,
                            userId: r.userId,
                            title: r.title,
                            date: r.date,
                            time: r.time,
                            category: r.category,
                            notificationEnabled: v,
                          ));
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                ReminderFormScreen(reminderToEdit: r)));
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
        context, MaterialPageRoute(builder: (_) => const ReminderFormScreen()));
  }
}
