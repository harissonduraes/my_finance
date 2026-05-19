import '../models/despesa_model.dart';
import 'base/base_repository.dart';

class DespesaRepository extends BaseRepository<DespesaModel> {
  DespesaRepository()
      : super(
    tableName: 'despesa',
    fromMap: (map) => DespesaModel.fromMap(map),
  );
}