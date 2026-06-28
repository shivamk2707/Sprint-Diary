import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/widgets/loading_state.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/empty_state.dart';
import '../providers/measurement_provider.dart';

class MeasurementScreen extends ConsumerWidget {
  const MeasurementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final measurementsAsync = ref.watch(measurementsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Body Measurements')),
      body: measurementsAsync.when(
        loading: () => const LoadingState(),
        error: (err, _) => ErrorState(
          message: err.toString(),
          onRetry: () => ref.invalidate(measurementsProvider),
        ),
        data: (measurements) {
          if (measurements.isEmpty) {
            return const EmptyState(
              message: 'No measurements recorded.',
              icon: Icons.monitor_weight,
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: measurements.length,
            itemBuilder: (context, index) {
              final m = measurements[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  title: Text(DateFormat.yMMMd().format(m.date)),
                  subtitle: Text(
                      'Weight: ${m.weight ?? '-'}kg | HR: ${m.heartRate ?? '-'}bpm'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
