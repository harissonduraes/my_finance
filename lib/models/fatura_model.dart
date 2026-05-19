import 'base/base_model.dart';

class FaturaModel implements BaseModel {
  @override
  final int? id;
  final double fatura;
  final String cartao;
  final String dia;

  const FaturaModel({
    this.id,
    required this.fatura,
    required this.cartao,
    required this.dia,
  });

  @override
  Map<String, dynamic> toMap() {
    return {'id': id, 'fatura': fatura, 'cartao': cartao, 'dia': dia};
  }

  factory FaturaModel.fromMap(Map<String, dynamic> map) {
    return FaturaModel(
      id: map['id'],
      fatura: map['fatura'],
      cartao: map['cartao'],
      dia: map['dia'],
    );
  }
}
