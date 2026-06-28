import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/loading_state.dart';
import '../../../core/widgets/error_state.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/profile_model.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _eventController;
  late TextEditingController _clubController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _eventController = TextEditingController();
    _clubController = TextEditingController();
    _heightController = TextEditingController();
    _weightController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _eventController.dispose();
    _clubController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _populateControllers(ProfileModel profile) {
    _nameController.text = profile.fullName ?? '';
    _eventController.text = profile.preferredEvent ?? '';
    _clubController.text = profile.club ?? '';
    _heightController.text = profile.height?.toString() ?? '';
    _weightController.text = profile.weight?.toString() ?? '';
  }

  Future<void> _saveProfile(ProfileModel currentProfile) async {
    if (!_formKey.currentState!.validate()) return;

    final updatedProfile = currentProfile.copyWith(
      fullName: _nameController.text.isEmpty ? null : _nameController.text,
      preferredEvent:
          _eventController.text.isEmpty ? null : _eventController.text,
      club: _clubController.text.isEmpty ? null : _clubController.text,
      height: double.tryParse(_heightController.text),
      weight: double.tryParse(_weightController.text),
    );

    await ref
        .read(profileControllerProvider.notifier)
        .updateProfile(updatedProfile);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings (handled via GoRouter later)
            },
          ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const LoadingState(),
        error: (error, _) => ErrorState(
          message: error.toString(),
          onRetry: () => ref.invalidate(profileProvider),
        ),
        data: (profile) {
          if (profile == null) {
            // Create initial profile object if it doesn't exist
            profile = ProfileModel(id: user!.id, email: user.email);
          }

          _populateControllers(profile);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.p16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person, size: 50),
                  ),
                  const SizedBox(height: AppSizes.p24),
                  CustomTextField(
                    controller: _nameController,
                    label: 'Full Name',
                    prefixIcon: Icons.person_outline,
                  ),
                  const SizedBox(height: AppSizes.p16),
                  CustomTextField(
                    controller: _eventController,
                    label: 'Preferred Event (e.g. 100m)',
                    prefixIcon: Icons.directions_run,
                  ),
                  const SizedBox(height: AppSizes.p16),
                  CustomTextField(
                    controller: _clubController,
                    label: 'Club / Team',
                    prefixIcon: Icons.shield_outlined,
                  ),
                  const SizedBox(height: AppSizes.p16),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _heightController,
                          label: 'Height (cm)',
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.height,
                        ),
                      ),
                      const SizedBox(width: AppSizes.p16),
                      Expanded(
                        child: CustomTextField(
                          controller: _weightController,
                          label: 'Weight (kg)',
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.monitor_weight_outlined,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.p32),
                  CustomButton(
                    text: 'Save Profile',
                    onPressed: () => _saveProfile(profile!),
                    isLoading: ref.watch(profileControllerProvider).isLoading,
                  ),
                  const SizedBox(height: AppSizes.p16),
                  CustomButton(
                    text: 'Sign Out',
                    onPressed: () {
                      ref.read(authControllerProvider.notifier).signOut();
                    },
                    isOutlined: true,
                    icon: Icons.logout,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
