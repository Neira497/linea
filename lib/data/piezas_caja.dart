import 'package:cloud_firestore/cloud_firestore.dart';

class PiezasCajasData {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // STREAM (Dashboard en vivo)
  Stream<Map<String, int>> obtenerCantidadRobotsHoyStream() {
    final ahora = DateTime.now();

    final inicioLocal = DateTime(ahora.year, ahora.month, ahora.day);
    final finLocal = inicioLocal.add(const Duration(days: 1));

    final int inicioUnix = inicioLocal.millisecondsSinceEpoch ~/ 1000;
    final int finUnix = finLocal.millisecondsSinceEpoch ~/ 1000;

    return _firestore
        .collection("piezasCajas")
        .where("fecha", isGreaterThanOrEqualTo: inicioUnix)
        .where("fecha", isLessThan: finUnix)
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

  // CONSULTA POR FECHA (reportes)
  Future<Map<String, int>> obtenerCantidadRobotsPorFecha(DateTime fecha) async {
    final DateTime inicioLocal = DateTime(fecha.year, fecha.month, fecha.day);

    final DateTime finLocal = inicioLocal.add(const Duration(days: 1));

    final int inicioUnix = inicioLocal.millisecondsSinceEpoch ~/ 1000;
    final int finUnix = finLocal.millisecondsSinceEpoch ~/ 1000;

    final query = await _firestore
        .collection("piezasCajas")
        .where("fecha", isGreaterThanOrEqualTo: inicioUnix)
        .where("fecha", isLessThan: finUnix)
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
