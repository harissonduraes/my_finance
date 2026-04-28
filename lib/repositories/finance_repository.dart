import '../models/finance_model.dart';
import 'base/base_repository.dart';

class FinanceRepository extends BaseRepository<FinanceModel> {
  FinanceRepository()
      : super(
    tableName: 'finance',
    fromMap: (map) => FinanceModel.fromMap(map),
  );
}