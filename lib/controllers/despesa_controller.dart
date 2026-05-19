import 'package:my_finance/models/despesa_model.dart';

import '../repositories/despesa_repository.dart';

class DespesaController {
  final _despesaRepository = DespesaRepository();

  Future<List<DespesaModel>> getAsync() => _despesaRepository.getAllAsync();

  Future<void> insertAsync(double despesa, String dia) async {
    await _despesaRepository.insertAsync(
      DespesaModel(despesa: despesa, dia: dia),
    );
  }

  Future<void> updateAsync(int id, double despesa, String dia) async {
    await _despesaRepository.updateAsync(
      DespesaModel(id: id, despesa: despesa, dia: dia),
    );
  }

  Future<void> deleteAsync(DespesaModel despesa) async {
    await _despesaRepository.deleteAsync(despesa);
  }

  Future<double> getTotalAsync() async {
    final entities = await getAsync();
    double total = 0;
    for (final item in entities) {
      total += item.despesa;
    }
    return total;
  }
}
