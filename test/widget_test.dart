import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:next_bus/app/app.dart';

/// Scrolls `finder` into view (several list items are long enough that the
/// surrounding `ListView` never builds them off-screen) before tapping it.
Future<void> _tap(WidgetTester tester, Finder finder) async {
  final scrollable = find.byType(Scrollable);
  if (scrollable.evaluate().isNotEmpty) {
    await tester.scrollUntilVisible(
      finder,
      300,
      scrollable: scrollable.first,
    );
    await tester.pumpAndSettle();
  }
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('App shows login and navigates to the student shell',
      (WidgetTester tester) async {
    await tester.pumpWidget(const NextBusApp());
    await tester.pumpAndSettle();

    expect(find.text('Ruta ESPOL'), findsOneWidget);
    expect(find.text('Estudiante'), findsOneWidget);
    expect(find.text('Conductor'), findsOneWidget);

    await _tap(tester, find.text('Entrar'));

    expect(find.byIcon(Icons.home_rounded), findsOneWidget);
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });

  testWidgets(
      'Reporting an incident in C3 surfaces it in C4 (bitácora) and S7 (avisos)',
      (WidgetTester tester) async {
    await tester.pumpWidget(const NextBusApp());
    await tester.pumpAndSettle();

    // Log in as Conductor.
    await _tap(tester, find.text('Conductor'));
    await _tap(tester, find.text('Entrar'));

    // C1: BUS03 is seeded at its monthly fuel budget, so the fleet list
    // already marks it "Sin combustible" (the budget-gates-assignment rule)
    // without any interaction.
    await tester.scrollUntilVisible(
      find.text('Sin combustible'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Sin combustible'), findsOneWidget);

    // Start the shift on the assigned (still-budgeted) unit.
    await _tap(tester, find.text('Iniciar turno'));

    // C2: now on route — jump into C3 to report an incident.
    await _tap(tester, find.text('+ Eventualidad'));

    await tester.ensureVisible(find.byType(TextField));
    await tester.enterText(
      find.byType(TextField),
      'Semáforo dañado frente a la facultad.',
    );
    await _tap(tester, find.text('+5'));
    await _tap(
      tester,
      find.widgetWithText(ElevatedButton, 'Registrar incidencia'),
    );

    expect(find.text('Incidencia registrada'), findsOneWidget);
    await _tap(tester, find.text('Volver'));

    // C4: the new incident shows up as open on this driver's bus.
    await _tap(tester, find.text('Bitácora'));

    expect(find.text('1'), findsWidgets); // "Abiertas" count tile.
    expect(find.text('Marcar resuelta'), findsOneWidget);

    // Resolve it — the open count drops back to zero.
    await _tap(tester, find.text('Marcar resuelta'));
    expect(find.text('Marcar resuelta'), findsNothing);

    // Switch to the student side and confirm the resolved notice appears
    // in S7 (Avisos) — same shared incident list C3/C4 just wrote to.
    await _tap(tester, find.text('Perfil'));
    await _tap(tester, find.text('Cerrar sesión'));

    expect(find.text('Ruta ESPOL'), findsOneWidget);
    await _tap(tester, find.text('Estudiante'));
    await _tap(tester, find.text('Entrar'));

    await _tap(tester, find.text('Avisos'));

    expect(find.textContaining('Semáforo dañado'), findsOneWidget);
    expect(find.text('Resuelta'), findsWidgets);
  });
}
