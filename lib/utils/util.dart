import 'package:flutter/material.dart';

class Mensaje {
  static void mostrarBorrado(BuildContext context, IconData icono, String texto, {int duracion = 3}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          Icon(icono, color: Colors.white),
          Text(' ' + texto),
        ],
      ),
      duration: Duration(seconds: duracion),
    ));
  }




  static void mostrarEdicion(BuildContext context, IconData icono, String texto, {int duracion = 3}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          Icon(icono, color: Colors.white),
          Text(' ' + texto),
        ],
      ),
      duration: Duration(seconds: duracion),
    ));
  }



}