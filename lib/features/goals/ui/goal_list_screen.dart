import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/widgets/loading_state.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/empty_state.dart';
import '../providers/goal_provider.dart';
import 'goal_form_screen.dart';

class GoalListScreen extends ConsumerWidget {
  const GoalListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(goalsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Goals')),
      body: goalsAsync.when(
        loading: () => const LoadingState(),
        error: (err, _) => ErrorState(
          message: err.toString(),
          onRetry: () => ref.invalidate(goalsProvider),
        ),
        data: (goals) {
          if (goals.isEmpty) {
            return EmptyState(
              message: 'No goals set yet.',
              icon: Icons.flag,
              actionLabel: 'Set a Goal',
              onAction: () => _navigateToAdd(context),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(goalsProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: goals.length,
              itemBuilder: (context, index) {
                final goal = goals[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  color: goal.completed
                      ? Theme.of(context).colorScheme.surface.withOpacity(0.5)
                      : null,
                  child: ListTile(
                    leading: Checkbox(
                      value: goal.completed,
                      onChanged: (val) {
                        ref
                            .read(goalControllerProvider.notifier)
                            .updateGoal(goal.copyWith(completed: val));
                      },
                    ),
                    title: Text(
                      goal.title,
                      style: TextStyle(
                        decoration:
                            goal.completed ? TextDecoration.lineThrough : null,
                        color: goal.completed ? Colors.grey : null,
                      ),
                    ),
                    subtitle: goal.targetDate != null
                        ? Text(
                            'Target: ${DateFormat.yMMMd().format(goal.targetDate!)}')
                        : null,
                    trailing: goal.progress > 0 && !goal.completed
                        ? CircularProgressIndicator(value: goal.progress / 100)
                        : null,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  GoalFormScreen(goalToEdit: goal)));
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
        context, MaterialPageRoute(builder: (_) => const GoalFormScreen()));
  }
}
