import 'package:next_bus/data/mock/mock_stops.dart';
import 'package:next_bus/models/stop.dart';

/// Contrato de acceso a paradas. La implementación mock puede sustituirse
/// por una implementación HTTP sin tocar ViewModels ni vistas.
abstract class StopRepository {
  Future<List<Stop>> getAllStops();
  Future<Stop?> getStopById(String id);
}

class MockStopRepository implements StopRepository {
  @override
  Future<List<Stop>> getAllStops() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return List.unmodifiable(mockStops);
  }

  @override
  Future<Stop?> getStopById(String id) async {
    final stops = await getAllStops();
    for (final stop in stops) {
      if (stop.id == id) return stop;
    }
    return null;
  }
}
