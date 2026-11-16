import 'package:flutter/material.dart';
import 'package:next_bus/features/user/views/home_view.dart';
import 'package:next_bus/features/user/views/notices_view.dart';
import 'package:next_bus/features/user/views/profile_view.dart';
import 'package:next_bus/features/user/views/stops_view.dart';

/// Navegación del perfil estudiante (S2/S3/S7/S8), aislada de la
/// navegación del conductor.
class UserShell extends StatefulWidget {
  const UserShell({super.key});

  @override
  State<UserShell> createState() => _UserShellState();
}

class _UserShellState extends State<UserShell> {
  int _index = 0;

  static const _pages = [
    HomeView(),
    StopsView(),
    NoticesView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (value) => setState(() => _index = value),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pin_drop_rounded),
            label: 'Paradas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            label: 'Avisos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
