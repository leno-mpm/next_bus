import 'package:flutter/foundation.dart';
import 'package:next_bus/data/repositories/preferences_repository.dart';
import 'package:next_bus/data/repositories/stop_repository.dart';
import 'package:next_bus/models/stop.dart';

/// ViewModel de S8 (perfil del estudiante): paradas favoritas (con estrella
/// para marcar/desmarcar cualquier parada) y preferencias de notificación,
/// ambas en `PreferencesRepository`.
class ProfileViewModel extends ChangeNotifier {
  final StopRepository _stopRepository;
  final PreferencesRepository _preferencesRepository;

  ProfileViewModel({
    required StopRepository stopRepository,
    required PreferencesRepository preferencesRepository,
  })  : _stopRepository = stopRepository,
        _preferencesRepository = preferencesRepository;

  bool isLoading = true;
  List<Stop> allStops = const [];
  Set<String> favoriteStopIds = const {};
  bool newsEnabled = true;

  bool isFavorite(String stopId) => favoriteStopIds.contains(stopId);

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    allStops = await _stopRepository.getAllStops();
    favoriteStopIds = await _preferencesRepository.getFavoriteStopIds();
    newsEnabled =
        await _preferencesRepository.getToggle('news', defaultValue: true);
    isLoading = false;
    notifyListeners();
  }

  Future<void> toggleFavorite(String stopId) async {
    await _preferencesRepository.toggleFavoriteStop(stopId);
    favoriteStopIds = await _preferencesRepository.getFavoriteStopIds();
    notifyListeners();
  }

  Future<void> setNewsEnabled(bool value) async {
    newsEnabled = value;
    notifyListeners();
    await _preferencesRepository.setToggle('news', value);
  }
}
