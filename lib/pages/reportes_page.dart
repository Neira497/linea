import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:linea/data/paro_data.dart';

class ReportesPage extends StatefulWidget {
  const ReportesPage({super.key});

  @override
  State<ReportesPage> createState() => _ReportesPageState();
}

class _ReportesPageState extends State<ReportesPage> {
  DateTime fechaSeleccionada = DateTime.now();
  final ParoData _paroData = ParoData();
  Future<int>? _futureCantidadParos;
  Future<Map<String, int>>? _futureMotivos;
  Future<List<Map<String, dynamic>>>? _futureDetalleParos;

  /// 🎨 PALETA INDUSTRIAL
  final Color cafeOscuro = const Color(0xFF4E342E);
  final Color cafePrincipal = const Color(0xFF5D4037);
  final Color cafeMedio = const Color(0xFF795548);
  final Color cafeClaro = const Color(0xFFA1887F);
  final Color fondoCafe = const Color(0xFFF5F1EE);

  @override
  void initState() {
    super.initState();
    _consultar(); // 🔥 Consulta automática al entrar
  }

  void _consultar() {
    setState(() {
      _futureCantidadParos = _paroData.obtenerCantidadParosPorDia(
        fechaSeleccionada,
      );

      _futureMotivos = _paroData.obtenerMotivosPorDia(fechaSeleccionada);

      _futureDetalleParos = _paroData.obtenerDetalleParosPorDia(
        fechaSeleccionada,
      );
    });
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fechaSeleccionada,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != fechaSeleccionada) {
      setState(() {
        fechaSeleccionada = picked;
      });
    }
  }

  String _formatearFecha(DateTime fecha) {
    return "${fecha.day.toString().padLeft(2, '0')}/"
        "${fecha.month.toString().padLeft(2, '0')}/"
        "${fecha.year}";
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isDesktop = width >= 1200;
    final bool isTablet = width >= 700 && width < 1200;

    if (isDesktop || isTablet) {
      return Container(
        color: fondoCafe,
        child: Column(
          children: [
            /// HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: cafePrincipal),
              child: const Text(
                "Reportes",
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
                      maxWidth: isDesktop ? 900 : 700,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 60,
                      vertical: 50,
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
                    child: _contenido(),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    /// 📱 MÓVIL
    return SingleChildScrollView(
      child: Container(
        color: fondoCafe,
        padding: const EdgeInsets.all(20),
        child: _contenido(),
      ),
    );
  }

  Widget _contenido() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Seleccione una fecha para consultar",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 30),

        /// CAMPO FECHA
        GestureDetector(
          onTap: () => _seleccionarFecha(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            decoration: BoxDecoration(
              border: Border.all(color: cafeMedio),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatearFecha(fechaSeleccionada),
                  style: const TextStyle(fontSize: 16),
                ),
                Icon(Icons.calendar_today, color: cafeOscuro),
              ],
            ),
          ),
        ),

        const SizedBox(height: 30),

        /// BOTÓN CONSULTAR
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// BOTÓN CONSULTAR
            SizedBox(
              width: 170,
              height: 55,
              child: Material(
                elevation: 6,
                color: cafeOscuro,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: _consultar,
                  child: const Center(
                    child: Text(
                      "CONSULTAR",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 15),

            /// BOTÓN REFRESCAR
            SizedBox(
              width: 55,
              height: 55,
              child: Material(
                elevation: 6,
                color: cafeMedio,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: _consultar,
                  child: const Center(
                    child: Icon(Icons.refresh, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 40),

        LayoutBuilder(
          builder: (context, constraints) {
            final bool esMovil = constraints.maxWidth < 700;

            if (esMovil) {
              /// 📱 MÓVIL → UNA DEBAJO DE OTRA
              return Column(
                children: [
                  FutureBuilder<int>(
                    future: _futureCantidadParos,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _buildResponsiveCard("...");
                      }
                      return _buildResponsiveCard(
                        snapshot.data?.toString() ?? "0",
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: _futureDetalleParos,
                    builder: (context, snapshot) {
                      List<Map<String, dynamic>> datos = snapshot.data ?? [];
                      return _buildDetalleCard(datos);
                    },
                  ),
                ],
              );
            } else {
              /// 💻 DESKTOP/TABLET → LADO A LADO
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: FutureBuilder<int>(
                      future: _futureCantidadParos,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return _buildResponsiveCard("...");
                        }
                        return _buildResponsiveCard(
                          snapshot.data?.toString() ?? "0",
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 20),

                  Expanded(
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: _futureDetalleParos,
                      builder: (context, snapshot) {
                        List<Map<String, dynamic>> datos = snapshot.data ?? [];
                        return _buildDetalleCard(datos);
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),

        FutureBuilder<Map<String, int>>(
          future: _futureMotivos,
          builder: (context, snapshot) {
            Map<String, int> datos = {};

            if (snapshot.hasData) {
              datos = snapshot.data!;
            }

            return _buildGraficaCard(
              datos,
              cargando: snapshot.connectionState == ConnectionState.waiting,
            );
          },
        ),
      ],
    );
  }

  Widget _buildGraficaCard(Map<String, int> datos, {bool cargando = false}) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            color: Colors.black.withValues(alpha: .08),
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "Razones de paro",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),

          SizedBox(
            height: 250,
            child: Stack(
              children: [
                /// 🔹 La gráfica SIEMPRE está renderizada
                LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: 2,
                    minY: 0,

                    gridData: FlGridData(show: true),

                    borderData: FlBorderData(
                      show: true,
                      border: const Border(
                        left: BorderSide(),
                        bottom: BorderSide(),
                      ),
                    ),

                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),

                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            if (value % 1 == 0) {
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(fontSize: 12),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ),

                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            switch (value.toInt()) {
                              case 0:
                                return const Text(
                                  "Electrico",
                                  style: TextStyle(fontSize: 11),
                                );
                              case 1:
                                return const Text(
                                  "Mantenimiento",
                                  style: TextStyle(fontSize: 11),
                                );
                              case 2:
                                return const Text(
                                  "Material",
                                  style: TextStyle(fontSize: 11),
                                );
                              default:
                                return const SizedBox();
                            }
                          },
                        ),
                      ),
                    ),

                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          FlSpot(0, (datos["Electrico"] ?? 0).toDouble()),
                          FlSpot(1, (datos["Mantenimiento"] ?? 0).toDouble()),
                          FlSpot(2, (datos["Material"] ?? 0).toDouble()),
                        ],
                        dotData: FlDotData(show: true),
                        color: cafeOscuro,
                        barWidth: 3,
                      ),
                    ],

                    lineTouchData: LineTouchData(enabled: false),
                  ),
                ),

                /// 🔹 Loader encima (opcional)
                if (cargando)
                  Container(
                    color: Colors.white.withValues(alpha: .6),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetalleCard(List<Map<String, dynamic>> datos) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            color: Colors.black.withValues(alpha: .08),
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Detalle de paros",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 15),

          /// 🔥 ENCABEZADO
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF0ECE9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    "Operador",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "Tiempo",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "Motivo",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "Hora",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          /// 🔥 TABLA
          SizedBox(
            height: 250,
            child: datos.isEmpty
                ? const Center(child: Text("Sin registros"))
                : ListView.separated(
                    itemCount: datos.length,
                    separatorBuilder: (_, __) => const Divider(height: 12),
                    itemBuilder: (context, index) {
                      final item = datos[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                item["nombre"] ?? "",
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                _formatearDuracion(
                                  item["duracionSegundos"] ?? 0,
                                ),
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                item["motivo"] ?? "",
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                item["hora"] ?? "--:--:--",
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _formatearDuracion(int segundos) {
    final int horas = segundos ~/ 3600;
    final int minutos = (segundos % 3600) ~/ 60;
    final int seg = segundos % 60;

    if (horas > 0) {
      return "${horas}h ${minutos}m ${seg}s";
    } else if (minutos > 0) {
      return "${minutos}m ${seg}s";
    } else {
      return "${seg}s";
    }
  }

  Widget _buildResponsiveCard(String valor) {
    final width = MediaQuery.of(context).size.width;
    final bool esMovil = width < 700;

    Widget card = Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            color: Colors.black.withValues(alpha: .08),
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "Veces que se paró la línea",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Text(
            valor,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: cafeOscuro,
            ),
          ),
        ],
      ),
    );

    if (esMovil) {
      return Column(children: [card]);
    } else {
      return Expanded(child: card);
    }
  }
}
