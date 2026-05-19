import 'base/base_model.dart';

class DespesaModel implements BaseModel {
  @override
  final int? id;
  final double despesa;
  final String dia;

  const DespesaModel({this.id, required this.despesa, required this.dia});

  @override
  Map<String, dynamic> toMap() {
    return {'id': id, 'despesa': despesa, 'dia': dia};
  }

  factory DespesaModel.fromMap(Map<String, dynamic> map) {
    return DespesaModel(
      id: map['id'],
      despesa: map['despesa'],
      dia: map['dia'],
    );
  }
}
