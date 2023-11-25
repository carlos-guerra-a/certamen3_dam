import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

import '../services/firesotre_service.dart';


class DetalleAdminPage extends StatefulWidget {
  const DetalleAdminPage({super.key, required this.eventoId});

  final String eventoId;

  @override
  State<DetalleAdminPage> createState() => _DetalleAdminPageState();
}

class _DetalleAdminPageState extends State<DetalleAdminPage> {
  String fecha(Timestamp timestamp) {
  DateTime date = timestamp.toDate();
  return DateFormat('dd/MM/yyyy').format(date);
}

String hora(Timestamp timestamp) {
  DateTime date = timestamp.toDate();
  return DateFormat('HH:mm').format(date);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(HeroIcons.arrow_left, color: Colors.white),
        ),
      ),
      body: Container(
        
        child: FutureBuilder<DocumentSnapshot>(
          future: FirestoreService().MostrarEvento(widget.eventoId),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              var evento = snapshot.data!.data() as Map<String, dynamic>;
              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      alignment: Alignment.bottomLeft,
                children: [
                  // Imagen que ocupa todo el ancho
                  Image(
                    image: NetworkImage(evento['imagen']),
                    fit: BoxFit.cover,
                    height: 500, 
                    width: 500,// Altura deseada para la imagen
                  ),
                  
                  Container(
                    
                    height: 300,
                    alignment: Alignment.bottomRight,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black54.withOpacity(0.9)],
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:  Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                          Container(
                            height: 100,
                            padding: EdgeInsets.all(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  
                                  evento['nombre'],
                                  style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                      fontSize: 35, 
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text('${evento['descripcion']}',style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      fontSize: 18, 
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ), softWrap: true,)
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            child: Row(
                                  children: [
                                    Icon( 
                                      HeroIcons.fire,
                                      color: Colors.red,
                                      size: 40,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      evento['meGusta'].toString(),
                                      style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
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
                  )
                    ,
                    
                    
                   
                  SizedBox(height: 5), // Espacio entre el nombre del evento y otros datos
              
                    // Otros datos del evento debajo del nombre
                  Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(child: Icon(HeroIcons.map_pin, size: 35, color: Color(0xffE5A65E),)),
                                    
                                    Text('   ${evento['lugar']}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),)
                                  ],
                                ),
                                Divider(),
                                Row(
                                  children: [
                                    Container(child: Icon(HeroIcons.sparkles, size: 35, color: Color(0xffE5A65E),)),
                                    Text('   ${evento['tipo']}',style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500), softWrap: true),
                                  ],
                                ),
                                Divider(),
                                Row(
                                  children: [
                                    Container(child: Icon(HeroIcons.calendar, size: 35, color: Color(0xffE5A65E),)),
                                    Text('   '+fecha(evento['fechaHora']),style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500), softWrap: true),
                                  ],
                                ),
                                Divider(),
                                Row(
                                  children: [
                                    Container(child: Icon(Icons.schedule_outlined, size: 35, color: Color(0xffE5A65E),)),
                                    Text('   '+hora(evento['fechaHora']),style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500), softWrap: true),
                                  ],
                                ),
                                Divider(),
                              ],
                            ),
                            
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}