import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:linea/model/user_model.dart';

class UserData {
  // Instancia de firebaseAuth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Instancia de Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Registrar un usuario
  Future<void> registerUser(UserModel user) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: user.correo!,
            password: user.contrasena!,
          );

      // Guardar los datos adicionales en Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'email': user.correo,
        'contrasena': user.contrasena ?? "",
        'nombre': user.nombre,
        'puesto': user.puesto,
      });
    } on FirebaseAuthException {
      rethrow;
    }
  }

  // Iniciar sesion a un usuario
  Future<void> loginUser(UserModel user) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: user.correo!,
        password: user.contrasena!,
      );
    } on FirebaseAuthException {
      rethrow;
    }
  }
}
