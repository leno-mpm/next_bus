abstract class PreferencesRepository {
  Future<Set<String>> getFavoriteStopIds();
  Future<void> toggleFavoriteStop(String stopId);

  /// Interruptores con llave libre (p. ej. `"notify3min:GARE"`,
  /// `"news"`, `"driverSound"`, `"driverBigText"`) — mecanismo genérico
  /// compartido entre S4/S8 (estudiante) y C6 (conductor).
  Future<bool> getToggle(String key, {bool defaultValue = false});
  Future<void> setToggle(String key, bool value);
}

/// Preferencias en memoria durante la sesión; no hay persistencia en disco.
class MockPreferencesRepository implements PreferencesRepository {
  final Set<String> _favoriteStopIds = {'GARE', 'BIB', 'FCV'};
  final Map<String, bool> _toggles = {
    'news': true,
    'driverSound': true,
  };

  @override
  Future<Set<String>> getFavoriteStopIds() async {
    await Future<void>.delayed(const Duration(milliseconds: 80));
    return Set.unmodifiable(_favoriteStopIds);
  }

  @override
  Future<void> toggleFavoriteStop(String stopId) async {
    await Future<void>.delayed(const Duration(milliseconds: 80));
    if (!_favoriteStopIds.remove(stopId)) {
      _favoriteStopIds.add(stopId);
    }
  }

  @override
  Future<bool> getToggle(String key, {bool defaultValue = false}) async {
    await Future<void>.delayed(const Duration(milliseconds: 60));
    return _toggles[key] ?? defaultValue;
  }

  @override
  Future<void> setToggle(String key, bool value) async {
    await Future<void>.delayed(const Duration(milliseconds: 60));
    _toggles[key] = value;
  }
}
