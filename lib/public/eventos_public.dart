import 'package:certamen3_dam/login.dart';
import 'package:certamen3_dam/public/detalle_public.dart';
import 'package:certamen3_dam/widgets/evento_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../services/firesotre_service.dart';


class EventosPublicPage extends StatefulWidget {
  const EventosPublicPage({super.key});

  @override
  State<EventosPublicPage> createState() => _EventosPublicPageState();
}

class _EventosPublicPageState extends State<EventosPublicPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(
          'Agéndamelo', 
          style: GoogleFonts.comfortaa(
            textStyle: TextStyle(color: Colors.grey.shade300, fontWeight:FontWeight.bold, fontSize: 35)
          ) ,),
        leading: Icon(HeroIcons.musical_note, color: Colors.white,),
        actions: [
          IconButton(
            onPressed: (){
              MaterialPageRoute ruta = MaterialPageRoute(builder: (context) => LoginPage());
          
            Navigator.push(context, ruta);
            }, 
            icon: Icon(MdiIcons.google, color: Colors.white38,))
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              opacity: 0.5,
              image: NetworkImage('https://imagenes.20minutos.es/files/image_1920_1080/uploads/imagenes/2023/09/04/fiestas-de-pueblo.jpeg'),
              fit: BoxFit.cover
            )
          ),
        ),
      ),

    body: Padding(padding: EdgeInsets.all(1),
    child: Column(
      children: [
        Expanded(child: 

          StreamBuilder(
            stream: FirestoreService().eventos(), 
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {

                return Center( child: CircularProgressIndicator(),);

              } else {

                return GridView.builder(
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), 
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index){
                    var evento = snapshot.data!.docs[index];
                    return InkWell(
                      onTap: () {
                        MaterialPageRoute route = MaterialPageRoute(builder: (context) => DetallePublicPage(eventoId: evento.id));
                        Navigator.push(context, route);
                        print(evento['nombre'],);
                      },
                      child: EventoTile(
                        estado: evento['estado'],
                        fechaHora: evento['fechaHora'],
                          nombre: evento['nombre'],
                          lugar: evento['lugar'],
                          imagen: evento['imagen'],
                          
                      ),
                    );
                  
                  
                
                  });
                
              }

            })

        )

      ],
    ),),
    );
  }
}