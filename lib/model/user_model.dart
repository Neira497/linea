class UserModel {
  String? nombre;
  String? correo;
  String? contrasena;
  String? puesto;

  UserModel({
    this.nombre,
    required this.correo,
    required this.contrasena,
    this.puesto,
  });
}
