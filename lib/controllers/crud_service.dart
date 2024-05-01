import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CRUDService {
  static User? user = FirebaseAuth.instance.currentUser;

  //Guardar el token de FOM en Firestore
  static Future saveUserToken(String token) async {
    Map<String, dynamic> data = {
      "email": user!.email,
      "token": token,
    };
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .set(data);
      print("Documento añadido a ${user!.uid}");
    } catch (e) {
      print("Error al guardar en Firestore");
      print(e.toString());
    }
  }
}
