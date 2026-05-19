import '../models/fatura_model.dart';
import 'base/base_repository.dart';

class FaturaRepository extends BaseRepository<FaturaModel> {
  FaturaRepository()
      : super(
    tableName: 'fatura',
    fromMap: (map) => FaturaModel.fromMap(map),
  );
}