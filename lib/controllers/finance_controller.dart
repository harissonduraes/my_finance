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

  double _total(List<ReceitaModel> rs) {
    double s = 0;
    for (final r in rs) {
      s += r.receita;
    }
    return s;
  }

  double _totalFatura(List<FaturaModel> fs) {
    double s = 0;
    for (final f in fs) {
      s += f.fatura;
    }
    return s;
  }

  double _totalDespesa(List<DespesaModel> ds) {
    double s = 0;
    for (final d in ds) {
      s += d.despesa;
    }
    return s;
  }

  double calcularSaldo(
    List<ReceitaModel> receitas,
    List<FaturaModel> faturas,
    List<DespesaModel> despesas,
  ) {
    return _total(receitas) - (_totalFatura(faturas) + _totalDespesa(despesas));
  }

  double saldoDebito(List<ReceitaModel> receitas, List<DespesaModel> despesas) {
    return _total(receitas) - _totalDespesa(despesas);
  }

  List<SaldoPorCartao> calcularSaldoPorCartao(
    List<ReceitaModel> receitas,
    List<FaturaModel> faturas,
    List<DespesaModel> despesas,
  ) {
    Map<String, List<FaturaModel>> grouped = {};
    for (var f in faturas) {
      grouped.putIfAbsent(f.cartao, () => []).add(f);
    }

    return grouped.entries.map((entry) {
      final cardTotal = entry.value.fold(0.0, (s, f) => s + f.fatura);
      final firstDay = entry.value.first.dia;
      final entrada = receitas
          .where((r) => r.dia == firstDay)
          .fold(0.0, (s, r) => s + r.receita);
      final cardDespesa = despesas
          .where((d) => d.dia == firstDay)
          .fold(0.0, (s, d) => s + d.despesa);
      return SaldoPorCartao(
        cartao: entry.key,
        disponivel: entrada - (cardDespesa + cardTotal),
        total: cardTotal,
        dia: firstDay,
      );
    }).toList();
  }
}
