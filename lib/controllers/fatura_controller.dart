import '../models/fatura_model.dart';
import '../repositories/fatura_repository.dart';

class FaturaController {
  final _faturaRepository = FaturaRepository();

  Future<List<FaturaModel>> getAsync() => _faturaRepository.getAllAsync();

  Future<void> insertAsync(double valor, String cartao, String dia) async {
    await _faturaRepository.insertAsync(
      FaturaModel(valor: valor, cartao: cartao, dia: dia),
    );
  }

  Future<void> updateAsync(int id, double valor, String cartao, String dia) async {
    await _faturaRepository.updateAsync(
      FaturaModel(id: id, valor: valor, cartao: cartao, dia: dia),
    );
  }

  Future<void> deleteAsync(FaturaModel fatura) async {
    await _faturaRepository.deleteAsync(fatura);
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
