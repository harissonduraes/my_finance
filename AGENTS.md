# my_finance — AGENTS.md

## Commands

- `flutter pub get` — install deps
- `flutter run` — launch app
- `flutter analyze` — lint (uses `package:flutter_lints/flutter.yaml`)
- `flutter test` — run tests (1 widget test exists)
- `flutter clean` — clean build artifacts

## Architecture

```
lib/
├── main.dart              # Entrypoint; sqfliteFfiInit() for Windows/Linux/macOS
├── db/sql_helper.dart     # SQLite helper, DB file: finance4.db
├── models/                # ReceitaModel, FaturaModel, DespesaModel, SaldoPorCartao
├── repositories/          # Generic CRUD via BaseRepository<T>
├── controllers/           # Business logic layer
└── pages/home_page.dart   # Single-page UI
```

## Domain Language (Brazilian Portuguese)

| Termo            | English                      | Notes                                    |
|------------------|------------------------------|------------------------------------------|
| Receita          | Income/Revenue               |                                          |
| Despesa          | Expense                      |                                          |
| Fatura           | Credit card bill             | Has `cartao` (card name) field           |
| Saldo disponível | Available balance            |                                          |
| Saldo no débito  | Balance after fixed expenses | `totalReceitas - totalDespesas`          |
| Saldo por cartão | Per-card spending limit      | Income/expenses filtered by card due day |

## SQLite Desktop Quirk

`main.dart` already calls `sqfliteFfiInit()` + `databaseFactory = databaseFactoryFfi` on desktop
platforms. If adding new DB code, ensure the same guard (
`Platform.isWindows || Platform.isLinux || Platform.isMacOS`).

## Testing

- 1 widget test (`test/widget_test.dart`) — smoke test verifying `HomePage` renders
- Test initializes `sqfliteFfiInit()` + `databaseFactory = databaseFactoryFfi` in `setUpAll`
- No integration or unit tests for controllers/repositories/models exist

## Clean Code Patterns

- **Models**: immutable with `const` constructors
- **Controllers**: one public method per CRUD operation; no presentation logic
- **Repositories**: `BaseRepository<T>` already encapsulates generic CRUD — don't duplicate
  add/edit); avoid duplicating modal widgets per entity
- **Typed returns**: prefer typed model classes (e.g. `SaldoPorCartao`) over
  `Map<String, dynamic>` — keeps call sites safe and readable
- **Fold gotcha**: `List.fold(0, …)` infers `int`, causing `int + double` errors. Use explicit loops
  or `.fold(0.0, …)` for doubles
- **Error access**: use `.single` over `.first`;
- **Naming**: singular para valor único (`despesa`), plural para lista (`despesas`)
- **No abbreviations**: nomes completos, nunca cortados (`despesa` não `desp`)
- **Where param**: usar `w` como parâmetro: `.where((w) => w. ...)`
- **No single-letter names**: never use one-letter variable names (e.g., `despesa` not `d`)
