import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_sizes.dart';
import '../../auth/providers/auth_provider.dart';
import '../../profile/providers/profile_provider.dart';
import '../../training/providers/training_provider.dart';
import '../../goals/providers/goal_provider.dart';

import '../../goals/ui/goal_list_screen.dart';
import '../../goals/ui/goal_form_screen.dart';
import '../../calendar/ui/calendar_screen.dart';
import '../../personal_best/ui/personal_best_screen.dart';
import '../../measurements/ui/measurement_screen.dart';
import '../../notes/ui/notes_list_screen.dart';
import '../../reminders/ui/reminder_list_screen.dart';
import '../../training/ui/training_form_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final profileAsync = ref.watch(profileProvider);
    final logsAsync = ref.watch(trainingLogsProvider);
    final goalsAsync = ref.watch(goalsProvider);

    final today = DateTime.now();
    final todayStr = DateFormat('EEEE, MMMM d').format(today);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(profileProvider);
            ref.invalidate(trainingLogsProvider);
            ref.invalidate(goalsProvider);
          },
          child: ListView(
            padding: const EdgeInsets.all(AppSizes.p16),
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todayStr,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      profileAsync.when(
                        data: (p) => Text(
                          'Hello, ${p?.fullName ?? user?.email.split('@').first ?? 'Athlete'}!',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        loading: () => const Text('Loading...'),
                        error: (_, __) => const Text('Hello!'),
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.p24),

              // Motivational Quote
              Card(
                color: Theme.of(context).colorScheme.primary,
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.p16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '"Hard work beats talent when talent doesn\'t work hard."',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                      const SizedBox(height: AppSizes.p8),
                      Text(
                        '- Tim Notke',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.p24),

              // Quick Actions
              Text('Quick Actions',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSizes.p8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildActionButton(context, Icons.calendar_month,
                        'Calendar', const CalendarScreen()),
                    _buildActionButton(context, Icons.emoji_events, 'Best',
                        const PersonalBestScreen()),
                    _buildActionButton(context, Icons.monitor_weight, 'Body',
                        const MeasurementScreen()),
                    _buildActionButton(context, Icons.book, 'Journal',
                        const NotesListScreen()),
                    _buildActionButton(context, Icons.alarm, 'Reminders',
                        const ReminderListScreen()),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.p24),

              // Today's Workout Summary
              Text('Today\'s Overview',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSizes.p16),
              logsAsync.when(
                data: (logs) {
                  final todayLogs =
                      logs.where((l) => isSameDay(l.date, today)).toList();
                  if (todayLogs.isEmpty) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSizes.p16),
                        child: Row(
                          children: [
                            const Icon(Icons.hotel_class, color: Colors.amber),
                            const SizedBox(width: AppSizes.p16),
                            const Expanded(
                                child:
                                    Text('Rest day or no workout logged yet.')),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const TrainingFormScreen()));
                                },
                                child: const Text('Log')),
                          ],
                        ),
                      ),
                    );
                  }
                  return Card(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: todayLogs.length,
                      itemBuilder: (context, index) {
                        final log = todayLogs[index];
                        return ListTile(
                          leading: const Icon(Icons.directions_run),
                          title: Text(log.trainingType),
                          subtitle: Text(log.notes ?? ''),
                        );
                      },
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Error loading logs: $e'),
              ),
              const SizedBox(height: AppSizes.p24),

              // Current Goals Overview
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Active Goals',
                      style: Theme.of(context).textTheme.titleMedium),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const GoalListScreen()));
                      },
                      child: const Text('View All'))
                ],
              ),
              const SizedBox(height: AppSizes.p8),
              goalsAsync.when(
                data: (goals) {
                  final activeGoals =
                      goals.where((g) => !g.completed).take(2).toList();
                  if (activeGoals.isEmpty) {
                    return Card(
                      child: Padding(
                          padding: const EdgeInsets.all(AppSizes.p16),
                          child: Row(children: [
                            const Expanded(
                                child:
                                    Text('No active goals. Time to set one!')),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const GoalFormScreen()));
                                },
                                child: const Text('Add Goal'))
                          ])),
                    );
                  }
                  return Column(
                    children: activeGoals
                        .map((g) => Card(
                              margin:
                                  const EdgeInsets.only(bottom: AppSizes.p8),
                              child: ListTile(
                                leading: const Icon(Icons.flag_outlined),
                                title: Text(g.title),
                                trailing: CircularProgressIndicator(
                                    value: g.progress / 100),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              GoalFormScreen(goalToEdit: g)));
                                },
                              ),
                            ))
                        .toList(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Error loading goals: $e'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
      BuildContext context, IconData icon, String label, Widget screen) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton.filledTonal(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => screen));
            },
            icon: Icon(icon),
          ),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
