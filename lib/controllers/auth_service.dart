import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //CREACION DE NUEVA CUENTA
  static Future<String> createAccountWithEmail(
      String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return "Cuenta creada con éxito";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  //Inicio de Sesion con correo electronico y contraseña
  static Future<String> loginWithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return "Inicio de sesión exitoso";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  //Cerrar sesion del usuario
  static Future logout() async {
    await FirebaseAuth.instance.signOut();
  }

  //Obtener el estado de la sesion del usuario
  static Future<bool> isLoggedIn() async {
    var user = FirebaseAuth.instance.currentUser;
    return user != null;
  }
}
