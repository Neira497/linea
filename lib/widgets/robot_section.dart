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
    final width = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;

    final bool isDesktop = width >= 1200;
    final bool isLandscape = orientation == Orientation.landscape;

    /// 💻 DESKTOP
    if (isDesktop) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          RobotCards(funcionamientoLinea: funcionamientoLinea, title: title),
          const SizedBox(width: 20),
          PiezaMetaCard(current: current, meta: meta, tipo: tipo),
        ],
      );
    }

    /// 📱 MÓVIL LANDSCAPE
    if (isLandscape) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          RobotCards(funcionamientoLinea: funcionamientoLinea, title: title),
          const SizedBox(width: 20),
          PiezaMetaCard(current: current, meta: meta, tipo: tipo),
        ],
      );
    }

    /// 📱 MÓVIL NORMAL (VERTICAL)
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RobotCards(funcionamientoLinea: funcionamientoLinea, title: title),
        const SizedBox(height: 20),
        PiezaMetaCard(current: current, meta: meta, tipo: tipo),
      ],
    );
  }
}
