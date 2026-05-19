import 'base/base_model.dart';

class DespesaModel implements BaseModel {
  @override
  final int? id;
  final double valor;
  final String dia;
  final String descricao;

  const DespesaModel({
    this.id,
    required this.valor,
    required this.dia,
    this.descricao = '',
  });

  @override
  Map<String, dynamic> toMap() {
    return {'id': id, 'valor': valor, 'dia': dia, 'descricao': descricao};
  }

  factory DespesaModel.fromMap(Map<String, dynamic> map) {
    return DespesaModel(
      id: map['id'],
      valor: map['valor'],
      dia: map['dia'],
      descricao: map['descricao'] ?? '',
    );
  }
}
