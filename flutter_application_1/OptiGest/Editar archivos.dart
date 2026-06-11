import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Editar Activo',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Inter',
        colorSchemeSeed: Colors.blue,
      ),
      home: const EditarActivoPage(),
    );
  }
}

class EditarActivoPage extends StatefulWidget {
  const EditarActivoPage({super.key});

  @override
  State<EditarActivoPage> createState() => _EditarActivoPageState();
}

class _EditarActivoPageState extends State<EditarActivoPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final nombreController = TextEditingController();
  final identificadorController = TextEditingController();
  final valorController = TextEditingController();

  String ubicacion = "Almacén A";
  String estado = "En uso";
  DateTime? fechaSeleccionada;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    nombreController.dispose();
    identificadorController.dispose();
    valorController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> seleccionarFecha() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (fecha != null) {
      setState(() {
        fechaSeleccionada = fecha;
      });
    }
  }

  String get fechaTexto {
    if (fechaSeleccionada == null) return "DD/MM/AAAA";

    return "${fechaSeleccionada!.day.toString().padLeft(2, '0')}/"
        "${fechaSeleccionada!.month.toString().padLeft(2, '0')}/"
        "${fechaSeleccionada!.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xffeef2f7),
              Color(0xffdbeafe),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 700,
                  ),
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.96),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 40,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Editar Activo",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1e293b),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Modifique la información del activo y guarde los cambios.",
                          style: TextStyle(
                            color: Color(0xff64748b),
                          ),
                        ),
                        const SizedBox(height: 30),

                        LayoutBuilder(
                          builder: (context, constraints) {
                            bool mobile = constraints.maxWidth < 600;

                            return Wrap(
                              spacing: 20,
                              runSpacing: 20,
                              children: [
                                _campo(
                                  width: mobile
                                      ? constraints.maxWidth
                                      : (constraints.maxWidth / 2) - 10,
                                  label: "Nombre del activo",
                                  child: TextFormField(
                                    controller: nombreController,
                                    decoration: const InputDecoration(
                                      hintText: "Ej. Laptop Dell XPS 15",
                                    ),
                                  ),
                                ),
                                _campo(
                                  width: mobile
                                      ? constraints.maxWidth
                                      : (constraints.maxWidth / 2) - 10,
                                  label: "Identificador único",
                                  child: TextFormField(
                                    controller: identificadorController,
                                    decoration: const InputDecoration(
                                      hintText: "Ej. ACT-00123",
                                    ),
                                  ),
                                ),
                                _campo(
                                  width: mobile
                                      ? constraints.maxWidth
                                      : (constraints.maxWidth / 2) - 10,
                                  label: "Ubicación",
                                  child: DropdownButtonFormField<String>(
                                    value: ubicacion,
                                    items: const [
                                      DropdownMenuItem(
                                        value: "Almacén A",
                                        child: Text("Almacén A"),
                                      ),
                                      DropdownMenuItem(
                                        value: "Almacén B",
                                        child: Text("Almacén B"),
                                      ),
                                    ],
                                    onChanged: (v) {
                                      setState(() {
                                        ubicacion = v!;
                                      });
                                    },
                                  ),
                                ),
                                _campo(
                                  width: mobile
                                      ? constraints.maxWidth
                                      : (constraints.maxWidth / 2) - 10,
                                  label: "Estado",
                                  child: DropdownButtonFormField<String>(
                                    value: estado,
                                    items: const [
                                      DropdownMenuItem(
                                        value: "En uso",
                                        child: Text("En uso"),
                                      ),
                                      DropdownMenuItem(
                                        value: "Disponible",
                                        child: Text("Disponible"),
                                      ),
                                      DropdownMenuItem(
                                        value: "Dañado",
                                        child: Text("Dañado"),
                                      ),
                                    ],
                                    onChanged: (v) {
                                      setState(() {
                                        estado = v!;
                                      });
                                    },
                                  ),
                                ),
                                _campo(
                                  width: mobile
                                      ? constraints.maxWidth
                                      : (constraints.maxWidth / 2) - 10,
                                  label: "Fecha de adquisición",
                                  child: InkWell(
                                    onTap: seleccionarFecha,
                                    child: InputDecorator(
                                      decoration: const InputDecoration(
                                        suffixIcon: Icon(Icons.calendar_month),
                                      ),
                                      child: Text(fechaTexto),
                                    ),
                                  ),
                                ),
                                _campo(
                                  width: mobile
                                      ? constraints.maxWidth
                                      : (constraints.maxWidth / 2) - 10,
                                  label: "Valor (COP)",
                                  child: TextFormField(
                                    controller: valorController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      prefixText: "\$ ",
                                      hintText: "500.000",
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),

                        const SizedBox(height: 30),
                        const Divider(),
                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancelar"),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Cambios guardados correctamente',
                                      ),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff2563eb),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 6,
                              ),
                              child: const Text(
                                "Guardar cambios",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        )
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

  Widget _campo({
    required String label,
    required Widget child,
    required double width,
  }) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xff334155),
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}