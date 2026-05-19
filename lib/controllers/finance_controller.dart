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
      soma += receita.valor;
    }
    return soma;
  }

  double _totalFatura(List<FaturaModel> faturas) {
    double soma = 0;
    for (final fatura in faturas) {
      soma += fatura.valor;
    }
    return soma;
  }

  double _totalDespesa(List<DespesaModel> despesas) {
    double soma = 0;
    for (final despesa in despesas) {
      soma += despesa.valor;
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
        (soma, fatura) => soma + fatura.valor,
      );
      final dia = entry.value.single.dia;
      final entrada = receitas
          .where((w) => w.dia == dia)
          .fold(0.0, (saldo, receita) => saldo + receita.valor);
      final cardDespesa = despesas
          .where((d) => d.dia == dia)
          .fold(0.0, (saldo, despesa) => saldo + despesa.valor);
      return SaldoPorCartao(
        cartao: entry.key,
        disponivel: entrada - (cardDespesa + cardTotal),
        total: cardTotal,
        dia: dia,
      );
    }).toList();
  }
}
