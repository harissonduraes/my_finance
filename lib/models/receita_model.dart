import 'base/base_model.dart';

class ReceitaModel implements BaseModel {
  @override
  final int? id;
  final double valor;
  final String dia;
  final String? cartao;

  const ReceitaModel({
    this.id,
    required this.valor,
    required this.dia,
    this.cartao,
  });

  @override
  Map<String, dynamic> toMap() {
    return {'id': id, 'valor': valor, 'dia': dia, 'cartao': cartao};
  }

  factory ReceitaModel.fromMap(Map<String, dynamic> map) {
    return ReceitaModel(
      id: map['id'],
      valor: map['valor'],
      dia: map['dia'],
      cartao: map['cartao'],
    );
  }
}
