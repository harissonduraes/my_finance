import 'base/base_model.dart';

class ReceitaModel implements BaseModel {
  @override
  final int? id;
  final double receita;
  final String dia;
  final String? cartao;

  const ReceitaModel({
    this.id,
    required this.receita,
    required this.dia,
    this.cartao,
  });

  @override
  Map<String, dynamic> toMap() {
    return {'id': id, 'receita': receita, 'dia': dia, 'cartao': cartao};
  }

  factory ReceitaModel.fromMap(Map<String, dynamic> map) {
    return ReceitaModel(
      id: map['id'],
      receita: map['receita'],
      dia: map['dia'],
      cartao: map['cartao'],
    );
  }
}
