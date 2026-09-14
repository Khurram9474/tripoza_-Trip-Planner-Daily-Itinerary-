import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// Adjust this import to match your actual root app widget file/class name.
// import 'package:tripora/app.dart';

void main() {
  testWidgets('App builds without throwing', (WidgetTester tester) async {
    // Replace `MaterialApp(home: Placeholder())` below with your real
    // root widget once you confirm its class name, e.g.:
    // await tester.pumpWidget(const ProviderScope(child: TriporaApp()));
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: Placeholder()),
      ),
    );

    expect(find.byType(Placeholder), findsOneWidget);
  });
}