import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_sizes.dart';
import '../../auth/providers/auth_provider.dart';
import '../../profile/providers/profile_provider.dart';
import '../../training/providers/training_provider.dart';
import '../../goals/providers/goal_provider.dart';

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
                                onPressed: () {}, child: const Text('Log')),
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
              Text('Active Goals',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSizes.p16),
              goalsAsync.when(
                data: (goals) {
                  final activeGoals =
                      goals.where((g) => !g.completed).take(2).toList();
                  if (activeGoals.isEmpty) {
                    return const Card(
                      child: Padding(
                        padding: EdgeInsets.all(AppSizes.p16),
                        child: Text('No active goals. Time to set one!'),
                      ),
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

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
