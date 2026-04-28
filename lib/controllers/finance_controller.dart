import '../models/finance_model.dart';
import '../repositories/finance_repository.dart';

class FinanceController {
  final FinanceRepository _repository = FinanceRepository();

  Future<FinanceModel?> getAsync() async {
    final list = await _repository.getAllAsync();
    return list.isNotEmpty ? list.first : null;
  }

  Future<void> insertAsync(FinanceModel newData, FinanceModel? currentData) async {
    if (currentData == null) {
      await _repository.insertAsync(newData);
    } else {
      final modelToUpdate = FinanceModel(
        id: currentData.id,
        ganhoDia05: newData.ganhoDia05,
        ganhoDia20: newData.ganhoDia20,
        faturaDia05: newData.faturaDia05,
        faturaDia20: newData.faturaDia20,
        despesaFixaDia05: newData.despesaFixaDia05,
        despesaFixaDia20: newData.despesaFixaDia20,
      );
      await _repository.updateAsync(modelToUpdate);
    }
  }

  double calcularLimiteDisponivel(FinanceModel data) {
    double entradas = data.ganhoDia05 + data.ganhoDia20;
    double saidas = data.faturaDia05 + data.faturaDia20 +
        data.despesaFixaDia05 + data.despesaFixaDia20;

    return entradas - saidas;
  }

  double calcularLimiteDisponivelDia05(FinanceModel data) {
    double entrada = data.ganhoDia05;
    double saida = data.faturaDia05 + data.despesaFixaDia05;

    return entrada - saida;
  }

  double calcularLimiteDisponivelDia20(FinanceModel data){
    double entrada = data.ganhoDia20;
    double saida = data.faturaDia20 + data.despesaFixaDia20;

    return entrada - saida;
  }
}