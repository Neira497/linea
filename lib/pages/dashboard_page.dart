import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:linea/pages/dashboard_usuarios_page.dart';
import 'package:linea/pages/perfil_page.dart';
import 'package:linea/pages/reportes_page.dart';
import 'package:linea/widgets/responsive_widget.dart';
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
    bool isDesktop = ResponsiveWidget.isDesktop(context);

    return Scaffold(
      appBar: isDesktop
          ? null
          : AppBar(
              backgroundColor: Colors.brown.shade800,
              iconTheme: const IconThemeData(color: Colors.white),
              leading: Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(
                      Icons.menu,
                      size: 40,
                    ), // hamburguesa más grande
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: cargandoUsuario
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Row(
                          children: [
                            const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 35,
                            ),
                            const SizedBox(width: 8),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  usuario?.nombre ?? "",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  usuario?.puesto ?? "",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                ),
              ],
            ),
      drawer: isDesktop ? null : _buildDrawer(),
      body: Row(
        children: [
          if (isDesktop) SizedBox(width: 250, child: _buildDrawer()),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: isDesktop ? 0 : 0),
              child: Align(
                alignment: isDesktop ? Alignment.topCenter : Alignment.center,
                child: _buildContent(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    const Color cafePrincipal = Color(0xFF5D4037);
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
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: isSelected
                ? cafePrincipal.withValues(alpha: .08)
                : Colors.transparent,
            border: Border(
              left: BorderSide(
                color: isSelected ? cafePrincipal : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? cafePrincipal : grisTexto,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? cafePrincipal : grisTexto,
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
        child: Column(
          children: [
            /// ===== HEADER CAFÉ =====
            Container(
              height: 120,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: const BoxDecoration(color: cafePrincipal),
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
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                usuario?.puesto ?? "",
                                overflow: TextOverflow.ellipsis,
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

            /// ===== MENÚ =====
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
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
                    buildItem(
                      index: 2,
                      icon: Icons.person_outline,
                      title: "Perfil",
                    ),
                  ],
                ),
              ),
            ),

            const Divider(height: 1),

            /// ===== FOOTER =====
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Sistema Línea v1.0",
                style: TextStyle(
                  fontSize: 11,
                  color: grisTexto.withValues(alpha: .6),
                ),
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
        return ReportesPage();
      case 1:
        return DashboardUsuariosPage();
      case 2:
        return PerfilPage();
      default:
        return const SizedBox();
    }
  }
}
