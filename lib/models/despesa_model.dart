import 'base/base_model.dart';

class DespesaModel implements BaseModel {
  @override
  final int? id;
  final double despesa;
  final String dia;
  final String descricao;

  const DespesaModel({
    this.id,
    required this.despesa,
    required this.dia,
    this.descricao = '',
  });

  @override
  Map<String, dynamic> toMap() {
    return {'id': id, 'despesa': despesa, 'dia': dia, 'descricao': descricao};
  }

  factory DespesaModel.fromMap(Map<String, dynamic> map) {
    return DespesaModel(
      id: map['id'],
      despesa: map['despesa'],
      dia: map['dia'],
      descricao: map['descricao'] ?? '',
    );
  }
}
