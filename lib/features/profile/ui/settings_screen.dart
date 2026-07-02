import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/profile_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          settingsAsync.when(
            loading: () => const ListTile(title: Text('Loading settings...')),
            error: (err, _) => ListTile(title: Text('Error: $err')),
            data: (isDark) => SwitchListTile(
              title: const Text('Dark Mode'),
              value: isDark,
              onChanged: (val) {
                ref
                    .read(profileControllerProvider.notifier)
                    .toggleDarkMode(val);
              },
            ),
          ),
          ListTile(
            title: const Text('About App'),
            leading: const Icon(Icons.info_outline),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Sprint Diary',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2024 Your Name',
              );
            },
          ),
        ],
      ),
    );
  }
}
