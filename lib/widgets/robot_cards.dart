import 'package:flutter/material.dart';
import 'package:linea/widgets/responsive_widget.dart';

class RobotCards extends StatefulWidget {
  const RobotCards({
    super.key,
    required this.funcionamientoLinea,
    required this.title,
  });

  final bool funcionamientoLinea;
  final String title;

  @override
  State<RobotCards> createState() => _RobotCardsState();
}

class _RobotCardsState extends State<RobotCards>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulse = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop =
    ResponsiveWidget.isDesktop(context) ||
    ResponsiveWidget.isTablet(context);

    /// 📱 MÓVIL → EXACTAMENTE COMO LO TENÍAS
    if (!isDesktop) {
      final backgroundColor = widget.funcionamientoLinea
          ? const Color(0xFF1E2A24)
          : const Color(0xFF2A1E1E);

      final borderColor = widget.funcionamientoLinea
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
                widget.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Icon(
                Icons.precision_manufacturing,
                size: 70,
                color: widget.funcionamientoLinea
                    ? Colors.greenAccent
                    : Colors.redAccent,
              ),
            ],
          ),
        ),
      );
    }

    /// 💻 DESKTOP → EFECTO ENCENDIDO/APAGADO SUAVE
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, child) {
        final baseColor = widget.funcionamientoLinea
            ? const Color(0xFF1B5E20)
            : const Color(0xFF7F0000);

        final glowColor = widget.funcionamientoLinea
            ? Colors.greenAccent
            : Colors.redAccent;

        return SizedBox(
          height: 220,
          width: 200,
          child: Container(
            decoration: BoxDecoration(
              color: baseColor.withValues(alpha: _pulse.value),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: glowColor.withValues(alpha: _pulse.value),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: glowColor.withValues(alpha: _pulse.value * 0.6),
                  blurRadius: 25,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Icon(
                  Icons.precision_manufacturing,
                  size: 70,
                  color: glowColor.withValues(alpha: _pulse.value),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
