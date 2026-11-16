import 'package:flutter/material.dart';
import 'package:next_bus/app/routes/app_routes.dart';
import 'package:next_bus/app/theme/app_colors.dart';
import 'package:next_bus/app/theme/app_text_styles.dart';
import 'package:next_bus/core/widgets/segmented_control.dart';

enum _Role { estudiante, conductor }

/// S1 — pantalla de ingreso. No hay autenticación real (sección 5 del
/// requerimiento): los campos están prellenados y solo deciden a qué
/// perfil navegar.
class ProfileSelectionView extends StatefulWidget {
  const ProfileSelectionView({super.key});

  @override
  State<ProfileSelectionView> createState() => _ProfileSelectionViewState();
}

class _ProfileSelectionViewState extends State<ProfileSelectionView> {
  _Role _role = _Role.estudiante;
  bool _obscure = true;

  String get _user => _role == _Role.estudiante
      ? 'andrea.perez@espol.edu.ec'
      : 'carlos.mendoza@espol.edu.ec';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    color: AppColors.accent900,
                    alignment: Alignment.center,
                    child: const Icon(Icons.directions_bus_filled_rounded,
                        color: AppColors.bg, size: 26),
                  ),
                  const SizedBox(height: 18),
                  Text('Ruta ESPOL',
                      style: AppTextStyles.title.copyWith(
                          color: AppColors.accent900, fontSize: 36)),
                  const SizedBox(height: 6),
                  Text('Inicia sesión para ver tu bus en vivo.',
                      style: AppTextStyles.bodySecondary),
                  const SizedBox(height: 28),
                  SegmentedControl<_Role>(
                    options: const [
                      SegmentOption(value: _Role.estudiante, label: 'Estudiante'),
                      SegmentOption(value: _Role.conductor, label: 'Conductor'),
                    ],
                    value: _role,
                    onChanged: (role) => setState(() => _role = role),
                  ),
                  const SizedBox(height: 18),
                  Text('Usuario', style: AppTextStyles.caption),
                  const SizedBox(height: 6),
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(text: _user),
                    decoration:
                        const InputDecoration(prefixIcon: Icon(Icons.badge_outlined)),
                  ),
                  const SizedBox(height: 14),
                  Text('Contraseña', style: AppTextStyles.caption),
                  const SizedBox(height: 6),
                  TextField(
                    readOnly: true,
                    obscureText: _obscure,
                    controller: TextEditingController(text: 'espol2026'),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        icon: Icon(_obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pushReplacementNamed(
                      _role == _Role.estudiante
                          ? AppRoutes.user
                          : AppRoutes.driver,
                    ),
                    child: const Text('Entrar'),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Versión de demostración — no requiere credenciales reales.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
