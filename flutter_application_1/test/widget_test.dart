import 'package:flutter_test/flutter_test.dart';
import 'package:optigest/main.dart';

void main() {
  testWidgets('muestra el inicio de sesión de OptiGest', (tester) async {
    await tester.pumpWidget(const OptiGestApp());

    expect(find.text('OptiGest'), findsOneWidget);
    expect(find.text('Iniciar sesión'), findsOneWidget);
  });
}
