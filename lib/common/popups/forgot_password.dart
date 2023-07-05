import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPopup {
  static void alertCodeFailure(context) {
    showDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: const Text("Perdon!"),
          content: const Text(
              "El codigo que has introducido es incorrecto, intenta de nuevo"),
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

  static void alertCodeEmptyFailure(context) {
    showDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: const Text("Perdon!"),
          content: const Text("Debes introducir el codigo de confirmacion!"),
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

  static void PasswordEmpty(context) {
    showDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: const Text("Perdon!"),
          content: const Text("Debes introducir la nueva contraseña"),
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
  static void Passwordsucessful(context, VoidCallback onPressed) {
    showDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: const Text("Felicidades"),
          content: const Text("Tu contraseña se ha cambiado sastifactoriamente"),
          actions: [
            CupertinoDialogAction(
              child: const Text("ok"),
              onPressed: onPressed ?? () {
                Navigator.pop(context);
              },
            )
          ],
        ));
  }
}