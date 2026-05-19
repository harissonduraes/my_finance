import '../models/receita_model.dart';
import 'base/base_repository.dart';

class ReceitaRepository extends BaseRepository<ReceitaModel> {
  ReceitaRepository()
      : super(
    tableName: 'receita',
    fromMap: (map) => ReceitaModel.fromMap(map),
  );
}