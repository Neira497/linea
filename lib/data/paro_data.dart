import 'package:firebase_database/firebase_database.dart';

class ParoData {
  // Instancia de Realtime Database
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  /// 🔴 Stream en tiempo real de funcionamientoLinea
  Stream<bool> obtenerFuncionamientoLinea() {
    return _database.child('funcionamientoLinea').onValue.map((event) {
      final data = event.snapshot.value;

      if (data == null) {
        return false;
      }

      return data as bool;
    });
  }
}
