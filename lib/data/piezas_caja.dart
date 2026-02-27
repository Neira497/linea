import 'package:cloud_firestore/cloud_firestore.dart';

class PiezasCajasData {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<Map<String, int>> obtenerCantidadRobotsHoyStream() {
    final DateTime ahora = DateTime.now();

    final DateTime inicioLocal = DateTime(ahora.year, ahora.month, ahora.day);

    final DateTime finLocal = inicioLocal.add(const Duration(days: 1));

    final Timestamp inicioTimestamp = Timestamp.fromDate(inicioLocal.toUtc());

    final Timestamp finTimestamp = Timestamp.fromDate(finLocal.toUtc());

    return _firestore
        .collection("piezasCajas")
        .where("fecha", isGreaterThanOrEqualTo: inicioTimestamp)
        .where("fecha", isLessThan: finTimestamp)
        .snapshots()
        .map((snapshot) {
          int neirabot = 0;
          int cabot = 0;

          for (var doc in snapshot.docs) {
            final robot = doc["robot"] ?? "";

            if (robot == "neirabot") {
              neirabot++;
            } else if (robot == "cabot") {
              cabot++;
            }
          }

          return {"neirabot": neirabot, "cabot": cabot};
        });
  }

  Future<Map<String, int>> obtenerCantidadRobotsPorFecha(DateTime fecha) async {
    /// 📅 Inicio del día local
    final DateTime inicioLocal = DateTime(fecha.year, fecha.month, fecha.day);

    /// 📅 Fin del día local
    final DateTime finLocal = inicioLocal.add(const Duration(days: 1));

    /// 🔄 Convertir a UTC
    final Timestamp inicioTimestamp = Timestamp.fromDate(inicioLocal.toUtc());

    final Timestamp finTimestamp = Timestamp.fromDate(finLocal.toUtc());

    /// 🔥 Query por rango de fecha
    final query = await _firestore
        .collection("piezasCajas")
        .where("fecha", isGreaterThanOrEqualTo: inicioTimestamp)
        .where("fecha", isLessThan: finTimestamp)
        .get();

    int neirabot = 0;
    int cabot = 0;

    for (var doc in query.docs) {
      final robot = doc["robot"] ?? "";

      if (robot == "neirabot") {
        neirabot++;
      } else if (robot == "cabot") {
        cabot++;
      }
    }

    return {"neirabot": neirabot, "cabot": cabot};
  }
}
