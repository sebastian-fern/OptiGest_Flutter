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
      title: 'Gestión de Personal',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const GestionPersonalScreen(),
    );
  }
}

class GestionPersonalScreen extends StatelessWidget {
  const GestionPersonalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final personal = [
      {
        "nombre": "Sebastian",
        "apellido": "Rodriguez",
        "estado": "Activo",
        "fecha": "01/12/25",
        "id": "100058247"
      },
      {
        "nombre": "Valentina",
        "apellido": "Morales",
        "estado": "Activo",
        "fecha": "15/01/26",
        "id": "101245789"
      },
      {
        "nombre": "Andrés",
        "apellido": "Pérez",
        "estado": "Vacaciones",
        "fecha": "10/05/24",
        "id": "108523641"
      }
    ];

    return Scaffold(
      backgroundColor: const Color(0xffF4F6F9),
      body: Row(
        children: [

          /// SIDEBAR
          Container(
            width: 260,
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 30),

                const ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(0xffEAF2FF),
                    child: Icon(
                      Icons.build,
                      color: Colors.blue,
                    ),
                  ),
                  title: Text(
                    "OptiGest",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                _menuItem(Icons.dashboard, "Inicio"),
                _menuItem(Icons.inventory_2, "Activos"),
                _menuItem(
                  Icons.people,
                  "Personal",
                  active: true,
                ),
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
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  /// HEADER
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Gestión de Personal",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Administra y gestiona el personal",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),

                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add),
                        label: const Text(
                          "Registrar Personal",
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.blue,
                          foregroundColor:
                              Colors.white,
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 25),

                  /// BUSCADOR
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Buscar por ID",
                      prefixIcon:
                          const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// TABLA
                  Expanded(
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.all(16),
                        child: SingleChildScrollView(
                          child: DataTable(
                            headingRowColor:
                                WidgetStateProperty.all(
                              Colors.blue.shade50,
                            ),
                            columns: const [
                              DataColumn(
                                label:
                                    Text("Nombre"),
                              ),
                              DataColumn(
                                label:
                                    Text("Apellido"),
                              ),
                              DataColumn(
                                label:
                                    Text("Estado"),
                              ),
                              DataColumn(
                                label: Text(
                                  "Contratación",
                                ),
                              ),
                              DataColumn(
                                label: Text("ID"),
                              ),
                              DataColumn(
                                label:
                                    Text("Acciones"),
                              ),
                            ],
                            rows: personal.map((p) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      p["nombre"]!,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      p["apellido"]!,
                                    ),
                                  ),

                                  DataCell(
                                    Container(
                                      padding:
                                          const EdgeInsets
                                              .symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration:
                                          BoxDecoration(
                                        color: p[
                                                    "estado"] ==
                                                "Activo"
                                            ? Colors
                                                .green
                                                .shade100
                                            : Colors
                                                .orange
                                                .shade100,
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                                    20),
                                      ),
                                      child: Text(
                                        p["estado"]!,
                                        style:
                                            TextStyle(
                                          color: p["estado"] ==
                                                  "Activo"
                                              ? Colors
                                                  .green
                                              : Colors
                                                  .orange,
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                        ),
                                      ),
                                    ),
                                  ),

                                  DataCell(
                                    Text(
                                      p["fecha"]!,
                                    ),
                                  ),

                                  DataCell(
                                    Text(
                                      p["id"]!,
                                    ),
                                  ),

                                  DataCell(
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed:
                                              () {},
                                          icon:
                                              const Icon(
                                            Icons
                                                .person,
                                            color:
                                                Colors
                                                    .blue,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed:
                                              () {},
                                          icon:
                                              const Icon(
                                            Icons
                                                .delete,
                                            color:
                                                Colors
                                                    .red,
                                          ),
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
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  static Widget _menuItem(
    IconData icon,
    String title, {
    bool active = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: active
            ? Colors.blue
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color:
              active ? Colors.white : Colors.grey,
        ),
        title: Text(
          title,
          style: TextStyle(
            color:
                active ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}