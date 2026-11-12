import 'package:flutter/material.dart';
import 'package:next_bus/features/driver/views/driver_home_view.dart';
import 'package:next_bus/features/driver/views/driver_profile_view.dart';
import 'package:next_bus/features/driver/views/incident_history_view.dart';
import 'package:next_bus/features/driver/views/my_trip_view.dart';
import 'package:next_bus/features/driver/views/report_incident_view.dart';

/// Navegación independiente del perfil conductor (sección 5.2), separada
/// por completo de la navegación del usuario.
class DriverShell extends StatefulWidget {
  const DriverShell({super.key});

  @override
  State<DriverShell> createState() => _DriverShellState();
}

class _DriverShellState extends State<DriverShell> {
  int _index = 0;

  // Cada pestaña refleja estado compartido (bus, ruta, recorrido) que otra
  // pestaña puede modificar (p. ej. iniciar/finalizar recorrido en Inicio).
  // Se reconstruye la página seleccionada en cada cambio de pestaña —en
  // lugar de un IndexedStack que las mantendría todas vivas con su primer
  // estado cargado— para que siempre lea el estado más reciente del
  // repositorio.
  Widget _buildPage(int index) {
    return switch (index) {
      0 => const DriverHomeView(),
      1 => const MyTripView(),
      2 => const ReportIncidentView(),
      3 => const IncidentHistoryView(),
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
            icon: Icon(Icons.alt_route_rounded),
            label: 'Mi recorrido',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report_problem_rounded),
            label: 'Incidencia',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_rounded),
            label: 'Historial',
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
