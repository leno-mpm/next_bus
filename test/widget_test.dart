import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:next_bus/app/app.dart';

void main() {
  testWidgets('App shows profile selection and navigates to user shell',
      (WidgetTester tester) async {
    await tester.pumpWidget(const NextBusApp());
    await tester.pumpAndSettle();

    expect(find.text('NextBus'), findsWidgets);
    expect(find.text('Ingresar como usuario'), findsOneWidget);
    expect(find.text('Ingresar como conductor'), findsOneWidget);

    await tester.tap(find.text('Ingresar como usuario'));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.home_rounded), findsOneWidget);
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });
}
