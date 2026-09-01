import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const OptiGestApp());

const String baseUrl = 'https://zooming-smile-production-7aa3.up.railway.app';
const String loginEndpoint = '$baseUrl/api/login';
const String activosEndpoint = '$baseUrl/api/activos';
const String personalEndpoint = '$baseUrl/api/personal';
const String asignacionesEndpoint = '$baseUrl/api/asignaciones';

class OptiGestApp extends StatelessWidget {
  const OptiGestApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF2563EB);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OptiGest',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: primary, primary: primary, secondary: const Color(0xFF1D4ED8), surface: Colors.white),
        scaffoldBackgroundColor: const Color(0xFFF3F6FB),
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white, foregroundColor: Color(0xFF1F2630), surfaceTintColor: Colors.white, elevation: 0),
        cardTheme: CardThemeData(color: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: const BorderSide(color: Color(0xFFDCE3EE)))),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFDCE3EE))),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFDCE3EE))),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _cargando = false;
  bool _mostrarPassword = false;
  String? _error;

  @override
  void dispose() {
    _usuarioController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> iniciarSesion() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final response = await http
          .post(
            Uri.parse(loginEndpoint),
            headers: const {'Content-Type': 'application/json', 'Accept': 'application/json'},
            body: jsonEncode({'usuario': _usuarioController.text.trim(), 'password': _passwordController.text}),
          )
          .timeout(const Duration(seconds: 15));

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (!mounted) return;

      if (response.statusCode == 200 && body['ok'] == true && body['usuario'] is Map) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => InicioScreen(
              usuario: Map<String, dynamic>.from(body['usuario'] as Map),
            ),
          ),
        );
      } else {
        setState(() => _error = body['mensaje']?.toString() ?? 'No fue posible iniciar sesión.');
      }
    } on FormatException {
      if (mounted) setState(() => _error = 'El servidor devolvió una respuesta no válida.');
    } catch (_) {
      if (mounted) setState(() => _error = 'No fue posible conectar con OptiGest. Inténtalo de nuevo.');
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Image.asset(
                              'assets/optigest_logo.png',
                              width: 180,
                              height: 110,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Bienvenido a OptiGest',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Ingresa con tu cuenta institucional.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Color(0xFF475569)),
                          ),
                          const SizedBox(height: 28),
                          TextFormField(
                            controller: _usuarioController,
                            decoration: const InputDecoration(
                              labelText: 'Usuario o documento',
                              prefixIcon: Icon(Icons.badge_outlined),
                            ),
                            validator: (v) => v == null || v.trim().isEmpty ? 'Ingresa tu usuario o documento.' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_mostrarPassword,
                            decoration: InputDecoration(
                              labelText: 'Contraseña',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                tooltip: _mostrarPassword ? 'Ocultar contraseña' : 'Mostrar contraseña',
                                onPressed: () => setState(() => _mostrarPassword = !_mostrarPassword),
                                icon: Icon(_mostrarPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                              ),
                            ),
                            validator: (v) => v == null || v.isEmpty ? 'Ingresa tu contraseña.' : null,
                          ),
                          if (_error != null) ...[
                            const SizedBox(height: 16),
                            _ErrorMessage(message: _error!),
                          ],
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 52,
                            child: FilledButton(
                              onPressed: _cargando ? null : iniciarSesion,
                              child: _cargando
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                    )
                                  : const Text('Iniciar sesión'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key, required this.usuario});

  final Map<String, dynamic> usuario;

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  int _pagina = 0;
  static const _titulos = ['Inicio', 'Buscar activos', 'Buscar personal', 'Buscar asignaciones'];

  @override
  Widget build(BuildContext context) {
    final pages = [
      _InicioPage(usuario: widget.usuario, onOpen: (i) => setState(() => _pagina = i)),
      BusquedaPage(tipo: TipoBusqueda.activos, baseUrlOverride: baseUrl),
      BusquedaPage(tipo: TipoBusqueda.personal, baseUrlOverride: baseUrl),
      BusquedaPage(tipo: TipoBusqueda.asignaciones, baseUrlOverride: baseUrl),
    ];

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: Row(
          children: [
            Image.asset('assets/optigest_logo.png', width: 38, height: 38, fit: BoxFit.contain),
            const SizedBox(width: 10),
            Text(_titulos[_pagina], style: const TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout_outlined),
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (_) => false,
            ),
          ),
        ],
      ),
      body: pages[_pagina],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _pagina,
        onDestinationSelected: (v) => setState(() => _pagina = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Inicio'),
          NavigationDestination(icon: Icon(Icons.inventory_2_outlined), selectedIcon: Icon(Icons.inventory_2), label: 'Activos'),
          NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: 'Personal'),
          NavigationDestination(icon: Icon(Icons.assignment_outlined), selectedIcon: Icon(Icons.assignment), label: 'Asignaciones'),
        ],
      ),
    );
  }
}

class _InicioPage extends StatelessWidget {
  const _InicioPage({required this.usuario, required this.onOpen});

  final Map<String, dynamic> usuario;
  final ValueChanged<int> onOpen;

  @override
  Widget build(BuildContext context) {
    final nombre = '${usuario['nombre'] ?? ''} ${usuario['apellidos'] ?? ''}'.trim();
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          nombre.isEmpty ? 'Bienvenido a OptiGest' : 'Hola, $nombre',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        const Text('Selecciona una vista para filtrar y realizar una consulta.', style: TextStyle(color: Color(0xFF475569))),
        const SizedBox(height: 28),
        _NavigationCard(
          icon: Icons.inventory_2_outlined,
          title: 'Activos',
          description: 'Filtra y busca un activo por código, nombre o estado.',
          onTap: () => onOpen(1),
        ),
        const SizedBox(height: 12),
        _NavigationCard(
          icon: Icons.people_outline,
          title: 'Personal',
          description: 'Filtra y busca personal por documento, nombre o correo.',
          onTap: () => onOpen(2),
        ),
        const SizedBox(height: 12),
        _NavigationCard(
          icon: Icons.assignment_outlined,
          title: 'Asignaciones',
          description: 'Consulta por documento o por activo asignado.',
          onTap: () => onOpen(3),
        ),
      ],
    );
  }
}

class _NavigationCard extends StatelessWidget {
  const _NavigationCard({required this.icon, required this.title, required this.description, required this.onTap});

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          leading: CircleAvatar(
            backgroundColor: const Color(0xFFEFF6FF),
            foregroundColor: const Color(0xFF2563EB),
            child: Icon(icon),
          ),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text(description),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      );
}

enum TipoBusqueda { activos, personal, asignaciones }

class BusquedaPage extends StatefulWidget {
  BusquedaPage({
    super.key,
    required this.tipo,
    String? baseUrlOverride,
    http.Client? client,
  })  : apiBaseUrl = baseUrlOverride ?? baseUrl,
        client = client ?? http.Client();

  final TipoBusqueda tipo;
  final String apiBaseUrl;
  final http.Client client;

  @override
  State<BusquedaPage> createState() => _BusquedaPageState();
}

class _BusquedaPageState extends State<BusquedaPage> {
  final _valor = TextEditingController();
  String? _filtro;
  bool _consultaRealizada = false;
  bool _cargando = false;
  String? _error;
  List<Map<String, dynamic>> _resultados = const [];

  @override
  void dispose() {
    _valor.dispose();
    super.dispose();
  }

  List<DropdownMenuItem<String>> get _opciones => switch (widget.tipo) {
    TipoBusqueda.activos => const [
        DropdownMenuItem(value: 'codigo', child: Text('Código')),
        DropdownMenuItem(value: 'nombre', child: Text('Nombre')),
        DropdownMenuItem(value: 'estado', child: Text('Estado')),
      ],
    TipoBusqueda.personal => const [
        DropdownMenuItem(value: 'documento', child: Text('Documento')),
        DropdownMenuItem(value: 'nombre', child: Text('Nombre')),
        DropdownMenuItem(value: 'correo', child: Text('Correo')),
      ],
    TipoBusqueda.asignaciones => const [
        DropdownMenuItem(value: 'documento', child: Text('Documento')),
        DropdownMenuItem(value: 'activo', child: Text('Activo o código')),
      ],
  };

  String get _titulo => switch (widget.tipo) {
    TipoBusqueda.activos => 'Buscar activos',
    TipoBusqueda.personal => 'Buscar personal',
    TipoBusqueda.asignaciones => 'Buscar asignaciones',
  };

  String get _ayuda => switch (widget.tipo) {
    TipoBusqueda.activos => 'Filtra por código, nombre o estado del activo.',
    TipoBusqueda.personal => 'Filtra por documento, nombre o correo del personal.',
    TipoBusqueda.asignaciones => 'Consulta por documento o por nombre/código de activo.',
  };

  String get _endpoint => switch (widget.tipo) {
    TipoBusqueda.activos => '${widget.apiBaseUrl}/api/activos',
    TipoBusqueda.personal => '${widget.apiBaseUrl}/api/personal',
    TipoBusqueda.asignaciones => '${widget.apiBaseUrl}/api/asignaciones',
  };

  Future<void> _consultar() async {
    if (_filtro == null || _valor.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un filtro e ingresa un valor para buscar.')),
      );
      return;
    }

    setState(() {
      _cargando = true;
      _error = null;
      _consultaRealizada = true;
    });

    try {
      final uri = Uri.parse(_endpoint).replace(
        queryParameters: {
          'campo': _filtro!,
          'valor': _valor.text.trim(),
        },
      );

      final response = await widget.client.get(uri, headers: {'Accept': 'application/json'}).timeout(const Duration(seconds: 20));

      if (!mounted) return;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        setState(() {
          _resultados = _extractRows(decoded);
          _error = null;
        });
      } else {
        setState(() => _error = 'La consulta no pudo completarse. Verifica la conexión con el servidor.');
      }
    } on FormatException {
      if (mounted) {
        setState(() => _error = 'El servidor devolvió una respuesta no válida.');
      }
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'No fue posible consultar la información en OptiGest.');
      }
    } finally {
      if (mounted) {
        setState(() => _cargando = false);
      }
    }
  }

  List<Map<String, dynamic>> _extractRows(dynamic payload) {
    if (payload is List) {
      return payload.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList();
    }

    if (payload is Map) {
      for (final key in ['data', 'items', 'results', 'activos', 'personal', 'asignaciones', 'records']) {
        final value = payload[key];
        if (value is List) {
          return value.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList();
        }
      }

      if (payload['ok'] == true && payload['data'] is Map) {
        return [Map<String, dynamic>.from(payload['data'] as Map)];
      }

      return [Map<String, dynamic>.from(payload)];
    }

    return const [];
  }

  Widget _buildResultadoWidget() {
    if (_resultados.isEmpty && _error == null && !_cargando) {
      return const _EmptySearchResult();
    }

    if (_error != null) {
      return _ErrorMessage(message: _error!);
    }

    if (_cargando) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return switch (widget.tipo) {
      TipoBusqueda.activos => _ActivosResults(items: _resultados),
      TipoBusqueda.personal => _PersonalResults(items: _resultados),
      TipoBusqueda.asignaciones => _AsignacionesResults(items: _resultados),
    };
  }

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            _titulo,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(_ayuda, style: const TextStyle(color: Color(0xFF475569))),
          const SizedBox(height: 22),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    value: _filtro,
                    decoration: const InputDecoration(labelText: 'Filtrar por', prefixIcon: Icon(Icons.tune)),
                    items: _opciones,
                    onChanged: (v) => setState(() => _filtro = v),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _valor,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _consultar(),
                    decoration: const InputDecoration(labelText: 'Valor a buscar', prefixIcon: Icon(Icons.search)),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _consultar,
                    icon: const Icon(Icons.search),
                    label: const Text('Buscar'),
                  ),
                ],
              ),
            ),
          ),
          if (_consultaRealizada) ...[
            const SizedBox(height: 20),
            _buildResultadoWidget(),
          ],
        ],
      );
}

class _ActivosResults extends StatelessWidget {
  const _ActivosResults({required this.items});

  final List<Map<String, dynamic>> items;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Resultados de activos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            ...items.map((item) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFE0F2FE),
                    foregroundColor: Color(0xFF0F172A),
                    child: Icon(Icons.inventory_2_outlined),
                  ),
                  title: Text((item['codigo'] ?? item['id'] ?? 'Sin código').toString()),
                  subtitle: Text((item['nombre'] ?? item['descripcion'] ?? 'Sin nombre').toString()),
                  trailing: Chip(label: Text((item['estado'] ?? 'Sin estado').toString())),
                )),
          ],
        ),
      ),
    );
  }
}

class _PersonalResults extends StatelessWidget {
  const _PersonalResults({required this.items});

  final List<Map<String, dynamic>> items;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Resultados de personal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            ...items.map((item) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFEDE9FE),
                    foregroundColor: Color(0xFF1F2937),
                    child: Icon(Icons.person_outline),
                  ),
                  title: Text((item['nombre'] ?? '${item['nombres'] ?? ''} ${item['apellidos'] ?? ''}'.trim()).toString()),
                  subtitle: Text((item['correo'] ?? item['email'] ?? item['documento'] ?? 'Sin contacto').toString()),
                  trailing: Text((item['documento'] ?? item['cedula'] ?? '').toString()),
                )),
          ],
        ),
      ),
    );
  }
}

class _AsignacionesResults extends StatelessWidget {
  const _AsignacionesResults({required this.items});

  final List<Map<String, dynamic>> items;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Resultados de asignaciones', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            ...items.map((item) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFDCFCE7),
                    foregroundColor: Color(0xFF14532D),
                    child: Icon(Icons.assignment_outlined),
                  ),
                  title: Text((item['activo'] ?? item['codigoActivo'] ?? item['codigo'] ?? 'Sin activo').toString()),
                  subtitle: Text((item['documento'] ?? item['usuario'] ?? item['personal'] ?? 'Sin responsable').toString()),
                  trailing: Text((item['estado'] ?? item['estadoAsignacion'] ?? 'Sin estado').toString()),
                )),
          ],
        ),
      ),
    );
  }
}

class _EmptySearchResult extends StatelessWidget {
  const _EmptySearchResult();

  @override
  Widget build(BuildContext context) => Card(
        child: const Padding(
          padding: EdgeInsets.all(26),
          child: Column(
            children: [
              Icon(Icons.manage_search_outlined, size: 48, color: Color(0xFF2563EB)),
              SizedBox(height: 12),
              Text('Sin resultados', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              SizedBox(height: 6),
              Text('No se encontraron registros para ese filtro.', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF475569))),
            ],
          ),
        ),
      );
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFECACA)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const Icon(Icons.error_outline, color: Color(0xFFDC2626)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(message, style: const TextStyle(color: Color(0xFF991B1B))),
              ),
            ],
          ),
        ),
      );
}
