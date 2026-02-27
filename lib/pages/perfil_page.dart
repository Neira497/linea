import 'package:flutter/material.dart';
import 'package:linea/data/user_data.dart';
import 'package:linea/model/user_model.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  /// 🎨 PALETA INDUSTRIAL (igual que las demás páginas)
  final Color cafeOscuro = const Color(0xFF4E342E);
  final Color cafePrincipal = const Color(0xFF5D4037);
  final Color cafeMedio = const Color(0xFF795548);
  final Color cafeClaro = const Color(0xFFA1887F);
  final Color fondoCafe = const Color(0xFFF5F1EE);

  final UserData _userData = UserData();
  Future<UserModel?>? _futureUser;

  @override
  void initState() {
    super.initState();
    _futureUser = _userData.getCurrentUserData();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isDesktop = width >= 1200;
    final bool isTablet = width >= 700 && width < 1200;

    return Container(
      color: fondoCafe,
      child: Column(
        children: [
          /// HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(color: Color(0xFF5D4037)),
            child: const Text(
              "Perfil",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          /// CONTENIDO GRANDE CENTRADO
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  width: isDesktop
                      ? 600
                      : isTablet
                      ? 500
                      : double.infinity,
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 40,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBF8F6),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 25,
                        color: Colors.black.withValues(alpha: .08),
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),

                  /// 🔥 AQUÍ VA EL FUTUREBUILDER
                  child: FutureBuilder<UserModel?>(
                    future: _futureUser,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 40),
                            CircularProgressIndicator(),
                            SizedBox(height: 20),
                            Text("Cargando información..."),
                          ],
                        );
                      }

                      if (!snapshot.hasData || snapshot.data == null) {
                        return const Text("No se pudo cargar la información");
                      }

                      final user = snapshot.data!;

                      String area;
                      switch (user.puesto?.toLowerCase()) {
                        case "operador":
                          area = "Área de Producción";
                          break;
                        case "mantenimiento":
                          area = "Área de Controles";
                          break;
                        case "gerente":
                          area = "Administración en Gerencia";
                          break;
                        default:
                          area = "Área General";
                      }

                      /// 🔥 ESTE ES EXACTAMENTE TU DISEÑO ORIGINAL
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 140,
                            height: 140,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE6E1DE),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 70,
                              color: Color(0xFF5D4037),
                            ),
                          ),

                          const SizedBox(height: 25),

                          Text(
                            user.nombre ?? "...",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            user.puesto ?? "...",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Color(0xFF5D4037),
                            ),
                          ),

                          const SizedBox(height: 25),

                          Divider(color: Colors.brown.withValues(alpha: .3)),

                          const SizedBox(height: 25),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.email, color: Color(0xFF5D4037)),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  user.correo ?? "...",
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 15),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.badge, color: Color(0xFF5D4037)),
                              const SizedBox(width: 10),
                              Text(area, style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
