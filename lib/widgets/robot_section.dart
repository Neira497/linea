import 'package:flutter/material.dart';
import 'package:linea/widgets/pieza_meta_card.dart';
import 'package:linea/widgets/robot_cards.dart';

class RobotSection extends StatelessWidget {
  const RobotSection({
    super.key,
    required this.funcionamientoLinea,
    required this.title,
    required this.current,
    required this.meta,
    required this.tipo,
  });

  final bool funcionamientoLinea;
  final String title;
  final int current;
  final int meta;
  final String tipo;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RobotCards(funcionamientoLinea: funcionamientoLinea, title: title),
        const SizedBox(height: 12),
        PiezaMetaCard(current: current, meta: meta, tipo: tipo),
      ],
    );
  }
}
