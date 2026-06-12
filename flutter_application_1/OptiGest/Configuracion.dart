import 'package:flutter/material.dart';

class ConfiguracionScreen extends StatelessWidget {
  const ConfiguracionScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xffF3F6FB),

      appBar: AppBar(
        title: const Text("Configuración"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Center(
              child: Column(
                children: [
                  Text(
                    "Configuración del Sistema",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Administre las tablas maestras de OptiGest",
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),

            const SizedBox(height: 40),

            buildSection(
              "Personal",
              Icons.people,
              [
                "Personal",
                "Roles",
                "Documentos",
                "Estado Personal",
              ],
            ),

            buildSection(
              "Activos",
              Icons.inventory,
              [
                "Activos",
                "Categorías",
                "Estado Activo",
                "Proveedores",
              ],
            ),

            buildSection(
              "Operación",
              Icons.settings,
              [
                "Asignaciones",
                "Programación Personal",
                "Horarios",
                "Días",
                "Mantenimiento",
              ],
            ),

            const SizedBox(height: 30),

            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.arrow_back),
                label: const Text("Volver al Panel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildSection(
    String titulo,
    IconData icon,
    List<String> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        Row(
          children: [
            Icon(icon),
            const SizedBox(width: 10),
            Text(
              titulo,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),

          itemCount: items.length,

          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1.2,
          ),

          itemBuilder: (_, index) {
            return Card(
              elevation: 3,

              child: InkWell(
                borderRadius: BorderRadius.circular(12),

                onTap: () {},

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [

                    const Icon(
                      Icons.folder_open,
                      size: 45,
                      color: Colors.blue,
                    ),

                    const SizedBox(height: 12),

                    Text(
                      items[index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 35),
      ],
    );
  }
}