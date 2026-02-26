import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ParoData {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

    debugPrint("Inicio UTC: $inicioUtc");
    debugPrint("Fin UTC: $finUtc");
    debugPrint("Docs encontrados: ${query.docs.length}");

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
