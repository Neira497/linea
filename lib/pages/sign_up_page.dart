import 'package:flutter/material.dart';
import 'package:linea/data/user_data.dart';
import 'package:linea/widgets/drop_down_field.dart';
import 'package:linea/widgets/input_field.dart';

class SignUpPage extends StatefulWidget {
  final Function changeToSignIn;

  const SignUpPage({super.key, required this.changeToSignIn});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController correo = TextEditingController();
  final TextEditingController contrasena = TextEditingController();
  final TextEditingController confirmarContrasena = TextEditingController();
  final UserData userData = UserData(); // Usuario
  bool procesando = false;

  // Puestos
  final List<String> puestosList = ['Operador', 'Mantenimiento', 'Gerente'];

  String? puestoSeleccionado;

  TextEditingController puestos = TextEditingController();

  String? _handlePuestos(String value) {
    if (value.isEmpty) {
      return "Selecciona el puesto";
    }

    if (!["Operador", "Mantenimiento", "Gerente"].contains(value)) {
      return "Selecciona un puesto válido";
    }

    return null;
  }

  // Metodo para registrar a un usuario
  // void _signUp() async {
  //   setState(() {
  //     procesando = true;
  //   });
  //   if (formKey.currentState!.validate()) {
  //     final userModel = UserModel(
  //       email: correo.text.trim(),
  //       password: contrasena.text.trim(),
  //     );

  //     try {
  //       await userData.registerUser(userModel);

  //       // Vaciar los inputs
  //       _vaciarInputs();
  //       setState(() {
  //         procesando = false;
  //       });
  //       if (mounted) {
  //         mostrarMensajeCorrecto(
  //             context,
  //             "¡Registrado!",
  //             "Cuenta registrada con exito",
  //             widget.changeToSignIn,
  //             widget.changeToSignIn);
  //       }
  //     } catch (e) {
  //       setState(() {
  //         procesando = false;
  //       });
  //       if (e is FirebaseAuthException) {
  //         if (e.code == 'email-already-in-use') {
  //           // Error específico de correo ya en uso
  //           if (mounted) {
  //             mostrarMensajeError(context, "Error", "El correo ya esta en uso");
  //           }
  //         } else {
  //           // Otro tipo de error
  //           if (mounted) {
  //             mostrarMensajeError(context, "Error", "Error al registrarse");
  //           }
  //         }
  //       } else {
  //         // Si el error no es un FirebaseAuthException
  //         if (mounted) {
  //           mostrarMensajeError(context, "Error", "Error al registrarse");
  //         }
  //       }
  //     } finally {
  //       setState(() {
  //         procesando = false;
  //       });
  //     }
  //   } else {
  //     setState(() {
  //       procesando = false;
  //     });
  //   }
  // }

  void _vaciarInputs() {
    correo.clear();
    contrasena.clear();
    confirmarContrasena.clear();
  }

  // Metodo para verificar el correo
  String? _handleCorreo(String value) {
    // El correo esta vacio
    if (value.isEmpty) {
      return "Ingrese el correo electrónico";
    }

    // Expresión regular para validar el formato de un correo electrónico
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );
    if (!emailRegex.hasMatch(value)) {
      return "Ingrese un correo electrónico válido";
    }

    return null; // El correo es válido
  }

  // Metodo para verificar la primer contraseña
  String? _handlePassword(String value) {
    // La contraseña esta vacio
    if (value.isEmpty) {
      return "Ingrese una contraseña valida";
    }

    return null; // La contraseña es válido
  }

  // Metodo para verificar la confirmacion de la contraseña
  String? _handleConfirmPassword(String value) {
    // La segunda contraseña no coinciden
    if (value != contrasena.text.trim()) {
      return "Las contraseñas no coinciden";
    }

    // La segunda contraseña esta vacia
    if (value.isEmpty) {
      return "Ingrese una contraseña valida";
    }

    return null; // La contraseña es válido
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          // Correo electronico
          InputField(
            controller: correo,
            validator: (value) => _handleCorreo(value!),
            label: "Correo electronico",
            keyboardType: TextInputType.emailAddress,
            obscureText: false,
          ),
          SizedBox(height: 20),

          // Contraseña
          InputField(
            controller: contrasena,
            label: "Contraseña",
            obscureText: true,
            validator: (value) => _handlePassword(value!),
          ),
          SizedBox(height: 20),

          // Confirmar contraseña
          InputField(
            controller: confirmarContrasena,
            label: "Confirmar contraseña",
            obscureText: true,
            validator: (value) => _handleConfirmPassword(value!),
          ),
          SizedBox(height: 20),

          DropdownField(
            label: "Puesto",
            value: puestoSeleccionado,
            items: const ['Operador', 'Mantenimiento', 'Gerente'],
            onChanged: (value) {
              setState(() {
                puestoSeleccionado = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Selecciona el puesto";
              }
              return null;
            },
          ),

          SizedBox(height: 20),

          // Boton
          ElevatedButton(
            // onPressed: _signUp,
            onPressed: null,
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.brown[100]),
            ),
            child: procesando
                ? SizedBox(
                    width: 70,
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
                    "Crear cuenta",
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
