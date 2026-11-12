import 'package:flutter/foundation.dart';
import 'package:next_bus/data/repositories/stop_repository.dart';
import 'package:next_bus/models/stop.dart';

class StopsViewModel extends ChangeNotifier {
  final StopRepository _stopRepository;

  StopsViewModel({required StopRepository stopRepository})
      : _stopRepository = stopRepository;

  bool isLoading = true;
  String? errorMessage;
  List<Stop> _stops = const [];
  String query = '';

  List<Stop> get stops {
    if (query.trim().isEmpty) return _stops;
    final normalized = query.trim().toLowerCase();
    return _stops.where((stop) {
      return stop.name.toLowerCase().contains(normalized) ||
          stop.id.toLowerCase().contains(normalized);
    }).toList();
  }

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      _stops = await _stopRepository.getAllStops();
    } catch (e) {
      errorMessage = 'No se pudieron cargar las paradas.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setQuery(String value) {
    query = value;
    notifyListeners();
  }
}
