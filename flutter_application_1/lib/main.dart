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
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0D6265)),
          scaffoldBackgroundColor: const Color(0xFFF6F8F9),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
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
                          const CircleAvatar(
                            radius: 38,
                            backgroundColor: Color(0xFF0D6265),
                            child: Icon(Icons.inventory_2_outlined,
                                color: Colors.white, size: 42),
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

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardPage(activos: _activos, personal: _personal, onOpen: (index) => setState(() => _pagina = index)),
      ActivosPage(activos: _activos, onChanged: () => setState(() {})),
      PersonalPage(personal: _personal, onChanged: () => setState(() {})),
      const MasPage(),
    ];
    const titulos = ['Panel de control', 'Gestión de activos', 'Gestión de personal', 'Más opciones'];
    return Scaffold(
      appBar: AppBar(
        title: Text(titulos[_pagina]),
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
    if (nuevo != null) { widget.activos.add(nuevo); widget.onChanged(); setState(() {}); }
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
  void _nuevoEmpleado() async { final nuevo = await showModalBottomSheet<Empleado>(context: context, isScrollControlled: true, builder: (_) => const _EmpleadoForm()); if (nuevo != null) { widget.personal.add(nuevo); widget.onChanged(); setState(() {}); } }
}

class MasPage extends StatelessWidget {
  const MasPage({super.key});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(16), children: [
        const _SectionTitle('Administración'),
        _Option(icon: Icons.assignment_ind_outlined, title: 'Asignaciones', text: 'Asignar activos a colaboradores'),
        _Option(icon: Icons.build_outlined, title: 'Mantenimientos', text: 'Registrar mantenimiento de activos'),
        _Option(icon: Icons.category_outlined, title: 'Catálogos', text: 'Categorías, roles, proveedores y estados'),
        _Option(icon: Icons.history, title: 'Historial administrativo', text: 'Consultar cambios registrados'),
        const _SectionTitle('Sincronización'),
        Card(color: const Color(0xFFE8F3F3), child: const Padding(padding: EdgeInsets.all(16), child: Text('La interfaz está portada a Flutter. Para guardar datos en Railway hace falta una API REST autenticada en el servidor Java; la app móvil no debe acceder directamente a MySQL.'))),
      ]);
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
class _Option extends StatelessWidget { const _Option({required this.icon, required this.title, required this.text}); final IconData icon; final String title, text; @override Widget build(BuildContext context) => Card(child: ListTile(leading: Icon(icon), title: Text(title), subtitle: Text(text), trailing: const Icon(Icons.chevron_right), onTap: () => _mensaje(context, '$title estará conectado cuando la API REST esté disponible.'))); }
class Activo { Activo({required this.codigo, required this.nombre, required this.categoria, required this.estado, required this.valor}); final String codigo, nombre, categoria, estado; final int valor; }
class Empleado { Empleado({required this.nombre, required this.documento, required this.rol, required this.estado}); final String nombre, documento, rol, estado; }
Widget _field(TextEditingController controller, String label, {TextInputType? type}) => TextFormField(controller: controller, keyboardType: type, decoration: InputDecoration(labelText: label), validator: (v) => v == null || v.trim().isEmpty ? 'Este campo es obligatorio' : null);
String _pesos(int valor) => '\$ ${valor.toString().replaceAllMapped(RegExp(r'(?=(\d{3})+(?!\d))'), (m) => '.')}';
void _mensaje(BuildContext context, String texto) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
