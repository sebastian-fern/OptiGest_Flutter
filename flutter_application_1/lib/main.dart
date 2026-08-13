import 'package:flutter/material.dart';

void main() => runApp(const OptiGestApp());

class OptiGestApp extends StatelessWidget {
  const OptiGestApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'OptiGest',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0D47A1),
            primary: const Color(0xFF0D47A1),
            secondary: const Color(0xFF1565D8),
          ),
          scaffoldBackgroundColor: const Color(0xFFF7F9FC),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            backgroundColor: Color(0xFF0D47A1),
            foregroundColor: Colors.white,
          ),
          cardTheme: const CardThemeData(
            elevation: 1,
            surfaceTintColor: Colors.white,
            margin: EdgeInsets.zero,
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF0D47A1),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          navigationBarTheme: const NavigationBarThemeData(
            backgroundColor: Colors.white,
            indicatorColor: Color(0xFFDCE8FF),
            labelTextStyle: MaterialStatePropertyAll(TextStyle(fontWeight: FontWeight.w600)),
            iconTheme: MaterialStatePropertyAll(IconThemeData(color: Color(0xFF0D47A1))),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Color(0xFF90A4C7)),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        home: const LoginPage(),
      );
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _documento = TextEditingController();
  final _clave = TextEditingController();
  bool _ocultarClave = true;

  void _entrar() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const OptiGestHome()),
    );
  }

  @override
  void dispose() {
    _documento.dispose();
    _clave.dispose();
    super.dispose();
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
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Image.asset(
                                'assets/optigest_logo.png',
                                width: 170,
                                height: 170,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text('OptiGest',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineMedium),
                          const SizedBox(height: 8),
                          const Text('Accede a tu cuenta', textAlign: TextAlign.center),
                          const SizedBox(height: 28),
                          TextFormField(
                            controller: _documento,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'N. documento',
                              prefixIcon: Icon(Icons.badge_outlined),
                            ),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Ingresa tu documento'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _clave,
                            obscureText: _ocultarClave,
                            decoration: InputDecoration(
                              labelText: 'Contraseña',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(_ocultarClave
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined),
                                onPressed: () => setState(() => _ocultarClave = !_ocultarClave),
                              ),
                            ),
                            validator: (v) => (v == null || v.isEmpty)
                                ? 'Ingresa tu contraseña'
                                : null,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => _mensaje(context,
                                  'La recuperación de contraseña requiere el endpoint de API del servidor.'),
                              child: const Text('¿Olvidaste tu contraseña?'),
                            ),
                          ),
                          FilledButton(
                            onPressed: _entrar,
                            style: FilledButton.styleFrom(padding: const EdgeInsets.all(16)),
                            child: const Text('Iniciar sesión'),
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

class RecuperarContrasenaPage extends StatefulWidget {
  const RecuperarContrasenaPage({super.key});

  @override
  State<RecuperarContrasenaPage> createState() => _RecuperarContrasenaPageState();
}

class _RecuperarContrasenaPageState extends State<RecuperarContrasenaPage> {
  final _formKey = GlobalKey<FormState>();
  final _documento = TextEditingController();
  final _correo = TextEditingController();
  bool _solicitudEnviada = false;

  @override
  void dispose() {
    _documento.dispose();
    _correo.dispose();
    super.dispose();
  }

  void _enviarSolicitud() {
    if (_formKey.currentState!.validate()) setState(() => _solicitudEnviada = true);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Recuperar contraseña')),
        body: SafeArea(child: Center(child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Card(child: Padding(
              padding: const EdgeInsets.all(28),
              child: _solicitudEnviada ? _confirmacion() : _formulario(),
            )),
          ),
        ))),
      );

  Widget _formulario() => Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Icon(Icons.lock_reset_outlined, size: 58, color: Color(0xFF0D47A1)),
          const SizedBox(height: 18),
          Text('¿Olvidaste tu contraseña?', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          const Text('Ingresa tus datos y te enviaremos las instrucciones de recuperación.', textAlign: TextAlign.center),
          const SizedBox(height: 26),
          TextFormField(
            controller: _documento,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Número de documento', prefixIcon: Icon(Icons.badge_outlined)),
            validator: (valor) => valor == null || valor.trim().isEmpty ? 'Ingresa tu documento' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _correo,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Correo registrado', prefixIcon: Icon(Icons.email_outlined)),
            validator: (valor) {
              if (valor == null || valor.trim().isEmpty) return 'Ingresa tu correo';
              return valor.contains('@') ? null : 'Ingresa un correo válido';
            },
          ),
          const SizedBox(height: 24),
          FilledButton.icon(onPressed: _enviarSolicitud, icon: const Icon(Icons.send_outlined), label: const Text('Enviar instrucciones')),
          const SizedBox(height: 8),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Volver al inicio de sesión')),
        ]),
      );

  Widget _confirmacion() => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Icon(Icons.mark_email_read_outlined, size: 64, color: Color(0xFF0D47A1)),
        const SizedBox(height: 18),
        Text('Solicitud enviada', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 10),
        Text('Enviamos las instrucciones a ${_correo.text.trim()}. Revisa tu bandeja de entrada y el correo no deseado.', textAlign: TextAlign.center),
        const SizedBox(height: 24),
        FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Volver a iniciar sesión')),
      ]);
}

class OptiGestHome extends StatefulWidget {
  const OptiGestHome({super.key});

  @override
  State<OptiGestHome> createState() => _OptiGestHomeState();
}

class _OptiGestHomeState extends State<OptiGestHome> {
  int _pagina = 0;
  final List<Activo> _activos = [
    Activo(codigo: 'ACT-001', nombre: 'Laptop Pro 15"', categoria: 'Electrónicos', estado: 'Disponible', valor: 2500000),
    Activo(codigo: 'ACT-002', nombre: 'Monitor 27" 4K', categoria: 'Electrónicos', estado: 'Disponible', valor: 2000000),
    Activo(codigo: 'MAQ-002', nombre: 'Aire acondicionado', categoria: 'Herramientas', estado: 'En mantenimiento', valor: 3100000),
  ];
  final List<Empleado> _personal = [
    Empleado(nombre: 'Luis Díaz', documento: '1000222333', rol: 'Administrador', estado: 'Activo'),
    Empleado(nombre: 'Mauricio Roncancio', documento: '1000444555', rol: 'Contador', estado: 'Vacaciones'),
    Empleado(nombre: 'Jhon Figueroa', documento: '1019223345', rol: 'Desarrollador', estado: 'Activo'),
  ];
  final List<Proveedor> _proveedores = [
    Proveedor(nombre: 'TecnoServicios SAS', telefono: '3101234567', direccion: 'Cra 45 # 12-30, Bogotá', email: 'contacto@tecnoservicios.com'),
    Proveedor(nombre: 'ClimaFrío Ltda', telefono: '3129876543', direccion: 'Cll 80 # 20-15, Bogotá', email: 'ventas@climafrio.com'),
  ];
  final List<Asignacion> _asignaciones = [];
  final List<Mantenimiento> _mantenimientos = [];
  final List<String> _categorias = ['Electrónicos', 'Herramientas'];
  final List<String> _roles = ['Administrador', 'Personal fijo', 'Temporal'];
  final List<String> _estadosActivo = ['Disponible', 'Asignado', 'En mantenimiento', 'De baja'];
  final List<String> _estadosPersonal = ['Activo', 'Vacaciones', 'Inactivo'];

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardPage(activos: _activos, personal: _personal, onOpen: (index) => setState(() => _pagina = index)),
      ActivosPage(activos: _activos, onChanged: () => setState(() {})),
      PersonalPage(personal: _personal, onChanged: () => setState(() {})),
      MasPage(
        activos: _activos,
        personal: _personal,
        proveedores: _proveedores,
        asignaciones: _asignaciones,
        mantenimientos: _mantenimientos,
        categorias: _categorias,
        roles: _roles,
        estadosActivo: _estadosActivo,
        estadosPersonal: _estadosPersonal,
        onChanged: () => setState(() {}),
      ),
    ];
    const titulos = ['Panel de control', 'Gestión de activos', 'Gestión de personal', 'Más opciones'];
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset('assets/optigest_logo.png', width: 30, height: 30),
            ),
            const SizedBox(width: 10),
            Flexible(child: Text(titulos[_pagina], overflow: TextOverflow.ellipsis)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Mi perfil',
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () => _mensaje(context, 'Perfil de usuario'),
          ),
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginPage()), (_) => false),
          ),
        ],
      ),
      body: pages[_pagina],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _pagina,
        onDestinationSelected: (value) => setState(() => _pagina = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Inicio'),
          NavigationDestination(icon: Icon(Icons.inventory_2_outlined), selectedIcon: Icon(Icons.inventory_2), label: 'Activos'),
          NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: 'Personal'),
          NavigationDestination(icon: Icon(Icons.more_horiz), label: 'Más'),
        ],
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key, required this.activos, required this.personal, required this.onOpen});
  final List<Activo> activos;
  final List<Empleado> personal;
  final ValueChanged<int> onOpen;

  @override
  Widget build(BuildContext context) {
    final disponibles = activos.where((a) => a.estado == 'Disponible').length;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Resumen operativo', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Wrap(spacing: 12, runSpacing: 12, children: [
          _MetricCard(icon: Icons.inventory_2_outlined, label: 'Activos', value: '${activos.length}', color: Colors.teal),
          _MetricCard(icon: Icons.check_circle_outline, label: 'Disponibles', value: '$disponibles', color: Colors.green),
          _MetricCard(icon: Icons.people_outline, label: 'Personal', value: '${personal.length}', color: Colors.indigo),
        ]),
        const SizedBox(height: 24),
        Text('Acciones rápidas', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Card(child: ListTile(leading: const Icon(Icons.inventory_2_outlined), title: const Text('Gestionar activos'), subtitle: const Text('Registrar, consultar y editar inventario'), trailing: const Icon(Icons.chevron_right), onTap: () => onOpen(1))),
        Card(child: ListTile(leading: const Icon(Icons.people_outline), title: const Text('Gestionar personal'), subtitle: const Text('Registrar y actualizar colaboradores'), trailing: const Icon(Icons.chevron_right), onTap: () => onOpen(2))),
        const SizedBox(height: 24),
        Text('Últimos activos', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Card(child: Column(children: activos.take(3).map((a) => ListTile(title: Text(a.nombre), subtitle: Text('${a.codigo} · ${a.categoria}'), trailing: _EstadoChip(a.estado))).toList())),
      ],
    );
  }
}

class ActivosPage extends StatefulWidget {
  const ActivosPage({super.key, required this.activos, required this.onChanged});
  final List<Activo> activos;
  final VoidCallback onChanged;
  @override
  State<ActivosPage> createState() => _ActivosPageState();
}

class _ActivosPageState extends State<ActivosPage> {
  String _busqueda = '';
  @override
  Widget build(BuildContext context) {
    final encontrados = widget.activos.where((a) => '${a.codigo} ${a.nombre} ${a.categoria}'.toLowerCase().contains(_busqueda.toLowerCase())).toList();
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(onPressed: _nuevoActivo, icon: const Icon(Icons.add), label: const Text('Activo')),
      body: Column(children: [
        Padding(padding: const EdgeInsets.all(16), child: TextField(onChanged: (v) => setState(() => _busqueda = v), decoration: const InputDecoration(prefixIcon: Icon(Icons.search), labelText: 'Buscar activo'))),
        Expanded(child: ListView.builder(itemCount: encontrados.length, itemBuilder: (_, i) { final activo = encontrados[i]; return Card(margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5), child: ListTile(leading: const CircleAvatar(child: Icon(Icons.inventory_2_outlined)), title: Text(activo.nombre), subtitle: Text('${activo.codigo} · ${activo.categoria}\n${_pesos(activo.valor)}'), isThreeLine: true, trailing: _EstadoChip(activo.estado), onTap: () => _detalleActivo(activo))); })),
      ]),
    );
  }

  void _nuevoActivo() async {
    final nuevo = await showModalBottomSheet<Activo>(context: context, isScrollControlled: true, builder: (_) => const _ActivoForm());
    if (nuevo != null) {
      if (widget.activos.any((activo) => activo.codigo.toLowerCase() == nuevo.codigo.toLowerCase())) {
        _mensaje(context, 'Ya existe un activo con ese código.');
        return;
      }
      widget.activos.add(nuevo);
      widget.onChanged();
      setState(() {});
    }
  }
  void _detalleActivo(Activo activo) => showModalBottomSheet<void>(context: context, builder: (_) => _DetalleActivo(activo: activo));
}

class PersonalPage extends StatefulWidget {
  const PersonalPage({super.key, required this.personal, required this.onChanged});
  final List<Empleado> personal;
  final VoidCallback onChanged;
  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  String _busqueda = '';
  @override
  Widget build(BuildContext context) {
    final encontrados = widget.personal.where((p) => '${p.nombre} ${p.documento} ${p.rol}'.toLowerCase().contains(_busqueda.toLowerCase())).toList();
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(onPressed: _nuevoEmpleado, icon: const Icon(Icons.person_add_alt_1), label: const Text('Personal')),
      body: Column(children: [
        Padding(padding: const EdgeInsets.all(16), child: TextField(onChanged: (v) => setState(() => _busqueda = v), decoration: const InputDecoration(prefixIcon: Icon(Icons.search), labelText: 'Buscar por nombre o documento'))),
        Expanded(child: ListView.builder(itemCount: encontrados.length, itemBuilder: (_, i) { final p = encontrados[i]; return Card(margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5), child: ListTile(leading: CircleAvatar(child: Text(p.nombre.substring(0, 1))), title: Text(p.nombre), subtitle: Text('${p.documento} · ${p.rol}'), trailing: _EstadoChip(p.estado))); })),
      ]),
    );
  }
  void _nuevoEmpleado() async {
    final nuevo = await showModalBottomSheet<Empleado>(context: context, isScrollControlled: true, builder: (_) => const _EmpleadoForm());
    if (nuevo != null) {
      if (widget.personal.any((persona) => persona.documento == nuevo.documento)) {
        _mensaje(context, 'Ya existe una persona con ese documento.');
        return;
      }
      widget.personal.add(nuevo);
      widget.onChanged();
      setState(() {});
    }
  }
}

class MasPage extends StatelessWidget {
  const MasPage({
    super.key,
    required this.activos,
    required this.personal,
    required this.proveedores,
    required this.asignaciones,
    required this.mantenimientos,
    required this.categorias,
    required this.roles,
    required this.estadosActivo,
    required this.estadosPersonal,
    required this.onChanged,
  });
  final List<Activo> activos;
  final List<Empleado> personal;
  final List<Proveedor> proveedores;
  final List<Asignacion> asignaciones;
  final List<Mantenimiento> mantenimientos;
  final List<String> categorias, roles, estadosActivo, estadosPersonal;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(16), children: [
        const _SectionTitle('Administración'),
        _Option(
          icon: Icons.assignment_ind_outlined,
          title: 'Asignaciones',
          text: 'Asignar activos a colaboradores',
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => AsignacionesPage(
                activos: activos, personal: personal, asignaciones: asignaciones, onChanged: onChanged))),
        ),
        _Option(
          icon: Icons.build_outlined,
          title: 'Mantenimientos',
          text: 'Registrar mantenimiento de activos',
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => MantenimientosPage(
                activos: activos, proveedores: proveedores, mantenimientos: mantenimientos, onChanged: onChanged))),
        ),
        _Option(
          icon: Icons.category_outlined,
          title: 'Catálogos',
          text: 'Categorías, roles, proveedores y estados',
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => CatalogosPage(
                proveedores: proveedores,
                categorias: categorias,
                roles: roles,
                estadosActivo: estadosActivo,
                estadosPersonal: estadosPersonal,
                onChanged: onChanged,
              ))),
        ),
        _Option(icon: Icons.history, title: 'Historial administrativo', text: 'Consultar cambios registrados', onTap: () => _mensaje(context, 'El historial requiere la API REST del servidor.')),
        const _SectionTitle('Sincronización'),
        Card(color: const Color(0xFFE8F3F3), child: const Padding(padding: EdgeInsets.all(16), child: Text('La interfaz está portada a Flutter. Para guardar datos en Railway hace falta una API REST autenticada en el servidor Java; la app móvil no debe acceder directamente a MySQL.'))),
      ]);
}

// ==================== ASIGNACIONES ====================

class AsignacionesPage extends StatefulWidget {
  const AsignacionesPage({super.key, required this.activos, required this.personal, required this.asignaciones, required this.onChanged});
  final List<Activo> activos;
  final List<Empleado> personal;
  final List<Asignacion> asignaciones;
  final VoidCallback onChanged;
  @override
  State<AsignacionesPage> createState() => _AsignacionesPageState();
}

class _AsignacionesPageState extends State<AsignacionesPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Asignaciones')),
        floatingActionButton: FloatingActionButton.extended(onPressed: _nuevaAsignacion, icon: const Icon(Icons.add), label: const Text('Asignación')),
        body: widget.asignaciones.isEmpty
            ? const Center(child: Text('Aún no hay asignaciones registradas'))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: widget.asignaciones.length,
                itemBuilder: (_, i) {
                  final a = widget.asignaciones[i];
                  final devuelto = a.fechaDevolucion != null;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: const Icon(Icons.assignment_ind_outlined),
                      title: Text('${a.activo.nombre} → ${a.empleado.nombre}'),
                      subtitle: Text('Asignado: ${_fecha(a.fechaAsignacion)}'
                          '${devuelto ? '\nDevuelto: ${_fecha(a.fechaDevolucion!)}' : ''}'
                          '${a.observaciones.isNotEmpty ? '\n${a.observaciones}' : ''}'),
                      isThreeLine: true,
                      trailing: devuelto
                          ? const Chip(label: Text('Devuelto', style: TextStyle(fontSize: 11)), side: BorderSide.none)
                          : TextButton(onPressed: () => _marcarDevuelto(a), child: const Text('Devolver')),
                    ),
                  );
                },
              ),
      );

  void _marcarDevuelto(Asignacion a) {
    setState(() => a.fechaDevolucion = DateTime.now());
    widget.activos.firstWhere((x) => x.codigo == a.activo.codigo).estado = 'Disponible';
    widget.onChanged();
  }

  void _nuevaAsignacion() async {
    final disponibles = widget.activos.where((activo) => activo.estado == 'Disponible').toList();
    if (disponibles.isEmpty || widget.personal.isEmpty) {
      _mensaje(context, 'Debes tener un activo disponible y un colaborador registrados.');
      return;
    }
    final nueva = await showModalBottomSheet<Asignacion>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _AsignacionForm(activos: disponibles, personal: widget.personal),
    );
    if (nueva != null) {
      setState(() => widget.asignaciones.add(nueva));
      nueva.activo.estado = 'Asignado';
      widget.onChanged();
    }
  }
}

class _AsignacionForm extends StatefulWidget {
  const _AsignacionForm({required this.activos, required this.personal});
  final List<Activo> activos;
  final List<Empleado> personal;
  @override
  State<_AsignacionForm> createState() => _AsignacionFormState();
}

class _AsignacionFormState extends State<_AsignacionForm> {
  final _form = GlobalKey<FormState>();
  final _obs = TextEditingController();
  late Activo _activo = widget.activos.first;
  late Empleado _empleado = widget.personal.first;

  @override
  Widget build(BuildContext context) => _BottomForm(
        title: 'Nueva asignación',
        child: Form(
          key: _form,
          child: Column(children: [
            DropdownButtonFormField(
              value: _activo,
              decoration: const InputDecoration(labelText: 'Activo'),
              items: widget.activos.map((a) => DropdownMenuItem(value: a, child: Text('${a.codigo} · ${a.nombre}'))).toList(),
              onChanged: (v) => setState(() => _activo = v!),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField(
              value: _empleado,
              decoration: const InputDecoration(labelText: 'Colaborador'),
              items: widget.personal.map((p) => DropdownMenuItem(value: p, child: Text(p.nombre))).toList(),
              onChanged: (v) => setState(() => _empleado = v!),
            ),
            const SizedBox(height: 12),
            _field(_obs, 'Observaciones (opcional)'),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => Navigator.pop(
                context,
                Asignacion(activo: _activo, empleado: _empleado, fechaAsignacion: DateTime.now(), observaciones: _obs.text.trim()),
              ),
              child: const Text('Guardar asignación'),
            ),
          ]),
        ),
      );
  @override
  void dispose() {
    _obs.dispose();
    super.dispose();
  }
}

// ==================== MANTENIMIENTOS ====================

class MantenimientosPage extends StatefulWidget {
  const MantenimientosPage({super.key, required this.activos, required this.proveedores, required this.mantenimientos, required this.onChanged});
  final List<Activo> activos;
  final List<Proveedor> proveedores;
  final List<Mantenimiento> mantenimientos;
  final VoidCallback onChanged;
  @override
  State<MantenimientosPage> createState() => _MantenimientosPageState();
}

class _MantenimientosPageState extends State<MantenimientosPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Mantenimientos')),
        floatingActionButton: FloatingActionButton.extended(onPressed: _nuevoMantenimiento, icon: const Icon(Icons.add), label: const Text('Mantenimiento')),
        body: widget.mantenimientos.isEmpty
            ? const Center(child: Text('Aún no hay mantenimientos registrados'))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: widget.mantenimientos.length,
                itemBuilder: (_, i) {
                  final m = widget.mantenimientos[i];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: const Icon(Icons.build_outlined),
                      title: Text(m.activo.nombre),
                      subtitle: Text('${_fecha(m.fecha)} · ${m.proveedor.nombre}\n${_pesos(m.costo)}${m.descripcion.isNotEmpty ? '\n${m.descripcion}' : ''}'),
                      isThreeLine: true,
                      trailing: m.finalizado
                          ? const Chip(label: Text('Finalizado', style: TextStyle(fontSize: 11)), side: BorderSide.none)
                          : TextButton(onPressed: () => _finalizar(m), child: const Text('Finalizar')),
                    ),
                  );
                },
              ),
      );

  void _nuevoMantenimiento() async {
    final disponibles = widget.activos.where((activo) => activo.estado == 'Disponible').toList();
    if (disponibles.isEmpty || widget.proveedores.isEmpty) {
      _mensaje(context, 'Debes tener un activo disponible y un proveedor registrados.');
      return;
    }
    final nuevo = await showModalBottomSheet<Mantenimiento>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _MantenimientoForm(activos: disponibles, proveedores: widget.proveedores),
    );
    if (nuevo != null) {
      setState(() => widget.mantenimientos.add(nuevo));
      nuevo.activo.estado = 'En mantenimiento';
      widget.onChanged();
    }
  }

  void _finalizar(Mantenimiento mantenimiento) {
    setState(() => mantenimiento.finalizado = true);
    mantenimiento.activo.estado = 'Disponible';
    widget.onChanged();
    _mensaje(context, 'Mantenimiento finalizado; el activo vuelve a estar disponible.');
  }
}

class _MantenimientoForm extends StatefulWidget {
  const _MantenimientoForm({required this.activos, required this.proveedores});
  final List<Activo> activos;
  final List<Proveedor> proveedores;
  @override
  State<_MantenimientoForm> createState() => _MantenimientoFormState();
}

class _MantenimientoFormState extends State<_MantenimientoForm> {
  final _form = GlobalKey<FormState>();
  final _costo = TextEditingController();
  final _descripcion = TextEditingController();
  late Activo _activo = widget.activos.first;
  late Proveedor _proveedor = widget.proveedores.first;

  @override
  Widget build(BuildContext context) => _BottomForm(
        title: 'Nuevo mantenimiento',
        child: Form(
          key: _form,
          child: Column(children: [
            DropdownButtonFormField(
              value: _activo,
              decoration: const InputDecoration(labelText: 'Activo'),
              items: widget.activos.map((a) => DropdownMenuItem(value: a, child: Text('${a.codigo} · ${a.nombre}'))).toList(),
              onChanged: (v) => setState(() => _activo = v!),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField(
              value: _proveedor,
              decoration: const InputDecoration(labelText: 'Proveedor'),
              items: widget.proveedores.map((p) => DropdownMenuItem(value: p, child: Text(p.nombre))).toList(),
              onChanged: (v) => setState(() => _proveedor = v!),
            ),
            const SizedBox(height: 12),
            _field(_costo, 'Costo', type: TextInputType.number),
            const SizedBox(height: 12),
            _field(_descripcion, 'Descripción (opcional)'),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                if (_form.currentState!.validate()) {
                  Navigator.pop(
                    context,
                    Mantenimiento(
                      activo: _activo,
                      proveedor: _proveedor,
                      fecha: DateTime.now(),
                      costo: int.tryParse(_costo.text) ?? 0,
                      descripcion: _descripcion.text.trim(),
                    ),
                  );
                }
              },
              child: const Text('Guardar mantenimiento'),
            ),
          ]),
        ),
      );
  @override
  void dispose() {
    _costo.dispose();
    _descripcion.dispose();
    super.dispose();
  }
}

// ==================== CATÁLOGOS ====================

class CatalogosPage extends StatefulWidget {
  const CatalogosPage({
    super.key,
    required this.proveedores,
    required this.categorias,
    required this.roles,
    required this.estadosActivo,
    required this.estadosPersonal,
    required this.onChanged,
  });
  final List<Proveedor> proveedores;
  final List<String> categorias, roles, estadosActivo, estadosPersonal;
  final VoidCallback onChanged;
  @override
  State<CatalogosPage> createState() => _CatalogosPageState();
}

class _CatalogosPageState extends State<CatalogosPage> {
  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Catálogos'),
            bottom: const TabBar(tabs: [
              Tab(text: 'Categorías'),
              Tab(text: 'Roles'),
              Tab(text: 'Proveedores'),
              Tab(text: 'Estados'),
            ]),
          ),
          body: TabBarView(children: [
            _ListaSimple(titulo: 'categoría', items: widget.categorias, onChanged: widget.onChanged),
            _ListaSimple(titulo: 'rol', items: widget.roles, onChanged: widget.onChanged),
            _ListaProveedores(proveedores: widget.proveedores, onChanged: widget.onChanged),
            DefaultTabController(
              length: 2,
              child: Column(children: [
                const TabBar(tabs: [Tab(text: 'De activos'), Tab(text: 'De personal')]),
                Expanded(
                  child: TabBarView(children: [
                    _ListaSimple(titulo: 'estado de activo', items: widget.estadosActivo, onChanged: widget.onChanged),
                    _ListaSimple(titulo: 'estado de personal', items: widget.estadosPersonal, onChanged: widget.onChanged),
                  ]),
                ),
              ]),
            ),
          ]),
        ),
      );
}

class _ListaSimple extends StatefulWidget {
  const _ListaSimple({required this.titulo, required this.items, required this.onChanged});
  final String titulo;
  final List<String> items;
  final VoidCallback onChanged;
  @override
  State<_ListaSimple> createState() => _ListaSimpleState();
}

class _ListaSimpleState extends State<_ListaSimple> {
  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: _agregar, child: const Icon(Icons.add)),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: widget.items.length,
          itemBuilder: (_, i) => Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(widget.items[i]),
              trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => setState(() {
                    widget.items.removeAt(i);
                    widget.onChanged();
                  })),
            ),
          ),
        ),
      );

  void _agregar() async {
    final controlador = TextEditingController();
    final valor = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _BottomForm(
        title: 'Nueva ${widget.titulo}',
        child: Column(children: [
          _field(controlador, 'Descripción'),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () => controlador.text.trim().isEmpty ? null : Navigator.pop(context, controlador.text.trim()),
            child: const Text('Guardar'),
          ),
        ]),
      ),
    );
    if (valor != null && valor.isNotEmpty) {
      setState(() => widget.items.add(valor));
      widget.onChanged();
    }
  }
}

class _ListaProveedores extends StatefulWidget {
  const _ListaProveedores({required this.proveedores, required this.onChanged});
  final List<Proveedor> proveedores;
  final VoidCallback onChanged;
  @override
  State<_ListaProveedores> createState() => _ListaProveedoresState();
}

class _ListaProveedoresState extends State<_ListaProveedores> {
  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: _agregar, child: const Icon(Icons.add)),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: widget.proveedores.length,
          itemBuilder: (_, i) {
            final p = widget.proveedores[i];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.local_shipping_outlined),
                title: Text(p.nombre),
                subtitle: Text('${p.telefono} · ${p.direccion}${p.email.isNotEmpty ? '\n${p.email}' : ''}'),
                isThreeLine: true,
                trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => setState(() {
                      widget.proveedores.removeAt(i);
                      widget.onChanged();
                    })),
              ),
            );
          },
        ),
      );

  void _agregar() async {
    final nombre = TextEditingController();
    final telefono = TextEditingController();
    final direccion = TextEditingController();
    final email = TextEditingController();
    final form = GlobalKey<FormState>();
    final nuevo = await showModalBottomSheet<Proveedor>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _BottomForm(
        title: 'Nuevo proveedor',
        child: Form(
          key: form,
          child: Column(children: [
            _field(nombre, 'Nombre'),
            const SizedBox(height: 12),
            _field(telefono, 'Teléfono', type: TextInputType.phone),
            const SizedBox(height: 12),
            _field(direccion, 'Dirección'),
            const SizedBox(height: 12),
            TextFormField(controller: email, decoration: const InputDecoration(labelText: 'Email (opcional)')),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                if (form.currentState!.validate()) {
                  Navigator.pop(
                    context,
                    Proveedor(nombre: nombre.text.trim(), telefono: telefono.text.trim(), direccion: direccion.text.trim(), email: email.text.trim()),
                  );
                }
              },
              child: const Text('Guardar proveedor'),
            ),
          ]),
        ),
      ),
    );
    if (nuevo != null) {
      setState(() => widget.proveedores.add(nuevo));
      widget.onChanged();
    }
  }
}

class _ActivoForm extends StatefulWidget { const _ActivoForm(); @override State<_ActivoForm> createState() => _ActivoFormState(); }
class _ActivoFormState extends State<_ActivoForm> {
  final _form = GlobalKey<FormState>(); final _codigo = TextEditingController(); final _nombre = TextEditingController(); final _valor = TextEditingController(); String _categoria = 'Electrónicos';
  @override Widget build(BuildContext context) => _BottomForm(title: 'Registrar activo', child: Form(key: _form, child: Column(children: [
    _field(_codigo, 'Código'), const SizedBox(height: 12), _field(_nombre, 'Nombre del activo'), const SizedBox(height: 12), _field(_valor, 'Valor', type: TextInputType.number), const SizedBox(height: 12),
    DropdownButtonFormField(value: _categoria, decoration: const InputDecoration(labelText: 'Categoría'), items: const [DropdownMenuItem(value: 'Electrónicos', child: Text('Electrónicos')), DropdownMenuItem(value: 'Herramientas', child: Text('Herramientas'))], onChanged: (v) => setState(() => _categoria = v!)), const SizedBox(height: 20),
    FilledButton(onPressed: () { if (_form.currentState!.validate()) Navigator.pop(context, Activo(codigo: _codigo.text.trim(), nombre: _nombre.text.trim(), categoria: _categoria, estado: 'Disponible', valor: int.tryParse(_valor.text) ?? 0)); }, child: const Text('Guardar activo')),
  ])));
  @override void dispose() { _codigo.dispose(); _nombre.dispose(); _valor.dispose(); super.dispose(); }
}

class _EmpleadoForm extends StatefulWidget { const _EmpleadoForm(); @override State<_EmpleadoForm> createState() => _EmpleadoFormState(); }
class _EmpleadoFormState extends State<_EmpleadoForm> {
  final _form = GlobalKey<FormState>(); final _nombre = TextEditingController(); final _documento = TextEditingController(); String _rol = 'Personal fijo';
  @override Widget build(BuildContext context) => _BottomForm(title: 'Registrar personal', child: Form(key: _form, child: Column(children: [
    _field(_nombre, 'Nombre completo'), const SizedBox(height: 12), _field(_documento, 'Documento', type: TextInputType.number), const SizedBox(height: 12),
    DropdownButtonFormField(value: _rol, decoration: const InputDecoration(labelText: 'Rol'), items: const [DropdownMenuItem(value: 'Administrador', child: Text('Administrador')), DropdownMenuItem(value: 'Personal fijo', child: Text('Personal fijo')), DropdownMenuItem(value: 'Temporal', child: Text('Temporal'))], onChanged: (v) => setState(() => _rol = v!)), const SizedBox(height: 20),
    FilledButton(onPressed: () { if (_form.currentState!.validate()) Navigator.pop(context, Empleado(nombre: _nombre.text.trim(), documento: _documento.text.trim(), rol: _rol, estado: 'Activo')); }, child: const Text('Guardar personal')),
  ])));
  @override void dispose() { _nombre.dispose(); _documento.dispose(); super.dispose(); }
}

class _BottomForm extends StatelessWidget { const _BottomForm({required this.title, required this.child}); final String title; final Widget child; @override Widget build(BuildContext context) => Padding(padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20), child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [Text(title, style: Theme.of(context).textTheme.titleLarge), const SizedBox(height: 20), child]))); }
class _DetalleActivo extends StatelessWidget { const _DetalleActivo({required this.activo}); final Activo activo; @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(activo.nombre, style: Theme.of(context).textTheme.titleLarge), const SizedBox(height: 14), Text('Código: ${activo.codigo}'), Text('Categoría: ${activo.categoria}'), Text('Estado: ${activo.estado}'), Text('Valor: ${_pesos(activo.valor)}'), const SizedBox(height: 12)])); }
class _MetricCard extends StatelessWidget { const _MetricCard({required this.icon, required this.label, required this.value, required this.color}); final IconData icon; final String label, value; final Color color; @override Widget build(BuildContext context) => SizedBox(width: 165, child: Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: color), const SizedBox(height: 14), Text(value, style: Theme.of(context).textTheme.headlineSmall), Text(label)])))); }
class _EstadoChip extends StatelessWidget { const _EstadoChip(this.estado); final String estado; @override Widget build(BuildContext context) { final color = estado == 'Disponible' || estado == 'Activo' ? Colors.green : Colors.orange; return Chip(label: Text(estado, style: const TextStyle(fontSize: 11)), side: BorderSide.none, backgroundColor: color.withOpacity(.14)); } }
class _SectionTitle extends StatelessWidget { const _SectionTitle(this.text); final String text; @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(top: 8, bottom: 8), child: Text(text, style: Theme.of(context).textTheme.titleLarge)); }
class _Option extends StatelessWidget { const _Option({required this.icon, required this.title, required this.text, this.onTap}); final IconData icon; final String title, text; final VoidCallback? onTap; @override Widget build(BuildContext context) => Card(child: ListTile(leading: Icon(icon), title: Text(title), subtitle: Text(text), trailing: const Icon(Icons.chevron_right), onTap: onTap ?? () => _mensaje(context, '$title estará conectado cuando la API REST esté disponible.'))); }
class Activo { Activo({required this.codigo, required this.nombre, required this.categoria, required this.estado, required this.valor}); final String codigo, nombre, categoria; String estado; final int valor; }
class Empleado { Empleado({required this.nombre, required this.documento, required this.rol, required this.estado}); final String nombre, documento, rol; String estado; }
class Proveedor { Proveedor({required this.nombre, required this.telefono, required this.direccion, required this.email}); final String nombre, telefono, direccion, email; }
class Asignacion {
  Asignacion({required this.activo, required this.empleado, required this.fechaAsignacion, this.fechaDevolucion, this.observaciones = ''});
  final Activo activo;
  final Empleado empleado;
  final DateTime fechaAsignacion;
  DateTime? fechaDevolucion;
  final String observaciones;
}
class Mantenimiento {
  Mantenimiento({required this.activo, required this.proveedor, required this.fecha, required this.costo, this.descripcion = '', this.finalizado = false});
  final Activo activo;
  final Proveedor proveedor;
  final DateTime fecha;
  final int costo;
  final String descripcion;
  bool finalizado;
}
Widget _field(TextEditingController controller, String label, {TextInputType? type}) => TextFormField(controller: controller, keyboardType: type, decoration: InputDecoration(labelText: label), validator: (v) => v == null || v.trim().isEmpty ? 'Este campo es obligatorio' : null);
String _pesos(int valor) => '\$ ${valor.toString().replaceAllMapped(RegExp(r'(?=(\d{3})+(?!\d))'), (m) => '.')}';
String _fecha(DateTime f) => '${f.day.toString().padLeft(2, '0')}/${f.month.toString().padLeft(2, '0')}/${f.year}';
void _mensaje(BuildContext context, String texto) {
  if (texto.contains('endpoint de API')) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RecuperarContrasenaPage()));
    return;
  }
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
}
