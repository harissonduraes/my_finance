import 'base/base_model.dart';

class FinanceModel implements BaseModel {
  @override
  final int? id;
  final double ganhoDia05;
  final double ganhoDia20;
  final double faturaDia05;
  final double faturaDia20;
  final double despesaFixaDia05; // Novo
  final double despesaFixaDia20; // Novo

  FinanceModel({
    this.id,
    required this.ganhoDia05,
    required this.ganhoDia20,
    required this.faturaDia05,
    required this.faturaDia20,
    required this.despesaFixaDia05,
    required this.despesaFixaDia20,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ganhoDia05': ganhoDia05,
      'ganhoDia20': ganhoDia20,
      'faturaDia05': faturaDia05,
      'faturaDia20': faturaDia20,
      'despesaFixaDia05': despesaFixaDia05,
      'despesaFixaDia20': despesaFixaDia20,
    };
  }

  factory FinanceModel.fromMap(Map<String, dynamic> map) {
    return FinanceModel(
      id: map['id'],
      ganhoDia05: map['ganhoDia05'],
      ganhoDia20: map['ganhoDia20'],
      faturaDia05: map['faturaDia05'],
      faturaDia20: map['faturaDia20'],
      despesaFixaDia05: map['despesaFixaDia05'] ?? 0.0,
      despesaFixaDia20: map['despesaFixaDia20'] ?? 0.0,
    );
  }
}