import 'package:flutter/foundation.dart';
import 'package:next_bus/data/repositories/driver_repository.dart';
import 'package:next_bus/data/repositories/preferences_repository.dart';
import 'package:next_bus/models/driver.dart';

/// ViewModel de C6 (perfil del conductor): datos del conductor más dos
/// preferencias de interfaz, con el mismo mecanismo de toggles que S4/S8.
class DriverProfileViewModel extends ChangeNotifier {
  final DriverRepository _driverRepository;
  final PreferencesRepository _preferencesRepository;

  DriverProfileViewModel({
    required DriverRepository driverRepository,
    required PreferencesRepository preferencesRepository,
  })  : _driverRepository = driverRepository,
        _preferencesRepository = preferencesRepository;

  bool isLoading = true;
  Driver? driver;
  bool soundEnabled = true;
  bool bigTextEnabled = false;

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    driver = await _driverRepository.getCurrentDriver();
    soundEnabled = await _preferencesRepository.getToggle('driverSound',
        defaultValue: true);
    bigTextEnabled =
        await _preferencesRepository.getToggle('driverBigText');
    isLoading = false;
    notifyListeners();
  }

  Future<void> setSoundEnabled(bool value) async {
    soundEnabled = value;
    notifyListeners();
    await _preferencesRepository.setToggle('driverSound', value);
  }

  Future<void> setBigTextEnabled(bool value) async {
    bigTextEnabled = value;
    notifyListeners();
    await _preferencesRepository.setToggle('driverBigText', value);
  }
}
