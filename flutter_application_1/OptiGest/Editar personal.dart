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
      title: 'Editar Personal',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const EditarPersonalPage(),
    );
  }
}

class EditarPersonalPage extends StatefulWidget {
  const EditarPersonalPage({super.key});

  @override
  State<EditarPersonalPage> createState() => _EditarPersonalPageState();
}

class _EditarPersonalPageState extends State<EditarPersonalPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final correoController = TextEditingController();
  final telefonoController = TextEditingController();
  final documentoController = TextEditingController();
  final observacionController = TextEditingController();

  String? tipoDocumento;

  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(animationController);

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(animationController);

    animationController.forward();
  }

  @override
  void dispose() {
    nombreController.dispose();
    apellidoController.dispose();
    correoController.dispose();
    telefonoController.dispose();
    documentoController.dispose();
    observacionController.dispose();
    animationController.dispose();
    super.dispose();
  }

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xffcbd5e1),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xffcbd5e1),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xff2563eb),
          width: 2,
        ),
      ),
    );
  }

  Widget campo({
    required String titulo,
    required Widget child,
    required double width,
  }) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xfff1f5f9),
              Color(0xffdbeafe),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: slideAnimation,
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 850,
                  ),
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.97),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 30,
                        offset: const Offset(0, 12),
                      )
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Editar Miembro del Personal",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff0f172a),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Actualice la información del miembro del personal y guarde los cambios.",
                          style: TextStyle(
                            color: Color(0xff64748b),
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 30),

                        LayoutBuilder(
                          builder: (context, constraints) {
                            bool mobile = constraints.maxWidth < 700;

                            double fieldWidth = mobile
                                ? constraints.maxWidth
                                : (constraints.maxWidth / 2) - 12;

                            return Wrap(
                              spacing: 24,
                              runSpacing: 24,
                              children: [
                                campo(
                                  titulo: "Nombre",
                                  width: fieldWidth,
                                  child: TextFormField(
                                    controller: nombreController,
                                    decoration:
                                        inputDecoration("Ej. Sebastian"),
                                  ),
                                ),
                                campo(
                                  titulo: "Apellido",
                                  width: fieldWidth,
                                  child: TextFormField(
                                    controller: apellidoController,
                                    decoration:
                                        inputDecoration("Ej. Muñoz"),
                                  ),
                                ),
                                campo(
                                  titulo: "Correo electrónico",
                                  width: fieldWidth,
                                  child: TextFormField(
                                    controller: correoController,
                                    keyboardType:
                                        TextInputType.emailAddress,
                                    decoration: inputDecoration(
                                      "ejemplo@empresa.com",
                                    ),
                                  ),
                                ),
                                campo(
                                  titulo: "Número de teléfono",
                                  width: fieldWidth,
                                  child: TextFormField(
                                    controller: telefonoController,
                                    keyboardType: TextInputType.phone,
                                    decoration: inputDecoration(
                                      "+57 (312) 414-8236",
                                    ),
                                  ),
                                ),
                                campo(
                                  titulo: "Tipo de Documento",
                                  width: fieldWidth,
                                  child: DropdownButtonFormField<String>(
                                    decoration:
                                        inputDecoration("Seleccione tipo"),
                                    value: tipoDocumento,
                                    items: const [
                                      DropdownMenuItem(
                                        value:
                                            "Cédula de ciudadanía",
                                        child: Text(
                                          "Cédula de ciudadanía",
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: "Pasaporte",
                                        child: Text("Pasaporte"),
                                      ),
                                      DropdownMenuItem(
                                        value:
                                            "Cédula extranjera",
                                        child: Text(
                                          "Cédula extranjera",
                                        ),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        tipoDocumento = value;
                                      });
                                    },
                                  ),
                                ),
                                campo(
                                  titulo: "N. Documento",
                                  width: fieldWidth,
                                  child: TextFormField(
                                    controller: documentoController,
                                    decoration:
                                        inputDecoration("1015485799"),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),

                        const SizedBox(height: 24),

                        const Text(
                          "Observación",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff334155),
                          ),
                        ),
                        const SizedBox(height: 8),

                        TextFormField(
                          controller: observacionController,
                          maxLines: 4,
                          decoration: inputDecoration(
                            "Añada detalles adicionales...",
                          ),
                        ),

                        const SizedBox(height: 35),

                        LayoutBuilder(
                          builder: (context, constraints) {
                            bool mobile = constraints.maxWidth < 500;

                            if (mobile) {
                              return Column(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "Cancelar",
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      icon: const Icon(
                                        Icons.check,
                                      ),
                                      label: const Text(
                                        "Guardar cambios",
                                      ),
                                      onPressed: guardar,
                                    ),
                                  ),
                                ],
                              );
                            }

                            return Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.end,
                              children: [
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Cancelar",
                                  ),
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.check),
                                  label: const Text(
                                    "Guardar cambios",
                                  ),
                                  onPressed: guardar,
                                ),
                              ],
                            );
                          },
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

  void guardar() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Información actualizada correctamente',
          ),
        ),
      );
    }
  }
}