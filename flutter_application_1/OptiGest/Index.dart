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
        colorSchemeSeed: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F172A),
              Color(0xFF1E3A8A),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [

                // HEADER
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                        ),
                        onPressed: () {},
                        child: const Text("Comunícate"),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text("Iniciar sesión"),
                      ),
                    ],
                  ),
                ),

                // HERO
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 40,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Optimiza tu PYME con",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "OptiGest",
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Sistema privado de gestión administrativa y control de activos.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(.8),
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),

                // CARACTERÍSTICAS
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(30),
                  color: Colors.white,
                  child: Column(
                    children: [
                      const Text(
                        "Características",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),

                      Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        alignment: WrapAlignment.center,
                        children: [
                          featureCard(
                            Icons.account_tree,
                            "Gestión Centralizada",
                            "Controla todo tu inventario desde un solo lugar.",
                          ),
                          featureCard(
                            Icons.bar_chart,
                            "Informes en Tiempo Real",
                            "Métricas actualizadas para tomar decisiones.",
                          ),
                          featureCard(
                            Icons.shield,
                            "Seguridad de Datos",
                            "Protección avanzada para tu información.",
                          ),
                          featureCard(
                            Icons.auto_awesome,
                            "Interfaz Intuitiva",
                            "Fácil de usar para todo tu equipo.",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // BENEFICIOS
                Container(
                  width: double.infinity,
                  color: const Color(0xFFF8FAFC),
                  padding: const EdgeInsets.all(30),
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 800),
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.08),
                            blurRadius: 15,
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Beneficios",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          BenefitItem(
                            "Ahorro de tiempo en administración.",
                          ),
                          BenefitItem(
                            "Alertas automáticas de bajo stock.",
                          ),
                          BenefitItem(
                            "Acceso desde cualquier dispositivo.",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // TESTIMONIOS
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      const Text(
                        "Lo que dicen nuestros clientes",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),

                      Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        alignment: WrapAlignment.center,
                        children: const [
                          TestimonialCard(
                            texto:
                                "OptiGest cambió cómo manejamos nuestro inventario.",
                            autor: "Carlos Rodríguez",
                          ),
                          TestimonialCard(
                            texto:
                                "Muy fácil de usar, todo mi equipo lo aprendió rápido.",
                            autor: "Elena Martínez",
                          ),
                          TestimonialCard(
                            texto:
                                "Los reportes nos ayudan a comprar mejor.",
                            autor: "Ricardo Soto",
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                // CTA
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 60,
                    horizontal: 20,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF2563EB),
                        Color(0xFF1D4ED8),
                      ],
                    ),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        "¿Listo para transformar tu negocio?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Prueba gratuita durante 14 días.",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),

                // FOOTER
                Container(
                  width: double.infinity,
                  color: Colors.black12,
                  padding: const EdgeInsets.all(20),
                  child: const Center(
                    child: Text(
                      "© 2026 OptiGest PYME",
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget featureCard(
      IconData icon,
      String title,
      String description,
      ) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 15,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.blue,
            size: 45,
          ),
          const SizedBox(height: 15),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class BenefitItem extends StatelessWidget {
  final String text;

  const BenefitItem(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class TestimonialCard extends StatelessWidget {
  final String texto;
  final String autor;

  const TestimonialCard({
    super.key,
    required this.texto,
    required this.autor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 12,
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            '"$texto"',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Text(
            autor,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}