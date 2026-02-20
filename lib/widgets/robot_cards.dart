import 'package:flutter/material.dart';

class RobotCards extends StatelessWidget {
  const RobotCards({
    super.key,
    required this.funcionamientoLinea,
    required this.title,
  });

  final bool funcionamientoLinea;
  final String title;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = funcionamientoLinea
        ? const Color(0xFF1E2A24)
        : const Color(0xFF2A1E1E);

    final borderColor = funcionamientoLinea
        ? Colors.greenAccent
        : Colors.redAccent;

    return SizedBox(
      height: 220,
      width: 200,
      child: AnimatedContainer(
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            /// 🔥 Icono ahora SI se anima suave
            TweenAnimationBuilder<Color?>(
              tween: ColorTween(
                begin: funcionamientoLinea
                    ? Colors.redAccent
                    : Colors.greenAccent,
                end: funcionamientoLinea
                    ? Colors.greenAccent
                    : Colors.redAccent,
              ),
              duration: const Duration(seconds: 1),
              builder: (context, color, child) {
                return Icon(
                  Icons.precision_manufacturing,
                  size: 70,
                  color: color,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
