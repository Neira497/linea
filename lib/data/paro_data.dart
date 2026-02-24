import 'package:firebase_database/firebase_database.dart';

class ParoData {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref();

  /// 🔴 Stream global del estado de la línea
  Stream<Map<String, dynamic>> obtenerEstadoLinea() {
    return _ref.onValue.map((event) {
      final data = event.snapshot.value as Map?;

      return {
        "funcionamientoLinea": data?["funcionamientoLinea"] ?? true,
        "inicioParo": data?["inicioParo"],
        "razonParo": data?["razonParo"],
      };
    });
  }

  /// 🟥 Detener línea (ahora guarda razón)
  Future<void> detenerLinea(String razon) async {
    await _ref.update({
      "funcionamientoLinea": false,
      "inicioParo": ServerValue.timestamp,
      "razonParo": razon,
    });
  }

  /// 🟢 Iniciar línea
  Future<void> iniciarLinea() async {
    await _ref.update({
      "funcionamientoLinea": true,
      "inicioParo": null,
      "razonParo": null,
    });
  }
}
