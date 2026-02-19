import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  final String mobile;
  final String? tablet;
  final String desktop;

  const ResponsiveWidget({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width <= 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 840;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 840;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
