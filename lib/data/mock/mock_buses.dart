import 'package:next_bus/core/enums/enums.dart';
import 'package:next_bus/models/bus.dart';

/// Flota base (sección 8). Este es el estado "de reposo" que usan Inicio,
/// el perfil del conductor y el historial. Los escenarios de ETA
/// (`mock_etas.dart`) generan sus propias copias con estados distintos sin
/// mutar esta lista.
final List<Bus> mockBuses = [
  const Bus(
    id: 'BUS01',
    name: 'Unidad 01',
    plate: 'GYE-0101',
    status: BusStatus.enRuta,
    routeId: 'R1-SALIDA',
    direction: Direction.salida,
    currentSegmentFromStopId: 'GARE',
    currentSegmentToStopId: 'FCV',
    nextStopId: 'FCV',
  ),
  const Bus(
    id: 'BUS02',
    name: 'Unidad 02',
    plate: 'GYE-0102',
    status: BusStatus.enRuta,
    routeId: 'R1-ENTRADA',
    direction: Direction.entrada,
    currentSegmentFromStopId: 'FCSH',
    currentSegmentToStopId: 'BIB',
    nextStopId: 'BIB',
  ),
  const Bus(
    id: 'BUS03',
    name: 'Unidad 03',
    plate: 'GYE-0103',
    status: BusStatus.disponible,
    routeId: 'R2-SALIDA',
    direction: Direction.salida,
    currentStopId: 'EBUS',
    nextStopId: 'BIB',
  ),
];
