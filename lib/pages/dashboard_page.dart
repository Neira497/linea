import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:linea/pages/dashboard_usuarios_page.dart';
import 'package:linea/pages/login_page.dart';
import 'package:linea/pages/perfil_page.dart';
import 'package:linea/pages/reportes_page.dart';
import 'package:linea/data/user_data.dart';
import 'package:linea/model/user_model.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int selectedIndex = 1;

  UserModel? usuario;
  bool cargandoUsuario = true;

  final Color cafeApp = const Color(0xFF5D4037);

  @override
  void initState() {
    super.initState();
    _cargarUsuario();
  }

  Future<void> _cargarUsuario() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      final data = await UserData().getUserById(currentUser.uid);

      if (mounted) {
        setState(() {
          usuario = data;
          cargandoUsuario = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          cargandoUsuario = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    /// Solo desktop real
    final bool isDesktop = width >= 1200;

    return Scaffold(
      appBar: isDesktop
          ? null
          : AppBar(
              backgroundColor: cafeApp,
              iconTheme: const IconThemeData(color: Colors.white),
              leading: Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
            ),
      drawer: isDesktop ? null : _buildDrawer(isDesktop),
      body: Row(
        children: [
          if (isDesktop) SizedBox(width: 250, child: _buildDrawer(isDesktop)),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildDrawer(bool isDesktop) {
    const Color grisTexto = Color(0xFF616161);

    Widget buildItem({
      required int index,
      required IconData icon,
      required String title,
    }) {
      final bool isSelected = selectedIndex == index;

      return InkWell(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });

          // 🔥 SOLO cerrar drawer en móvil
          if (!isDesktop && Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        },
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: isSelected
                ? cafeApp.withValues(alpha: .08)
                : Colors.transparent,
            border: Border(
              left: BorderSide(
                color: isSelected ? cafeApp : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: isSelected ? cafeApp : grisTexto),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? cafeApp : grisTexto,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            /// HEADER
            Container(
              height: 120,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(color: cafeApp),
              child: cargandoUsuario
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: .15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.person, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                usuario?.nombre ?? "",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                usuario?.puesto ?? "",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),

            const Divider(height: 1),
            const SizedBox(height: 10),

            buildItem(
              index: 1,
              icon: Icons.dashboard_outlined,
              title: "Dashboard",
            ),
            buildItem(
              index: 0,
              icon: Icons.bar_chart_outlined,
              title: "Reportes",
            ),
            buildItem(index: 2, icon: Icons.person_outline, title: "Perfil"),

            const SizedBox(height: 30),

            /// BOTÓN CERRAR SESIÓN
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: InkWell(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();

                  if (mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                      (route) => false,
                    );
                  }
                },
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      "Cerrar sesión",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
            const Divider(height: 1),

            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Sistema Línea v1.0",
                style: TextStyle(fontSize: 11, color: Color(0xFF9E9E9E)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (selectedIndex) {
      case 0:
        return const ReportesPage();
      case 1:
        return const DashboardUsuariosPage();
      case 2:
        return const PerfilPage();
      default:
        return const SizedBox();
    }
  }
}
