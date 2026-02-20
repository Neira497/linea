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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!ResponsiveWidget.isMobile(context))
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(color: Colors.brown.shade800),
              child: const Text(
                "Panel de Producción",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                const Text(
                  "Detener o iniciar la linea de produccion",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 140,
                      height: 50,
                      child: Material(
                        elevation: 6,
                        color: funcionamientoLinea
                            ? Colors.red.shade800
                            : Colors.green.shade800,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () async {
                            if (funcionamientoLinea) {
                              final razon = await seleccionarRazonDetencion(
                                context,
                              );

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
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 20),

                    if (!funcionamientoLinea && razonDetencion != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Línea detenida por:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade700,
                            ),
                          ),
                          Text(
                            razonDetencion!,
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatearTiempo(tiempoDetenido),
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),

                const SizedBox(height: 20),
                Divider(thickness: 4, color: Colors.black45),
                const SizedBox(height: 20),

                Text(
                  funcionamientoLinea
                      ? "Robots en funcionamiento"
                      : "Robots detenidos",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: funcionamientoLinea
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                  ),
                ),
                SizedBox(height: 20),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: RobotSection(
                        funcionamientoLinea: funcionamientoLinea,
                        title: "NEIRABOT",
                        current: 0,
                        meta: 20,
                        tipo: "Piezas",
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: RobotSection(
                        funcionamientoLinea: funcionamientoLinea,
                        title: "ROBOT 2",
                        current: 10,
                        meta: 10,
                        tipo: "Cajas",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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
