import 'package:flutter/material.dart';

void main() {
  runApp(const OptiGestApp());
}

class OptiGestApp extends StatelessWidget {
  const OptiGestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OptiGest',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'DM Sans',
        colorSchemeSeed: Colors.blue,
      ),
      home: const GestionActivosScreen(),
    );
  }
}

class GestionActivosScreen extends StatelessWidget {
  const GestionActivosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activos = [
      [
        "Tractor",
        "5",
        "Oficina Total S.A.",
        "15/05/2024",
        "N/A"
      ],
      [
        "Amoladora DeWalt",
        "3",
        "ToolMax Ltda.",
        "10/06/2024",
        "20/06/2024"
      ],
      [
        "Taladro Percutor Bosch",
        "8",
        "Ferretería Central",
        "02/07/2024",
        "N/A"
      ],
      [
        "Generador Eléctrico Honda",
        "2",
        "Energía Vital SAS",
        "12/08/2024",
        "15/12/2024"
      ],
      [
        "Sierra Circular Makita",
        "12",
        "Suministros Industriales",
        "05/09/2024",
        "N/A"
      ],
    ];

    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      body: Row(
        children: [

          /// SIDEBAR
          Container(
            width: 270,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.95),
              border: Border(
                right: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 30),

                const ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(0xffEFF6FF),
                    child: Icon(
                      Icons.build,
                      color: Colors.blue,
                    ),
                  ),
                  title: Text(
                    "OptiGest",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                _menuItem(Icons.grid_view, "Inicio"),
                _menuItem(Icons.inventory_2, "Activos", active: true),
                _menuItem(Icons.badge, "Personal"),
                _menuItem(Icons.settings, "Configuración"),
                _menuItem(Icons.logout, "Cerrar sesión"),
              ],
            ),
          ),

          /// CONTENIDO
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [

                  /// TOPBAR
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.05),
                          blurRadius: 20,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Gestión de Activos",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Vista general de Activos",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// BUSCADOR + BOTÓN
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText:
                                "Buscar producto o insumo...",
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add),
                        label: const Text(
                          "Registrar Activo",
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xff2563EB),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 18,
                          ),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 25),

                  /// TABLA
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.05),
                            blurRadius: 20,
                          )
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: DataTable(
                          headingRowColor:
                              WidgetStateProperty.all(
                            const Color(0xffEFF6FF),
                          ),
                          columns: const [
                            DataColumn(
                              label: Text("Nombre"),
                            ),
                            DataColumn(
                              label: Text("Cantidad"),
                            ),
                            DataColumn(
                              label: Text("Proveedor"),
                            ),
                            DataColumn(
                              label: Text("Fecha Asignación"),
                            ),
                            DataColumn(
                              label: Text("Fecha Devolución"),
                            ),
                            DataColumn(
                              label: Text("Acciones"),
                            ),
                          ],
                          rows: activos.map((activo) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  Text(
                                    activo[0],
                                    style: const TextStyle(
                                      fontWeight:
                                          FontWeight.w600,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    activo[1],
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataCell(Text(activo[2])),
                                DataCell(Text(activo[3])),
                                DataCell(Text(activo[4])),

                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () {},
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _menuItem(
    IconData icon,
    String text, {
    bool active = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: active
            ? const Color(0xff2563EB)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: active ? Colors.white : Colors.grey[700],
        ),
        title: Text(
          text,
          style: TextStyle(
            color:
                active ? Colors.white : Colors.grey[800],
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}