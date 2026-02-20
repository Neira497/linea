import 'dart:async';
import 'package:flutter/material.dart';
import 'package:linea/widgets/mostrar_mensaje.dart';
import 'package:linea/widgets/responsive_widget.dart';
import 'package:linea/widgets/robot_section.dart';

class DashboardUsuariosPage extends StatefulWidget {
  const DashboardUsuariosPage({super.key});

  @override
  State<DashboardUsuariosPage> createState() => _DashboardUsuariosPageState();
}

class _DashboardUsuariosPageState extends State<DashboardUsuariosPage> {
  bool funcionamientoLinea = false;
  String? razonDetencion;
  Duration tiempoDetenido = Duration.zero;
  Timer? timer;

  /// 🎨 PALETA INDUSTRIAL CAFÉ
  final Color cafeOscuro = const Color(0xFF4E342E);
  final Color cafePrincipal = const Color(0xFF5D4037);
  final Color cafeMedio = const Color(0xFF795548);
  final Color cafeClaro = const Color(0xFFA1887F);
  final Color fondoCafe = const Color(0xFFF5F1EE);

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveWidget.isDesktop(context);

    if (isDesktop) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: double.infinity,
            height: constraints.maxHeight,
            color: fondoCafe,
            child: Column(
              children: [
                /// ===== BARRA SUPERIOR =====
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

                /// ===== CONTENIDO CENTRADO =====
                Expanded(
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 1200),
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
                      child: _buildContenido(context, true),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    /// ===== MOBILE =====
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: _buildContenido(context, false),
      ),
    );
  }

  Widget _buildContenido(BuildContext context, bool isDesktop) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Detener o iniciar la linea de produccion",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),

        /// ===== BOTON =====
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 170,
              height: 55,
              child: Material(
                elevation: 6,
                color: funcionamientoLinea ? cafeOscuro : cafeMedio,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () async {
                    if (funcionamientoLinea) {
                      final razon = await seleccionarRazonDetencion(context);

                      if (razon != null) {
                        setState(() {
                          funcionamientoLinea = false;
                          razonDetencion = razon;
                          tiempoDetenido = Duration.zero;
                        });
                        _iniciarCronometro();
                      }
                    } else {
                      setState(() {
                        funcionamientoLinea = true;
                        razonDetencion = null;
                      });
                      timer?.cancel();
                    }
                  },
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

            const SizedBox(width: 40),

            /// ===== CRONOMETRO PROFESIONAL =====
            if (!funcionamientoLinea && razonDetencion != null)
              isDesktop
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 18,
                      ),
                      decoration: BoxDecoration(
                        color: cafeClaro.withValues(alpha: .15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border(
                          left: BorderSide(color: cafePrincipal, width: 6),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "LÍNEA DETENIDA",
                            style: TextStyle(
                              fontSize: 12,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.bold,
                              color: cafePrincipal,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            razonDetencion!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _formatearTiempo(tiempoDetenido),
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              color: cafeOscuro,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        Text(
                          "Línea detenida por:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: cafePrincipal,
                          ),
                        ),
                        Text(
                          razonDetencion!,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _formatearTiempo(tiempoDetenido),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
          ],
        ),

        const SizedBox(height: 50),

        /// ===== SEPARADOR =====
        Container(
          height: 1,
          width: double.infinity,
          color: cafeClaro.withValues(alpha: .4),
        ),

        const SizedBox(height: 40),

        /// ===== TITULO ROBOTS =====
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

        const SizedBox(height: 50),

        /// ===== ROBOTS =====
        isDesktop
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    title: "ROBOT 2",
                    current: 10,
                    meta: 10,
                    tipo: "Cajas",
                  ),
                ],
              )
            : Column(
                children: [
                  RobotSection(
                    funcionamientoLinea: funcionamientoLinea,
                    title: "NEIRABOT",
                    current: 0,
                    meta: 20,
                    tipo: "Piezas",
                  ),
                  const SizedBox(height: 20),
                  RobotSection(
                    funcionamientoLinea: funcionamientoLinea,
                    title: "ROBOT 2",
                    current: 10,
                    meta: 10,
                    tipo: "Cajas",
                  ),
                ],
              ),
      ],
    );
  }

  void _iniciarCronometro() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        tiempoDetenido += const Duration(seconds: 1);
      });
    });
  }

  String _formatearTiempo(Duration d) {
    final minutos = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final segundos = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutos:$segundos";
  }
}
