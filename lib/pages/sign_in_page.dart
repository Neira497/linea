import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:linea/data/user_data.dart';
import 'package:linea/model/user_model.dart';
import 'package:linea/pages/dashboard_page.dart';
import 'package:linea/widgets/input_field.dart';
import 'package:linea/widgets/mostrar_mensaje.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _correo = TextEditingController();
  final TextEditingController _contrasena = TextEditingController();
  final UserData userData = UserData(); // Usuario
  bool procesando = false;

  void _vaciarInputs() {
    _correo.clear();
    _contrasena.clear();
  }

  // Manejador para verificar el correo
  String? _handleCorreo(String value) {
    // Verificamos que el correo no este vacio
    if (value.isEmpty) {
      return "Ingrese un correo electronico";
    }

    // Expresión regular para validar el formato de un correo electrónico
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );
    if (!emailRegex.hasMatch(value)) {
      return "Ingrese un correo electrónico válido";
    }

    return null;
  }

  // Metodo para verificar la primer contraseña
  String? _handlePassword(String value) {
    // La contraseña esta vacio
    if (value.isEmpty) {
      return "Ingrese una contraseña valida";
    }

    return null; // La contraseña es válido
  }

  // Metodo para iniciar sesion
  void _logIn() async {
    setState(() {
      procesando = true;
    });
    if (_formKey.currentState!.validate()) {
      final userModel = UserModel(
        correo: _correo.text.trim(),
        contrasena: _contrasena.text.trim(),
      );

      try {
        await userData.loginUser(userModel);

        if (mounted) {
          // Vaciar los inputs
          _vaciarInputs();
          setState(() {
            procesando = false;
          });

          // Navegar a otra pantalla
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DashboardPage()),
          );
        }
      } catch (e) {
        setState(() {
          procesando = false;
        });
        if (e is FirebaseAuthException) {
          if (e.code == 'user-not-found') {
            // Error si el usuario no fue encontrado
            if (mounted) {
              mostrarMensajeError(
                context,
                "Error",
                "El usuario no fue enconntrado",
              );
            }
          } else {
            // Otro tipo de error
            if (mounted) {
              mostrarMensajeError(context, "Error", "Error al iniciar sesion");
            }
          }
        }
      } finally {
        setState(() {
          procesando = false;
        });
      }
    } else {
      setState(() {
        procesando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Correo electronico
          InputField(
            controller: _correo,
            label: "Correo electronico",
            validator: (value) => _handleCorreo(value!),
            keyboardType: TextInputType.emailAddress,
            obscureText: false,
          ),
          SizedBox(height: 20),
          // Contraseña
          InputField(
            controller: _contrasena,
            label: "Contraseña",
            validator: (value) => _handlePassword(value!),
            obscureText: true,
          ),
          SizedBox(height: 20),
          // Boton
          ElevatedButton(
            onPressed: !procesando ? _logIn : null,
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.brown[100]),
            ),
            child: procesando
                ? SizedBox(
                    width: 60,
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.brown,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  )
                : Text(
                    "Ingresar",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.brown,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
