import 'package:next_bus/core/enums/enums.dart';
import 'package:next_bus/data/mock/mock_etas.dart';

/// Contrato de consulta de ETA. En el futuro, `getScenarioData` se reemplaza
/// por una llamada real a la API/motor de predicción (sección 15); mientras
/// tanto expone los escenarios mock centralizados en `mock_etas.dart`.
abstract class EtaRepository {
  List<EtaDemoScenario> getAvailableScenarios();
  Future<EtaScenarioData> getScenarioData(EtaDemoScenario scenario);
}

class MockEtaRepository implements EtaRepository {
  @override
  List<EtaDemoScenario> getAvailableScenarios() => EtaDemoScenario.values;

  @override
  Future<EtaScenarioData> getScenarioData(EtaDemoScenario scenario) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final scenarios = buildMockEtaScenarios();
    final data = scenarios[scenario];
    if (data == null) {
      throw ArgumentError('Escenario sin datos: $scenario');
    }
    return data;
  }
}
