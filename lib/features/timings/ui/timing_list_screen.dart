import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/widgets/loading_state.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/empty_state.dart';
import '../providers/timing_provider.dart';
import 'timing_form_screen.dart';

class TimingListScreen extends ConsumerWidget {
  const TimingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timingsAsync = ref.watch(timingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Sprint Timings')),
      body: timingsAsync.when(
        loading: () => const LoadingState(),
        error: (err, _) => ErrorState(
          message: err.toString(),
          onRetry: () => ref.invalidate(timingsProvider),
        ),
        data: (timings) {
          if (timings.isEmpty) {
            return EmptyState(
              message: 'No timings recorded yet.',
              icon: Icons.timer,
              actionLabel: 'Add First Timing',
              onAction: () => _navigateToAdd(context),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(timingsProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: timings.length,
              itemBuilder: (context, index) {
                final timing = timings[index];
                final isImproved = (timing.improvement ?? 0) > 0;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    title: Text('${timing.distance}m - ${timing.timing}s',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(DateFormat.yMMMd().format(timing.date)),
                    trailing: timing.improvement != null
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                  isImproved
                                      ? Icons.arrow_upward
                                      : Icons.arrow_downward,
                                  color: isImproved ? Colors.green : Colors.red,
                                  size: 16),
                              Text(
                                  '${timing.improvement!.abs().toStringAsFixed(2)}s',
                                  style: TextStyle(
                                      color: isImproved
                                          ? Colors.green
                                          : Colors.red)),
                            ],
                          )
                        : null,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  TimingFormScreen(timingToEdit: timing)));
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
        context, MaterialPageRoute(builder: (_) => const TimingFormScreen()));
  }
}
