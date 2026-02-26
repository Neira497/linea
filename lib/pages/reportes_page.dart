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

        /// CARD 1
        FutureBuilder<int>(
          future: _futureCantidadParos,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildResponsiveCard("...");
            }

            if (!snapshot.hasData) {
              return _buildResponsiveCard("0");
            }

            return _buildResponsiveCard(snapshot.data!.toString());
          },
        ),
      ],
    );
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
      return Row(
        children: [
          Expanded(child: card),
          const SizedBox(width: 20),
          const Expanded(child: SizedBox()),
        ],
      );
    }
  }
}
