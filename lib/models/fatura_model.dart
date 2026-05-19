import 'base/base_model.dart';

class FaturaModel implements BaseModel {
  @override
  final int? id;
  final double valor;
  final String cartao;
  final String dia;

  const FaturaModel({
    this.id,
    required this.valor,
    required this.cartao,
    required this.dia,
  });

  @override
  Map<String, dynamic> toMap() {
    return {'id': id, 'valor': valor, 'cartao': cartao, 'dia': dia};
  }

  factory FaturaModel.fromMap(Map<String, dynamic> map) {
    return FaturaModel(
      id: map['id'],
      valor: map['valor'],
      cartao: map['cartao'],
      dia: map['dia'],
    );
  }
}
