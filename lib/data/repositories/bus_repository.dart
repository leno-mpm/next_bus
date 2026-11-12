import 'package:next_bus/data/mock/mock_buses.dart';
import 'package:next_bus/models/bus.dart';

abstract class BusRepository {
  Future<List<Bus>> getAllBuses();
  Future<Bus?> getBusById(String id);
}

class MockBusRepository implements BusRepository {
  @override
  Future<List<Bus>> getAllBuses() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return List.unmodifiable(mockBuses);
  }

  @override
  Future<Bus?> getBusById(String id) async {
    final buses = await getAllBuses();
    for (final bus in buses) {
      if (bus.id == id) return bus;
    }
    return null;
  }
}
