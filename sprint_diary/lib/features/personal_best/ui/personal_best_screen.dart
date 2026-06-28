import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/widgets/loading_state.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/empty_state.dart';
import '../providers/personal_best_provider.dart';

class PersonalBestScreen extends ConsumerWidget {
  const PersonalBestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pbsAsync = ref.watch(personalBestsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Personal Bests')),
      body: pbsAsync.when(
        loading: () => const LoadingState(),
        error: (err, _) => ErrorState(
          message: err.toString(),
          onRetry: () => ref.invalidate(personalBestsProvider),
        ),
        data: (pbs) {
          if (pbs.isEmpty) {
            return const EmptyState(
              message: 'No personal bests recorded yet.',
              icon: Icons.emoji_events,
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: pbs.length,
            itemBuilder: (context, index) {
              final pb = pbs[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: const Icon(Icons.emoji_events, color: Colors.amber),
                  title: Text('${pb.distance}m - ${pb.timing}s'),
                  subtitle: Text(DateFormat.yMMMd().format(pb.date)),
                  trailing: pb.venue != null ? Text(pb.venue!) : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
