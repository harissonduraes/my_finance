import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:my_finance/pages/home_page.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('HomePage renders without errors', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: HomePage()));
    await tester.pumpAndSettle();

    expect(find.text('Meu Financeiro'), findsOneWidget);
    expect(find.text('SALDO DISPONÍVEL'), findsOneWidget);
  });
}
