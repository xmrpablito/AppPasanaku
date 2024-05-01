import 'package:flutter/material.dart';
import 'package:pasana/controllers/auth_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blue, // Fondo azul
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: Center(
                child: Image.asset(
                  'assets/img/pasana.png', // Ruta de tu imagen
                  width: 150, // Tamaño de la imagen
                  height: 150,
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Registrate",
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 30, color: Colors.white), // Texto blanco
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Correo Electronico"),
                      hintText: "Ingresa tu Correo Electronico",
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Contraseña"),
                      hintText: "Ingresa tu Contraseña",
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () async {
                        await AuthService.createAccountWithEmail(
                          emailController.text, passwordController.text)
                          .then((value) {
                            if (value == "Cuenta creada con éxito") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Cuenta creada")));
                              Navigator.pushNamedAndRemoveUntil(
                                context, "/home", (route) => false);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                  value,
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red.shade400,
                              ));
                            }
                          });
                      },
                      child: Text("Registrarse"),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Ya tienes una cuenta?", style: TextStyle(color: Colors.white)), // Texto blanco
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Iniciar sesión", style: TextStyle(color: Colors.white)), // Texto blanco
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
