import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:next_bus/app/routes/app_routes.dart';
import 'package:next_bus/app/theme/app_colors.dart';
import 'package:next_bus/app/theme/app_text_styles.dart';
import 'package:next_bus/data/repositories/driver_repository.dart';
import 'package:next_bus/models/driver.dart';

class DriverProfileView extends StatelessWidget {
  const DriverProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil del conductor')),
      body: FutureBuilder<Driver>(
        future: context.read<DriverRepository>().getCurrentDriver(),
        builder: (context, snapshot) {
          final driver = snapshot.data;
          if (driver == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        backgroundColor: AppColors.navy,
                        child: Icon(Icons.badge_rounded,
                            color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(driver.name, style: AppTextStyles.cardTitle),
                            const SizedBox(height: 2),
                            Text('Licencia ${driver.licenseId}',
                                style: AppTextStyles.bodySecondary),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.directions_bus_rounded,
                          color: AppColors.navy),
                      title: const Text('Unidad asignada'),
                      subtitle: Text(driver.assignedBusId),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.alt_route_rounded,
                          color: AppColors.navy),
                      title: const Text('Ruta asignada'),
                      subtitle: Text(driver.assignedRouteId),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.swap_horiz_rounded,
                          color: AppColors.navy),
                      title: const Text('Cambiar de perfil'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () =>
                          Navigator.of(context).pushNamedAndRemoveUntil(
                        AppRoutes.profileSelection,
                        (route) => false,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
