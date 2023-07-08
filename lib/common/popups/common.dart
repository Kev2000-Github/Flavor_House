
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
                Navigator.of(context)
                    .popUntil((route) => route.isFirst);
              },
            )
          ],
        ));
  }

  static void deletePost(context,
      {VoidCallback? onCancel, VoidCallback? onConfirm}){
    showDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: const Text("Confirmar Eliminacion"),
          content: const Text(
              "¿Desea eliminar esta publicacion?"),
          actions: [
            CupertinoDialogAction(
              onPressed: onCancel ?? () {
                Navigator.of(context).pop();
              },
              child: const Text("cancelar"),
            ),
            CupertinoDialogAction(
              onPressed: onConfirm ?? () {
                Navigator.of(context).pop();
              },
              child: const Text("confirmar"),
            )
          ],
        ));
  }
}