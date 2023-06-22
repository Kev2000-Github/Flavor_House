
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommonPopup {
  static void alertUserNotLogged(context){
    showDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: const Text("¡Ups!"),
          content: const Text(
              "No tienes la sesion iniciada"),
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