import 'package:flutter/material.dart';
import 'package:linea/pages/sign_in_page.dart';
import 'package:linea/pages/sign_up_page.dart';
import 'package:linea/widgets/responsive_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showSignIn = true;
  String urlFondo = "assets/fondoLoginTelefono.jpg";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (ResponsiveWidget.isMobile(context)) {
      urlFondo = "assets/fondoLoginTelefono.jpg";
    } else {
      urlFondo = "assets/fondoLogin.jpg";
    }
  }

  void handleChangeToRegistro() {
    setState(() {
      showSignIn = true;
    });
  }

  void handleChangeToInicio() {
    setState(() {
      showSignIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Imagen de fondo
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(urlFondo, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.2)),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          // Titulo
                          children: [
                            // Botones
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 20,
                              ),
                              width:
                                  (ResponsiveWidget.isTablet(context) ||
                                      ResponsiveWidget.isDesktop(context))
                                  ? 400
                                  : null,
                              child: Column(
                                children: [
                                  Text(
                                    "Operaciones",
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.brown,
                                    ),
                                  ),
                                  Divider(thickness: 5, color: Colors.brown),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      // Botón "Iniciar sesión"
                                      GestureDetector(
                                        onTap: handleChangeToRegistro,
                                        child: Container(
                                          padding: EdgeInsets.only(
                                            bottom: 6,
                                            left: 15,
                                            right: 15,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: showSignIn
                                                    ? Colors.brown
                                                    : Colors.white,
                                                width: 3.0,
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            "Iniciar sesión",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: showSignIn
                                                  ? Colors.black
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 20),

                                      // Botón "Registrarse"
                                      GestureDetector(
                                        onTap: handleChangeToInicio,
                                        child: Container(
                                          padding: EdgeInsets.only(
                                            bottom: 6,
                                            left: 15,
                                            right: 15,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: showSignIn
                                                    ? Colors.white
                                                    : Colors.brown,
                                                width: 3.0,
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            "Registrarse",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: showSignIn
                                                  ? Colors.grey
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),

                                  // Formularios
                                  AnimatedSwitcher(
                                    duration: Duration(milliseconds: 400),
                                    child: showSignIn
                                        ? SignInPage()
                                        : SignUpPage(
                                            changeToSignIn:
                                                handleChangeToRegistro,
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
