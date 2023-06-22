

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPopup {
  static void alertLoginFailure(context) {
    showDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: const Text("Perdon!"),
          content: const Text(
              "Tu correo electronico o contraseña estan incorrectas, por favor ingrese de nuevo"),
          actions: [
            CupertinoDialogAction(
              child: const Text("ok"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ));
  }
}