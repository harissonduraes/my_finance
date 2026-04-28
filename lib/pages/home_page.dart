import 'package:flutter/material.dart';
import '../controllers/finance_controller.dart';
import '../models/finance_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FinanceController _controller = FinanceController();

  final _g5Controller = TextEditingController();
  final _g20Controller = TextEditingController();
  final _f5Controller = TextEditingController();
  final _f20Controller = TextEditingController();
  final _df5Controller = TextEditingController();
  final _df20Controller = TextEditingController();

  FinanceModel? _currentData;
  double _limiteDisponivel = 0;
  double _limiteDisponivelDia05 = 0;
  double _limiteDisponivelDia20 = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await _controller.getAsync();
    if (data != null) {
      setState(() {
        _currentData = data;
        _limiteDisponivel = _controller.calcularLimiteDisponivel(data);
        _limiteDisponivelDia05 = _controller.calcularLimiteDisponivelDia05(data);
        _limiteDisponivelDia20 = _controller.calcularLimiteDisponivelDia20(data);

        _g5Controller.text = data.ganhoDia05.toString();
        _g20Controller.text = data.ganhoDia20.toString();
        _f5Controller.text = data.faturaDia05.toString();
        _f20Controller.text = data.faturaDia20.toString();
        _df5Controller.text = data.despesaFixaDia05.toString();
        _df20Controller.text = data.despesaFixaDia20.toString();
      });
    }
  }

  Future<void> _save() async {
    final newData = FinanceModel(
      ganhoDia05: double.tryParse(_g5Controller.text) ?? 0.0,
      ganhoDia20: double.tryParse(_g20Controller.text) ?? 0.0,
      faturaDia05: double.tryParse(_f5Controller.text) ?? 0.0,
      faturaDia20: double.tryParse(_f20Controller.text) ?? 0.0,
      despesaFixaDia05: double.tryParse(_df5Controller.text) ?? 0.0,
      despesaFixaDia20: double.tryParse(_df20Controller.text) ?? 0.0
    );

    await _controller.insertAsync(newData, _currentData);
    await _loadData();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Dados atualizados com sucesso!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Controle Financeiro")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildResultCard(),
            SizedBox(height: 20),
            _buildSectionTitle("Ganhos Mensais"),
            _buildTextField(_g5Controller, "Ganho do Dia 05"),
            _buildTextField(_g20Controller, "Ganho do Dia 20"),
            SizedBox(height: 20),
            _buildSectionTitle("Faturas de Cartão"),
            _buildTextField(_f5Controller, "Fatura do Dia 05"),
            _buildTextField(_f20Controller, "Fatura do Dia 20"),
            SizedBox(height: 20),
            _buildSectionTitle("Despesas Fixas (Aluguel, Luz, etc)"),
            _buildTextField(_df5Controller, "Despesa Fixa Dia 05"),
            _buildTextField(_df20Controller, "Despesa Fixa Dia 20"),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 15)),
              child: Text("CALCULAR E SALVAR"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Card(
      elevation: 4,
      color: _limiteDisponivel >= 0 ? Colors.green.shade50 : Colors.red.shade50,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Você ainda pode gastar total:", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text(
              "R\$ ${_limiteDisponivel.toStringAsFixed(2)}",
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: _limiteDisponivel >= 0 ? Colors.green.shade700 : Colors.red.shade700
              ),
            ),
            Text("Você ainda pode gastar até dia 5:", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text(
              "R\$ ${_limiteDisponivelDia05.toStringAsFixed(2)}",
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: _limiteDisponivel >= 0 ? Colors.green.shade700 : Colors.red.shade700
              ),
            ),
            Text("Você ainda pode gastar até dia 20:", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text(
              "R\$ ${_limiteDisponivelDia20.toStringAsFixed(2)}",
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: _limiteDisponivel >= 0 ? Colors.green.shade700 : Colors.red.shade700
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          prefixText: "R\$ ",
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}