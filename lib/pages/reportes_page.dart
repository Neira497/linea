import 'package:flutter/material.dart';

class ReportesPage extends StatefulWidget {
  const ReportesPage({super.key});

  @override
  State<ReportesPage> createState() => _ReportesPageState();
}

class _ReportesPageState extends State<ReportesPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Titulo
        const Text(
          "Detener o iniciar la linea de produccion",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),

        // Formulario de fecha

        // Cuantas veces se paro la linea

        // Porque se paro la linea y cuanto tiempo duro parada por ocacioin

        // Lista de quienes pararon la linea ese dia

        // Cantidad de piezas y cajas que hicieron por hora de ese mismo dia de 8 a 8
      ],
    );
  }
}
