import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:next_bus/app/routes/app_routes.dart';
import 'package:next_bus/app/theme/app_colors.dart';
import 'package:next_bus/app/theme/app_text_styles.dart';
import 'package:next_bus/data/repositories/preferences_repository.dart';
import 'package:next_bus/data/repositories/stop_repository.dart';
import 'package:next_bus/features/user/viewmodels/profile_viewmodel.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileViewModel>(
      create: (ctx) => ProfileViewModel(
        stopRepository: ctx.read<StopRepository>(),
        preferencesRepository: ctx.read<PreferencesRepository>(),
      )..load(),
      child: const _ProfileBody(),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: vm.isLoading && vm.allStops.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      alignment: Alignment.center,
                      color: AppColors.accent900,
                      child: Text('AP',
                          style: AppTextStyles.title.copyWith(color: AppColors.bg)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Andrea Pérez', style: AppTextStyles.sectionTitle),
                          Text('Matrícula 202104587 · FIEC',
                              style: AppTextStyles.bodySecondary),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Text('Paradas favoritas', style: AppTextStyles.sectionTitle),
                const SizedBox(height: 6),
                ...vm.allStops.map((stop) => _FavoriteRow(
                      stopId: stop.id,
                      name: stop.name,
                      favorite: vm.isFavorite(stop.id),
                      onToggle: () =>
                          context.read<ProfileViewModel>().toggleFavorite(stop.id),
                    )),
                const SizedBox(height: 22),
                Text('Notificaciones', style: AppTextStyles.sectionTitle),
                const SizedBox(height: 4),
                _PreferenceRow(
                  title: 'Avisos y novedades',
                  subtitle: 'Retrasos, desvíos y cambios de ruta',
                  value: vm.newsEnabled,
                  onChanged: (v) =>
                      context.read<ProfileViewModel>().setNewsEnabled(v),
                ),
                const SizedBox(height: 22),
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.profileSelection,
                    (route) => false,
                  ),
                  icon: const Icon(Icons.swap_horiz_rounded),
                  label: const Text('Cambiar de perfil'),
                ),
              ],
            ),
    );
  }
}

class _FavoriteRow extends StatelessWidget {
  final String stopId;
  final String name;
  final bool favorite;
  final VoidCallback onToggle;

  const _FavoriteRow({
    required this.stopId,
    required this.name,
    required this.favorite,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.neutral300)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 44,
              child: Text(stopId, style: AppTextStyles.caption),
            ),
            Expanded(
              child: Text(name,
                  overflow: TextOverflow.ellipsis, style: AppTextStyles.body),
            ),
            Icon(
              favorite ? Icons.star_rounded : Icons.star_outline_rounded,
              color: favorite ? AppColors.accent : AppColors.neutral500,
            ),
          ],
        ),
      ),
    );
  }
}

class _PreferenceRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _PreferenceRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.cardTitle),
              Text(subtitle, style: AppTextStyles.caption),
            ],
          ),
        ),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}
