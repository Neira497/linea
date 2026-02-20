import 'package:flutter/material.dart';

class PiezaMetaCard extends StatelessWidget {
  final int current;
  final int meta;
  final String tipo; // 👈 nuevo argumento

  const PiezaMetaCard({
    super.key,
    required this.current,
    required this.meta,
    required this.tipo,
  });

  Color _getColor() {
    if (meta == 0) return Colors.grey;

    double porcentaje = current / meta;

    if (porcentaje >= 1) {
      return Colors.green;
    }

    return Color.lerp(Colors.orange, Colors.green, porcentaje)!;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();

    return SizedBox(
      width: 200,
      height: 220,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// 🔹 TÍTULO DINÁMICO
            Text(
              "$tipo / Meta",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),

            const SizedBox(height: 12),

            /// 🔹 CÍRCULO
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: .15),
                border: Border.all(color: color, width: 4),
              ),
              child: Center(
                child: Text(
                  "$current / $meta",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: color,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
