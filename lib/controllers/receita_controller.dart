import 'package:my_finance/models/receita_model.dart';

import '../repositories/receita_repository.dart';

class ReceitaController {
  final _receitaRepository = ReceitaRepository();

  Future<List<ReceitaModel>> getAsync() => _receitaRepository.getAllAsync();

  Future<void> insertAsync(double valor, String dia, String? cartao) async {
    await _receitaRepository.insertAsync(
      ReceitaModel(valor: valor, dia: dia, cartao: cartao),
    );
  }

  Future<void> updateAsync(int id, double valor, String dia, String? cartao) async {
    await _receitaRepository.updateAsync(
      ReceitaModel(id: id, valor: valor, dia: dia, cartao: cartao),
    );
  }

  Future<void> deleteAsync(ReceitaModel receita) async {
    await _receitaRepository.deleteAsync(receita);
  }

  Future<double> getTotalAsync() async {
    final entities = await getAsync();
    double total = 0;
    for (final item in entities) {
      total += item.valor;
    }
    return total;
  }
}
