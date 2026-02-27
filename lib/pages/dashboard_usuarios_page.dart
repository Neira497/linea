import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:linea/data/paro_data.dart';
import 'package:linea/widgets/mostrar_mensaje.dart';
import 'package:linea/widgets/robot_section.dart';

class DashboardUsuariosPage extends StatefulWidget {
  const DashboardUsuariosPage({super.key});

  @override
  State<DashboardUsuariosPage> createState() => _DashboardUsuariosPageState();
}

class _DashboardUsuariosPageState extends State<DashboardUsuariosPage> {
  Timer? timer;
  final ParoData _paroData = ParoData();

  /// 🎨 PALETA INDUSTRIAL CAFÉ
  final Color cafeOscuro = const Color(0xFF4E342E);
  final Color cafePrincipal = const Color(0xFF5D4037);
  final Color cafeMedio = const Color(0xFF795548);
  final Color cafeClaro = const Color(0xFFA1887F);
  final Color fondoCafe = const Color(0xFFF5F1EE);

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: _paroData.obtenerEstadoLinea(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final bool funcionamientoLinea =
            snapshot.data!["funcionamientoLinea"] as bool;

        final int? inicioParo = snapshot.data!["inicioParo"] as int?;

        final String? razonParo = snapshot.data!["razonParo"] as String?;

        Duration tiempoDetenido = Duration.zero;

        if (!funcionamientoLinea && inicioParo != null) {
          tiempoDetenido = DateTime.now().difference(
            DateTime.fromMillisecondsSinceEpoch(inicioParo),
          );
        }

        final width = MediaQuery.of(context).size.width;
        final bool isDesktop = width >= 1200;
        final bool isTablet = width >= 700 && width < 1200;

        if (isDesktop || isTablet) {
          return Container(
            color: fondoCafe,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: cafePrincipal),
                  child: const Text(
                    "Panel de Producción",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: isDesktop ? 1200 : 900,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 60,
                          vertical: 50,
                        ),
                        decoration: BoxDecoration(
                          color: funcionamientoLinea
                              ? const Color(0xFFFBF8F6)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 25,
                              color: Colors.black.withValues(alpha: .08),
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: _buildContenido(
                          isDesktop,
                          funcionamientoLinea,
                          tiempoDetenido,
                          razonParo,
                          inicioParo, // ✅ AHORA SE PASA
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          child: Container(
            color: fondoCafe,
            padding: const EdgeInsets.all(20),
            child: _buildContenido(
              false,
              funcionamientoLinea,
              tiempoDetenido,
              razonParo,
              inicioParo, // ✅ AHORA SE PASA
            ),
          ),
        );
      },
    );
  }

  /// ✅ CORREGIDO AQUÍ (inicioParo es int?)
  Widget _buildContenido(
    bool isDesktop,
    bool funcionamientoLinea,
    Duration tiempoDetenido,
    String? razonParo,
    int? inicioParo,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Detener o iniciar la linea de produccion",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 20),

        SizedBox(
          width: 170,
          height: 55,
          child: Material(
            elevation: 6,
            color: funcionamientoLinea ? cafeOscuro : cafeMedio,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () =>
                  _toggleLinea(funcionamientoLinea, inicioParo, razonParo),
              child: Center(
                child: Text(
                  funcionamientoLinea ? "DETENER" : "INICIAR",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),

        if (!funcionamientoLinea) ...[
          const SizedBox(height: 20),
          const Text(
            "Línea detenida por:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            razonParo ?? "Sin especificar",
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 6),
          Text(
            _formatearTiempo(tiempoDetenido),
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ],

        const SizedBox(height: 40),

        Container(
          height: 1,
          width: double.infinity,
          color: cafeClaro.withValues(alpha: .4),
        ),

        const SizedBox(height: 30),

        Column(
          children: [
            Text(
              funcionamientoLinea
                  ? "Robots en funcionamiento"
                  : "Robots detenidos",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: funcionamientoLinea ? cafeMedio : cafeOscuro,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 70,
              height: 4,
              decoration: BoxDecoration(
                color: funcionamientoLinea ? cafeClaro : cafePrincipal,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),

        const SizedBox(height: 40),

        if (isDesktop)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RobotSection(
                funcionamientoLinea: funcionamientoLinea,
                title: "NEIRABOT",
                current: 0,
                meta: 20,
                tipo: "Piezas",
              ),
              const SizedBox(width: 140),
              RobotSection(
                funcionamientoLinea: funcionamientoLinea,
                title: "CABOT",
                current: 10,
                meta: 10,
                tipo: "Cajas",
              ),
            ],
          )
        else
          Column(
            children: [
              RobotSection(
                funcionamientoLinea: funcionamientoLinea,
                title: "NEIRABOT",
                current: 0,
                meta: 20,
                tipo: "Piezas",
              ),
              const SizedBox(height: 40),
              RobotSection(
                funcionamientoLinea: funcionamientoLinea,
                title: "CABOT",
                current: 10,
                meta: 10,
                tipo: "Cajas",
              ),
            ],
          ),
      ],
    );
  }

  void _toggleLinea(
    bool funcionamientoLinea,
    int? inicioParo,
    String? razonParo,
  ) async {
    if (funcionamientoLinea) {
      final razon = await seleccionarRazonDetencion(context);

      if (razon != null) {
        await _paroData.detenerLinea(razon);
      }
    } else {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null && inicioParo != null && razonParo != null) {
        await _paroData.iniciarLinea(
          uid: user.uid,
          inicioParo: inicioParo,
          motivo: razonParo,
        );
      }
    }
  }

  String _formatearTiempo(Duration d) {
    final minutos = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final segundos = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutos:$segundos";
  }
}
