import '../models/despesa_model.dart';
import '../models/fatura_model.dart';
import '../models/receita_model.dart';
import '../repositories/despesa_repository.dart';
import '../repositories/fatura_repository.dart';
import '../repositories/receita_repository.dart';
import '../view_models/saldo_por_cartao.dart';

class FinanceController {
  final _faturaRepository = FaturaRepository();
  final _receitaRepository = ReceitaRepository();
  final _despesaRepository = DespesaRepository();

  Future<List<ReceitaModel>> getReceitasAsync() =>
      _receitaRepository.getAllAsync();

  Future<List<FaturaModel>> getFaturasAsync() =>
      _faturaRepository.getAllAsync();

  Future<List<DespesaModel>> getDespesasAsync() =>
      _despesaRepository.getAllAsync();

  double _total(List<ReceitaModel> receitas) {
    double soma = 0;
    for (final receita in receitas) {
      soma += receita.receita;
    }
    return soma;
  }

  double _totalFatura(List<FaturaModel> faturas) {
    double soma = 0;
    for (final fatura in faturas) {
      soma += fatura.fatura;
    }
    return soma;
  }

  double _totalDespesa(List<DespesaModel> despesas) {
    double soma = 0;
    for (final despesa in despesas) {
      soma += despesa.despesa;
    }
    return soma;
  }

  double calcularSaldo(
    List<ReceitaModel> receitas,
    List<FaturaModel> faturas,
    List<DespesaModel> despesas,
  ) {
    return _total(receitas) - (_totalFatura(faturas) + _totalDespesa(despesas));
  }

  // double saldoDebito(List<ReceitaModel> receitas, List<DespesaModel> despesas) {
  //   return _total(receitas) - _totalDespesa(despesas);
  // }

  List<SaldoPorCartao> calcularSaldoPorCartao(
    List<ReceitaModel> receitas,
    List<FaturaModel> faturas,
    List<DespesaModel> despesas,
  ) {
    Map<String, List<FaturaModel>> grouped = {};
    for (var fatura in faturas) {
      grouped.putIfAbsent(fatura.cartao, () => []).add(fatura);
    }

    return grouped.entries.map((entry) {
      final cardTotal = entry.value.fold(
        0.0,
        (soma, fatura) => soma + fatura.fatura,
      );
      final firstDay = entry.value.first.dia;
      final entrada = receitas
          .where((w) => w.dia == firstDay)
          .fold(0.0, (saldo, receita) => saldo + receita.receita);
      final cardDespesa = despesas
          .where((d) => d.dia == firstDay)
          .fold(0.0, (saldo, despesa) => saldo + despesa.despesa);
      return SaldoPorCartao(
        cartao: entry.key,
        disponivel: entrada - (cardDespesa + cardTotal),
        total: cardTotal,
        dia: firstDay,
      );
    }).toList();
  }
}
