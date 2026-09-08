import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String baseUrl ='https://zooming-smile-production-7aa3.up.railway.app';
const String apiEndpoint = '$baseUrl/api/Mobile';

void main() {
  runApp(const OptiGestApp());
}

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
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          primary: primary,
        ),
        scaffoldBackgroundColor: const Color(0xFFF3F6FB),
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

  Future<void> _iniciarSesion() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final response = await http
          .post(
            Uri.parse(apiEndpoint),
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'accion': 'login',
              'usuario': _usuarioController.text.trim(),
              'password': _passwordController.text,
            }),
          )
          .timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);

      if (!mounted) return;

      if (response.statusCode == 200 &&
          data is Map &&
          data['ok'] == true &&
          data['usuario'] is Map) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => InicioScreen(
              usuario: Map<String, dynamic>.from(data['usuario'] as Map),
            ),
          ),
        );
        return;
      }

      setState(() {
        _error = data is Map
            ? data['mensaje']?.toString() ??
                'No fue posible iniciar sesión.'
            : 'No fue posible iniciar sesión.';
      });
    } on FormatException {
      if (mounted) {
        setState(() {
          _error = 'El servidor devolvió una respuesta no válida.';
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = 'No fue posible conectar con OptiGest.';
        });
      }
    } finally {
      if (mounted) {
        setState(() => _cargando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        Image.asset(
                          'assets/optigest_logo.png',
                          height: 110,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Bienvenido a OptiGest',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Ingresa con tu cuenta institucional.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 28),
                        TextFormField(
                          controller: _usuarioController,
                          decoration: const InputDecoration(
                            labelText: 'Usuario o documento',
                            prefixIcon: Icon(Icons.badge_outlined),
                          ),
                          validator: (valor) {
                            if (valor == null || valor.trim().isEmpty) {
                              return 'Ingresa tu usuario o documento.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_mostrarPassword,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _mostrarPassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                              onPressed: () {
                                setState(() {
                                  _mostrarPassword = !_mostrarPassword;
                                });
                              },
                            ),
                          ),
                          validator: (valor) {
                            if (valor == null || valor.isEmpty) {
                              return 'Ingresa tu contraseña.';
                            }
                            return null;
                          },
                        ),
                        if (_error != null) ...[
                          const SizedBox(height: 16),
                          ErrorMessage(mensaje: _error!),
                        ],
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 52,
                          child: FilledButton(
                            onPressed: _cargando ? null : _iniciarSesion,
                            child: _cargando
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
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
}

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key, required this.usuario});

  final Map<String, dynamic> usuario;

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  int _pagina = 0;

  final _titulos = const [
    'Inicio',
    'Buscar activos',
    'Buscar personal',
    'Buscar asignaciones',
  ];

  @override
  Widget build(BuildContext context) {
    final paginas = [
      InicioPage(
        usuario: widget.usuario,
        abrirPagina: (pagina) => setState(() => _pagina = pagina),
      ),
      const BusquedaPage(tipo: TipoBusqueda.activos),
      const BusquedaPage(tipo: TipoBusqueda.personal),
      const BusquedaPage(tipo: TipoBusqueda.asignaciones),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titulos[_pagina],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Mi perfil',
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PerfilScreen(usuario: widget.usuario),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout_outlined),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
              );
            },
          ),
        ],
      ),
      body: paginas[_pagina],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _pagina,
        onDestinationSelected: (pagina) {
          setState(() => _pagina = pagina);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Activos',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Personal',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: 'Asignaciones',
          ),
        ],
      ),
    );
  }
}

class InicioPage extends StatelessWidget {
  const InicioPage({
    super.key,
    required this.usuario,
    required this.abrirPagina,
  });

  final Map<String, dynamic> usuario;
  final ValueChanged<int> abrirPagina;

  @override
  Widget build(BuildContext context) {
    final nombre =
        '${usuario['nombre'] ?? ''} ${usuario['apellidos'] ?? ''}'.trim();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          nombre.isEmpty ? 'Bienvenido a OptiGest' : 'Hola, $nombre',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text('Selecciona una vista para realizar una consulta.'),
        const SizedBox(height: 24),
        NavigationCard(
          icon: Icons.inventory_2_outlined,
          titulo: 'Activos',
          descripcion: 'Consulta activos por código, nombre o estado.',
          onTap: () => abrirPagina(1),
        ),
        const SizedBox(height: 12),
        NavigationCard(
          icon: Icons.people_outline,
          titulo: 'Personal',
          descripcion: 'Consulta personal por documento, nombre o correo.',
          onTap: () => abrirPagina(2),
        ),
        const SizedBox(height: 12),
        NavigationCard(
          icon: Icons.assignment_outlined,
          titulo: 'Asignaciones',
          descripcion: 'Consulta las asignaciones registradas.',
          onTap: () => abrirPagina(3),
        ),
      ],
    );
  }
}

class NavigationCard extends StatelessWidget {
  const NavigationCard({
    super.key,
    required this.icon,
    required this.titulo,
    required this.descripcion,
    required this.onTap,
  });

  final IconData icon;
  final String titulo;
  final String descripcion;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(descripcion),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

enum TipoBusqueda { activos, personal, asignaciones }

class BusquedaPage extends StatefulWidget {
  const BusquedaPage({super.key, required this.tipo});

  final TipoBusqueda tipo;

  @override
  State<BusquedaPage> createState() => _BusquedaPageState();
}

class _BusquedaPageState extends State<BusquedaPage> {
  final _valorController = TextEditingController();

  String? _campo;
  bool _cargando = false;
  String? _error;
  List<Map<String, dynamic>> _resultados = [];

  @override
  void initState() {
    super.initState();
    _consultar(mostrarTodo: true);
  }

  @override
  void dispose() {
    _valorController.dispose();
    super.dispose();
  }

  String get _accion {
    switch (widget.tipo) {
      case TipoBusqueda.activos:
        return 'activos';
      case TipoBusqueda.personal:
        return 'personal';
      case TipoBusqueda.asignaciones:
        return 'asignaciones';
    }
  }

  String get _titulo {
    switch (widget.tipo) {
      case TipoBusqueda.activos:
        return 'Buscar activos';
      case TipoBusqueda.personal:
        return 'Buscar personal';
      case TipoBusqueda.asignaciones:
        return 'Buscar asignaciones';
    }
  }

  List<DropdownMenuItem<String>> get _opciones {
    switch (widget.tipo) {
      case TipoBusqueda.activos:
        return const [
          DropdownMenuItem(value: 'codigo', child: Text('Código')),
          DropdownMenuItem(value: 'nombre', child: Text('Nombre')),
          DropdownMenuItem(value: 'estado', child: Text('Estado')),
        ];
      case TipoBusqueda.personal:
        return const [
          DropdownMenuItem(value: 'documento', child: Text('Documento')),
          DropdownMenuItem(value: 'nombre', child: Text('Nombre')),
          DropdownMenuItem(value: 'correo', child: Text('Correo')),
        ];
      case TipoBusqueda.asignaciones:
        return const [
          DropdownMenuItem(value: 'documento', child: Text('Documento')),
          DropdownMenuItem(value: 'activo', child: Text('Activo o código')),
        ];
    }
  }

  Future<void> _consultar({bool mostrarTodo = false}) async {
    if (!mostrarTodo &&
        (_campo == null || _valorController.text.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona un filtro e ingresa un valor.'),
        ),
      );
      return;
    }

    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final solicitud = <String, dynamic>{
        'accion': _accion,
      };

      if (!mostrarTodo) {
        solicitud['campo'] = _campo!;
        solicitud['valor'] = _valorController.text.trim();
      }

      final response = await http
          .post(
            Uri.parse(apiEndpoint),
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(solicitud),
          )
          .timeout(const Duration(seconds: 20));

      final data = jsonDecode(response.body);

      if (!mounted) return;

      if (response.statusCode >= 200 &&
          response.statusCode < 300 &&
          data is Map &&
          data['ok'] == true) {
        final lista = data['data'];

        setState(() {
          if (lista is List) {
            _resultados = lista
                .whereType<Map>()
                .map((item) => Map<String, dynamic>.from(item))
                .toList();
          } else {
            _resultados = [];
          }
        });
      } else {
        setState(() {
          _error = data is Map
              ? data['mensaje']?.toString() ?? 'No fue posible consultar.'
              : 'No fue posible consultar.';
        });
      }
    } on FormatException {
      if (mounted) {
        setState(() {
          _error = 'El servidor devolvió una respuesta no válida.';
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = 'No fue posible conectar con OptiGest.';
        });
      }
    } finally {
      if (mounted) {
        setState(() => _cargando = false);
      }
    }
  }

  String _tituloResultado(Map<String, dynamic> item) {
    switch (widget.tipo) {
      case TipoBusqueda.activos:
        return '${item['codigo'] ?? ''} - ${item['nombre'] ?? ''}';
      case TipoBusqueda.personal:
        return '${item['nombre'] ?? ''} ${item['apellidos'] ?? ''}'.trim();
      case TipoBusqueda.asignaciones:
        return item['activo']?.toString() ?? 'Asignación';
    }
  }

  String _subtituloResultado(Map<String, dynamic> item) {
    switch (widget.tipo) {
      case TipoBusqueda.activos:
        return item['descripcion']?.toString() ?? '';
      case TipoBusqueda.personal:
        return item['correo']?.toString() ??
            item['documento']?.toString() ??
            '';
      case TipoBusqueda.asignaciones:
        return item['documento']?.toString() ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          _titulo,
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: _campo,
                  decoration: const InputDecoration(
                    labelText: 'Filtrar por',
                    prefixIcon: Icon(Icons.tune),
                  ),
                  items: _opciones,
                  onChanged: (valor) {
                    setState(() => _campo = valor);
                  },
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _valorController,
                  decoration: const InputDecoration(
                    labelText: 'Valor a buscar',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onSubmitted: (_) => _consultar(),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _cargando ? null : _consultar,
                  icon: const Icon(Icons.search),
                  label: const Text('Buscar'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _cargando
                      ? null
                      : () => _consultar(mostrarTodo: true),
                  icon: const Icon(Icons.format_list_bulleted),
                  label: const Text('Mostrar todo'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        if (_cargando)
          const Center(child: CircularProgressIndicator())
        else if (_error != null)
          ErrorMessage(mensaje: _error!)
        else if (_resultados.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text('No se encontraron resultados.'),
            ),
          )
        else
          ..._resultados.map(
            (item) => Card(
              child: ExpansionTile(
                title: Text(
                  _tituloResultado(item),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(_subtituloResultado(item)),
                children: item.entries
                    .map(
                      (dato) => ListTile(
                        title: Text(_etiqueta(dato.key)),
                        trailing: Text(dato.value?.toString() ?? ''),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
      ],
    );
  }
}

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key, required this.usuario});

  final Map<String, dynamic> usuario;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi perfil')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: usuario.entries
            .where((dato) =>
                !['token', 'password', 'clave'].contains(dato.key.toLowerCase()))
            .map(
              (dato) => Card(
                child: ListTile(
                  title: Text(_etiqueta(dato.key)),
                  subtitle: Text(dato.value?.toString() ?? ''),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({super.key, required this.mensaje});

  final String mensaje;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFFEF2F2),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                mensaje,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _etiqueta(String texto) {
  final separado = texto.replaceAllMapped(
    RegExp(r'([a-z])([A-Z])'),
    (resultado) => '${resultado[1]} ${resultado[2]}',
  );

  if (separado.isEmpty) return separado;

  return '${separado[0].toUpperCase()}${separado.substring(1)}';
}