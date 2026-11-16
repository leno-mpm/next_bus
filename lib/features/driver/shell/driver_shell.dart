import 'package:flutter/material.dart';
import 'package:next_bus/features/driver/views/driver_home_view.dart';
import 'package:next_bus/features/driver/views/driver_profile_view.dart';
import 'package:next_bus/features/driver/views/fuel_view.dart';
import 'package:next_bus/features/driver/views/incident_history_view.dart';

/// Navegación del perfil conductor (C1/C2 en "Inicio", C4, C7, C6). C3 y C5
/// se alcanzan por navegación (push) desde "Inicio", igual que en el
/// mockup — no tienen su propia pestaña.
class DriverShell extends StatefulWidget {
  const DriverShell({super.key});

  @override
  State<DriverShell> createState() => _DriverShellState();
}

class _DriverShellState extends State<DriverShell> {
  int _index = 0;

  // Cada pestaña refleja estado compartido (bus, turno, eventualidades) que
  // otra pestaña puede modificar. Se reconstruye la página seleccionada en
  // cada cambio de pestaña —en lugar de un IndexedStack que las mantendría
  // todas vivas con su primer estado cargado— para que siempre lea el
  // estado más reciente del repositorio.
  Widget _buildPage(int index) {
    return switch (index) {
      0 => const DriverHomeView(),
      1 => const IncidentHistoryView(),
      2 => const FuelView(),
      _ => const DriverProfileView(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPage(_index),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (value) => setState(() => _index = value),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fact_check_outlined),
            label: 'Bitácora',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_gas_station_outlined),
            label: 'Combustible',
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
