import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class ParoData {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> obtenerDetalleParosPorDia(
    DateTime fecha,
  ) async {
    final DateTime inicioLocal = DateTime(fecha.year, fecha.month, fecha.day);
    final DateTime finLocal = inicioLocal.add(const Duration(days: 1));

    final Timestamp inicioTimestamp = Timestamp.fromDate(inicioLocal.toUtc());
    final Timestamp finTimestamp = Timestamp.fromDate(finLocal.toUtc());

    final query = await _firestore
        .collection("detenciones")
        .where("fechaInicio", isGreaterThanOrEqualTo: inicioTimestamp)
        .where("fechaInicio", isLessThan: finTimestamp)
        .get();

    List<Map<String, dynamic>> detenciones = [];

    Set<String> uids = {};

    for (var doc in query.docs) {
      final data = doc.data();
      final uid = data["uid"];

      if (uid != null) {
        uids.add(uid);
      }

      detenciones.add(data);
    }

    /// 🔥 Traer usuarios
    Map<String, String> mapaUsuarios = {};

    for (String uid in uids) {
      final userDoc = await _firestore.collection("users").doc(uid).get();

      if (userDoc.exists) {
        mapaUsuarios[uid] = userDoc.data()?["nombre"] ?? "Sin nombre";
      }
    }

    /// 🔥 Construir lista final
    List<Map<String, dynamic>> resultado = [];

    for (var data in detenciones) {
      final uid = data["uid"];
      final nombre = mapaUsuarios[uid] ?? "Desconocido";

      final fecha = data["fechaInicio"];

      DateTime fechaConvertida;

      if (fecha is Timestamp) {
        fechaConvertida = fecha.toDate().toLocal();
      } else if (fecha is DateTime) {
        fechaConvertida = fecha.toLocal();
      } else {
        fechaConvertida = DateTime.now();
      }

      int hora = fechaConvertida.hour;
      final minuto = fechaConvertida.minute;
      final segundo = fechaConvertida.second;

      final bool esPM = hora >= 12;

      hora = hora % 12;
      if (hora == 0) hora = 12;

      final periodo = esPM ? "PM" : "AM";

      final horaFormateada =
          "${hora.toString().padLeft(2, '0')}:"
          "${minuto.toString().padLeft(2, '0')}:"
          "${segundo.toString().padLeft(2, '0')} $periodo";

      resultado.add({
        "nombre": nombre,
        "motivo": data["motivo"],
        "duracionSegundos": data["duracionSegundos"] ?? 0,
        "hora": horaFormateada,
      });
    }

    return resultado;
  }

  Future<Map<String, int>> obtenerMotivosPorDia(DateTime fecha) async {
    final DateTime inicioLocal = DateTime(fecha.year, fecha.month, fecha.day);
    final DateTime finLocal = inicioLocal.add(const Duration(days: 1));

    final Timestamp inicioTimestamp = Timestamp.fromDate(inicioLocal.toUtc());
    final Timestamp finTimestamp = Timestamp.fromDate(finLocal.toUtc());

    final query = await _firestore
        .collection("detenciones")
        .where("fechaInicio", isGreaterThanOrEqualTo: inicioTimestamp)
        .where("fechaInicio", isLessThan: finTimestamp)
        .get();

    Map<String, int> conteoMotivos = {
      "Electrico": 0,
      "Mantenimiento": 0,
      "Material": 0,
    };

    for (var doc in query.docs) {
      String motivo = doc["motivo"] ?? "";

      /// 🔥 Normalización
      if (motivo == "Falla eléctrica") {
        conteoMotivos["Electrico"] = conteoMotivos["Electrico"]! + 1;
      } else if (motivo == "Falta de material") {
        conteoMotivos["Material"] = conteoMotivos["Material"]! + 1;
      } else if (motivo == "Mantenimiento") {
        conteoMotivos["Mantenimiento"] = conteoMotivos["Mantenimiento"]! + 1;
      }
    }

    return conteoMotivos;
  }

  Future<int> obtenerCantidadParosPorDia(DateTime fecha) async {
    final DateTime inicioLocal = DateTime(fecha.year, fecha.month, fecha.day);

    final DateTime finLocal = inicioLocal.add(const Duration(days: 1));

    final DateTime inicioUtc = inicioLocal.toUtc();
    final DateTime finUtc = finLocal.toUtc();

    final Timestamp inicioTimestamp = Timestamp.fromDate(inicioUtc);

    final Timestamp finTimestamp = Timestamp.fromDate(finUtc);

    final query = await _firestore
        .collection("detenciones")
        .where("fechaInicio", isGreaterThanOrEqualTo: inicioTimestamp)
        .where("fechaInicio", isLessThan: finTimestamp)
        .get();

    return query.docs.length;
  }

  Future<void> registrarDetencion({
    required String uid,
    required int inicioParo,
    required String motivo,
  }) async {
    final DateTime fechaInicio = DateTime.fromMillisecondsSinceEpoch(
      inicioParo,
    );

    final DateTime fechaFin = DateTime.now();

    final int duracionSegundos = fechaFin.difference(fechaInicio).inSeconds;

    await _firestore.collection("detenciones").add({
      "uid": uid,
      "fechaInicio": fechaInicio,
      "fechaFin": fechaFin,
      "duracionSegundos": duracionSegundos,
      "motivo": motivo,
    });
  }

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
  Future<void> iniciarLinea({
    required String uid,
    required int inicioParo,
    required String motivo,
  }) async {
    /// Primero registrar histórico
    await registrarDetencion(uid: uid, inicioParo: inicioParo, motivo: motivo);

    /// Luego reiniciar estado en realtime
    await _ref.update({
      "funcionamientoLinea": true,
      "inicioParo": null,
      "razonParo": null,
    });
  }
}
