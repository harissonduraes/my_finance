import 'package:flutter/material.dart';
import 'package:my_finance/controllers/despesa_controller.dart';
import 'package:my_finance/controllers/fatura_controller.dart';
import 'package:my_finance/controllers/finance_controller.dart';
import 'package:my_finance/controllers/receita_controller.dart';
import 'package:my_finance/models/despesa_model.dart';
import 'package:my_finance/models/fatura_model.dart';
import 'package:my_finance/models/receita_model.dart';
import 'package:my_finance/view_models/saldo_por_cartao.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final FinanceController _controller = FinanceController();
  final ReceitaController _receitaController = ReceitaController();
  final FaturaController _faturaController = FaturaController();
  final DespesaController _despesaController = DespesaController();

  List<ReceitaModel> _receitas = [];
  List<FaturaModel> _faturas = [];
  List<DespesaModel> _despesas = [];
  double _receitaTotal = 0;
  double _faturaTotal = 0;
  double _despesaTotal = 0;
  double _saldoDisponivel = 0;
  double _saldoDebito = 0;
  List<SaldoPorCartao> _saldoPorCartao = [];

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    _receitas = await _controller.getReceitasAsync();
    _faturas = await _controller.getFaturasAsync();
    _despesas = await _controller.getDespesasAsync();

    _saldoDisponivel = _controller.calcularSaldo(
      _receitas,
      _faturas,
      _despesas,
    );
    _saldoDebito = _controller.saldoDebito(_receitas, _despesas);
    _saldoPorCartao = _controller.calcularSaldoPorCartao(
      _receitas,
      _faturas,
      _despesas,
    );

    _receitaTotal = await _receitaController.getTotalAsync();
    _faturaTotal = await _faturaController.getTotalAsync();
    _despesaTotal = await _despesaController.getTotalAsync();

    setState(() {});
  }

  void _showFormModal({
    required String titulo,
    double? valorInicial,
    String? diaInicial,
    String? cartaoInicial,
    bool mostraCartao = false,
    required Future<void> Function(double valor, String dia, String? cartao)
    onSave,
  }) {
    final valorCtrl = TextEditingController(
      text: valorInicial?.toStringAsFixed(2),
    );
    final diaCtrl = TextEditingController(text: diaInicial ?? '05');
    final cartaoCtrl = mostraCartao
        ? TextEditingController(text: cartaoInicial)
        : null;
    final cardNames = mostraCartao
        ? _faturas.map((f) => f.cartao).toSet().toList()
        : <String>[];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              titulo,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (mostraCartao) ...[
              TextField(
                controller: cartaoCtrl,
                decoration: const InputDecoration(
                  labelText: "Nome do cartão",
                  border: OutlineInputBorder(),
                ),
              ),
              if (cardNames.isNotEmpty) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: cardNames
                        .map(
                          (name) => ActionChip(
                            label: Text(
                              name,
                              style: const TextStyle(fontSize: 12),
                            ),
                            onPressed: () => cartaoCtrl!.text = name,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
              const SizedBox(height: 12),
            ],
            TextField(
              controller: valorCtrl,
              decoration: const InputDecoration(
                labelText: "Valor",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: diaCtrl,
              decoration: InputDecoration(
                labelText: mostraCartao ? "Dia de vencimento" : "Dia",
                border: const OutlineInputBorder(),
                hintText: "1-31",
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: () async {
                final valor = double.tryParse(valorCtrl.text);
                final dia = diaCtrl.text;
                if (valor == null || dia.isEmpty) return;
                if (mostraCartao &&
                    (cartaoCtrl == null || cartaoCtrl.text.isEmpty))
                  return;
                await onSave(valor, dia, cartaoCtrl?.text);
                // ignore: use_build_context_synchronously
                if (!context.mounted) return;
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
                _refreshData();
              },
              child: const Text("Salvar"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteReceita(ReceitaModel item) async {
    await _receitaController.deleteAsync(item);
    _refreshData();
  }

  Future<void> _deleteFatura(FaturaModel item) async {
    await _faturaController.deleteAsync(item);
    _refreshData();
  }

  Future<void> _deleteDespesa(DespesaModel item) async {
    await _despesaController.deleteAsync(item);
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Meu Financeiro"), centerTitle: true),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView(
              children: [
                if (_saldoPorCartao.isNotEmpty) _buildPerCardSection(),
                _buildSection(
                  titulo: "RECEITA TOTAL",
                  valor: _receitaTotal,
                  cor: Colors.green,
                  onAdd: () => _showFormModal(
                    titulo: "Adicionar Receita",
                    onSave: (v, d, _) => _receitaController.insertAsync(v, d),
                  ),
                  items: _receitas
                      .map(
                        (r) => _buildItemRow(
                          titulo: "R\$ ${r.receita.toStringAsFixed(2)}",
                          subtitulo: "Dia ${r.dia}",
                          cor: Colors.green,
                          onEdit: () => _showFormModal(
                            titulo: "Editar Receita",
                            valorInicial: r.receita,
                            diaInicial: r.dia,
                            onSave: (v, d, _) =>
                                _receitaController.updateAsync(r.id!, v, d),
                          ),
                          onDelete: () => _deleteReceita(r),
                        ),
                      )
                      .toList(),
                ),
                _buildSection(
                  titulo: "FATURA TOTAL",
                  valor: _faturaTotal,
                  cor: Colors.orange,
                  onAdd: () => _showFormModal(
                    titulo: "Adicionar Fatura",
                    mostraCartao: true,
                    onSave: (v, d, c) =>
                        _faturaController.insertAsync(v, c ?? "", d),
                  ),
                  items: _faturas
                      .map(
                        (f) => _buildItemRow(
                          titulo:
                              "${f.cartao} - R\$ ${f.fatura.toStringAsFixed(2)}",
                          subtitulo: "Vencimento dia ${f.dia}",
                          cor: Colors.orange,
                          onEdit: () => _showFormModal(
                            titulo: "Editar Fatura",
                            valorInicial: f.fatura,
                            diaInicial: f.dia,
                            cartaoInicial: f.cartao,
                            mostraCartao: true,
                            onSave: (v, d, c) => _faturaController.updateAsync(
                              f.id!,
                              v,
                              c ?? "",
                              d,
                            ),
                          ),
                          onDelete: () => _deleteFatura(f),
                        ),
                      )
                      .toList(),
                ),
                _buildSection(
                  titulo: "DESPESA TOTAL",
                  valor: _despesaTotal,
                  cor: Colors.red,
                  onAdd: () => _showFormModal(
                    titulo: "Adicionar Despesa Fixa",
                    onSave: (v, d, _) => _despesaController.insertAsync(v, d),
                  ),
                  items: _despesas
                      .map(
                        (d) => _buildItemRow(
                          titulo: "R\$ ${d.despesa.toStringAsFixed(2)}",
                          subtitulo: "Dia ${d.dia}",
                          cor: Colors.red,
                          onEdit: () => _showFormModal(
                            titulo: "Editar Despesa Fixa",
                            valorInicial: d.despesa,
                            diaInicial: d.dia,
                            onSave: (v, d2, _) =>
                                _despesaController.updateAsync(d.id!, v, d2),
                          ),
                          onDelete: () => _deleteDespesa(d),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(color: Color(0xFF1976D2)),
      child: Column(
        children: [
          const Text(
            "SALDO DISPONÍVEL",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Text(
            "R\$ ${_saldoDisponivel.toStringAsFixed(2)}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMiniLabel("DÉBITO", _saldoDebito, Colors.greenAccent),
              _buildMiniLabel("CARTÃO", _faturaTotal, Colors.orangeAccent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniLabel(String label, double valor, Color cor) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white60, fontSize: 11),
        ),
        const SizedBox(height: 4),
        Text(
          "R\$ ${valor.toStringAsFixed(2)}",
          style: TextStyle(
            color: cor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPerCardSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "LIMITE POR CARTÃO",
            style: TextStyle(
              color: Color(0xFF616161),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ..._saldoPorCartao.map(
            (item) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade50,
                  child: Icon(Icons.credit_card, color: Colors.blue.shade700),
                ),
                title: Text(
                  item.cartao,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  "Vence dia ${item.dia} • Total: R\$ ${item.total.toStringAsFixed(2)}",
                ),
                trailing: Text(
                  "R\$ ${item.disponivel.toStringAsFixed(2)}",
                  style: TextStyle(
                    color: item.disponivel >= 0 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String titulo,
    required double valor,
    required Color cor,
    required VoidCallback onAdd,
    required List<Widget> items,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                titulo,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
              Text(
                "R\$ ${valor.toStringAsFixed(2)}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: cor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          OutlinedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add, size: 18),
            label: const Text("Adicionar"),
            style: OutlinedButton.styleFrom(
              foregroundColor: cor,
              side: BorderSide(color: cor.withValues(alpha: 0.5)),
              minimumSize: const Size(double.infinity, 40),
            ),
          ),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "Nenhum registro",
                style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
              ),
            )
          else
            ...items,
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildItemRow({
    required String titulo,
    required String subtitulo,
    required Color cor,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return Card(
      margin: const EdgeInsets.only(top: 6),
      child: ListTile(
        dense: true,
        leading: Container(
          width: 4,
          height: 32,
          decoration: BoxDecoration(
            color: cor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        title: Text(titulo, style: const TextStyle(fontSize: 14)),
        subtitle: Text(
          subtitulo,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20),
              color: Colors.grey.shade400,
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              color: Colors.red.shade300,
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
