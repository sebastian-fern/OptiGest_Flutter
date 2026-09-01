import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:optigest/main.dart';

class _MockSearchClient extends http.BaseClient {
  _MockSearchClient(this._body);

  final List<Map<String, dynamic>> _body;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final responseBody = jsonEncode({'ok': true, 'data': _body});
    final response = http.Response(responseBody, 200, headers: {'content-type': 'application/json'});
    return http.StreamedResponse(Stream.value(response.bodyBytes), response.statusCode, headers: response.headers);
  }
}

void main() {
  testWidgets('muestra el inicio de sesión de OptiGest', (tester) async {
    await tester.pumpWidget(const OptiGestApp());

    expect(find.text('Bienvenido a OptiGest'), findsOneWidget);
    expect(find.text('Iniciar sesión'), findsOneWidget);
  });

  testWidgets('muestra resultados al buscar activos', (tester) async {
    const baseUrl = 'https://example.com';
    const inicial = 'ACT-001';
    final mockClient = _MockSearchClient([
      {'codigo': inicial, 'nombre': 'Servidor principal', 'estado': 'Activo'},
    ]);

    await tester.pumpWidget(MaterialApp(
      home: BusquedaPage(
        tipo: TipoBusqueda.activos,
        client: mockClient,
        baseUrlOverride: baseUrl,
      ),
    ));

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Código').last);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), inicial);
    await tester.tap(find.text('Buscar'));
    await tester.pumpAndSettle();

    expect(find.text('Servidor principal'), findsOneWidget);
    expect(find.text('ACT-001'), findsWidgets);
  });
}
