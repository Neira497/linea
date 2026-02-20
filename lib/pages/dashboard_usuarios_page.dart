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
    if (!isDesktop) {
      /// ================= MOBILE MEJORADO =================
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),

          const Text(
            "Detener o iniciar la linea de produccion",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          /// BOTÓN CENTRADO
          SizedBox(
            width: double.infinity,
            child: Center(
              child: SizedBox(
                width: 200,
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
            ),
          ),

          /// CRONÓMETRO ABAJO DEL BOTÓN
          if (!funcionamientoLinea && razonDetencion != null) ...[
            const SizedBox(height: 15),
            Text(
              "Línea detenida por:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: cafePrincipal,
              ),
            ),
            const SizedBox(height: 4),
            Text(razonDetencion!, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 6),
            Text(
              _formatearTiempo(tiempoDetenido),
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ],

          const SizedBox(height: 30),

          Container(
            height: 1,
            width: double.infinity,
            color: cafeClaro.withValues(alpha: .4),
          ),

          const SizedBox(height: 25),

          /// TÍTULO ROBOTS MÁS COMPACTO
          Column(
            children: [
              Text(
                funcionamientoLinea
                    ? "Robots en funcionamiento"
                    : "Robots detenidos",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: funcionamientoLinea ? cafeMedio : cafeOscuro,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: 60,
                height: 3,
                decoration: BoxDecoration(
                  color: funcionamientoLinea ? cafeClaro : cafePrincipal,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          /// ROBOTS MÁS JUNTOS
          RobotSection(
            funcionamientoLinea: funcionamientoLinea,
            title: "NEIRABOT",
            current: 0,
            meta: 20,
            tipo: "Piezas",
          ),

          const SizedBox(height: 25),

          RobotSection(
            funcionamientoLinea: funcionamientoLinea,
            title: "ROBOT 2",
            current: 10,
            meta: 10,
            tipo: "Cajas",
          ),

          const SizedBox(height: 20),
        ],
      );
    }

    /// ================= DESKTOP (LO DEJAMOS IGUAL) =================
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // TU CÓDIGO ACTUAL DE DESKTOP
        const Text(
          "Detener o iniciar la linea de produccion",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        // el resto lo dejas igual como ya lo tienes
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
