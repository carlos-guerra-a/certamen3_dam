import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class EventoTile extends StatefulWidget {
  final String nombre;
  final String lugar;
  final String descripcion;
  final String imagen;
  final Timestamp fechaHora;
  final bool estado;

  EventoTile({
    this.nombre = '',
    this.lugar = '',
    this.descripcion = '',
    this.imagen = '',
    required this.estado,
    required this.fechaHora,
  });

  @override
  State<EventoTile> createState() => _EventoTileState();
}

class _EventoTileState extends State<EventoTile> {
  bool estaEnTresDias = false;

  @override
  void initState() {
    super.initState();
    calcularFechaProxima();
  }

  void calcularFechaProxima() {
    DateTime ahora = DateTime.now();
    DateTime fechaLimite = ahora.add(Duration(days: 3));
    Timestamp timeStampFechaLimite = Timestamp.fromDate(fechaLimite);

    if (widget.fechaHora.seconds <= timeStampFechaLimite.seconds) {
      setState(() {
        estaEnTresDias = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
    //  color: estaEnTresDias ? Colors.red : Colors.transparent, 
      height: 300, // Ajusta esta altura según lo que desees para cada elemento del grid
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          
          // Foto
          Stack(
            children: [
              
              Container(
              height: 140, // Altura de la imagen
              child: Container(
                padding: EdgeInsets.all(0),
                margin: EdgeInsets.all(5),
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image:  NetworkImage(this.widget.imagen),
                    fit: BoxFit.cover, // Ajuste para que la imagen llene el contenedor
                  ),
                ),
              ),
            ),

          if (estaEnTresDias && this.widget.estado)
            Container(
              padding: EdgeInsets.all(5),
            
              child: Row(
                
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                Container(
                padding: EdgeInsets.all(0),
                width: 194,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black, Colors.transparent],
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.timer,
                      color: Colors.white,
                      size: 18,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'En pocos días',
                      style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
            ),

              
                  ],),
            )
            
            
            
            
            
            ],
          ),

          // Nombre
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  this.widget.nombre,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),

          // Descripción
          Container(
            margin: EdgeInsets.only(left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.location_on),
                Container(
                  child: Text(
                    this.widget.lugar,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
            
              ],
            ),
          ),

        ],
      ),
    );
  }
}