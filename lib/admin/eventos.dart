import 'package:certamen3_dam/admin/detalle.dart';
import 'package:certamen3_dam/admin/formulario.dart';
import 'package:certamen3_dam/public/index_public.dart';
import 'package:certamen3_dam/utils/util.dart';
import 'package:certamen3_dam/widgets/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import '../public/detalle_public.dart';
import '../services/firesotre_service.dart';
import 'package:intl/intl.dart';
import 'package:certamen3_dam/login.dart';


class EventosAdminPage extends StatefulWidget {
  const EventosAdminPage({Key? key});

  @override
  State<EventosAdminPage> createState() => _EventosAdminPageState();
}

class _EventosAdminPageState extends State<EventosAdminPage> {

  String fecha(Timestamp timestamp) {
  DateTime date = timestamp.toDate();
  return DateFormat('dd/MM/yyyy').format(date);
}
final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
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
            // final FirebaseAuth auth = FirebaseAuth.instance;
            // auth.signOut();
            signOut();
            MaterialPageRoute ruta = MaterialPageRoute(builder: (context) => PublicPage());
          
            Navigator.push(context, ruta);

            }, 
            icon: Icon(HeroIcons.arrow_right_on_rectangle, color: Colors.grey.shade600,))
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
      body: Padding(
        padding: EdgeInsets.all(1),
        child: StreamBuilder(
          stream: FirestoreService().eventos(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  var evento = snapshot.data!.docs[index];
                  return InkWell(
                    onTap: () {
                      MaterialPageRoute route = MaterialPageRoute(
                        builder: (context) => DetalleAdminPage(eventoId: evento.id),
                      );
                      Navigator.push(context, route);
                    },
                    child:
                      Slidable(
                        useTextDirection: false,
                        direction: Axis.horizontal,
                        endActionPane: 
                        ActionPane(
                          motion: ScrollMotion(), 
                         children: [
                           SlidableAction(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              icon: HeroIcons.arrow_path,
                              label: 'Cambiar Estado',
                              onPressed: (context){

                                
                                  FirestoreService().editar(evento.id, evento['estado']);
                                   Mensaje.mostrarEdicion(scaffoldKey.currentContext!, HeroIcons.shield_check,
                                     'Evento ${evento['nombre']} se ha editado exitosamente '); 


                                ;
                            
                              },
                            ),
                         ])
                        
                        ,
                        startActionPane: ActionPane(
                          
                          motion: ScrollMotion(), 
                          children: [
                            SlidableAction(
                              backgroundColor: Colors.red.shade900,
                              foregroundColor: Colors.white,
                              icon: HeroIcons.trash,
                              label: 'Borrar',
                              onPressed: (context){
                                
                                setState(() {

                                  FirestoreService().BorrarEvento(evento.id).then((borrado) {

                                    Mensaje.mostrarBorrado(scaffoldKey.currentContext!, HeroIcons.shield_check,
                                     'Evento ${evento['nombre']} se ha borrado exitosamente ');

                                  });
                                  
                                });

                              },
                            ),
                           
                          ]
                        ),
                        child: ListTile(
                      title: Text(evento['nombre'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      subtitle: Text(fecha(evento['fechaHora'])),
                      leading:  Container(
                        padding: EdgeInsets.all(0),
                        margin: EdgeInsets.all(5),
                        width: 150,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image:  NetworkImage(evento['imagen']),
                            fit: BoxFit.cover, // Ajuste para que la imagen llene el contenedor
                          ),
                        ),
                      ),
                      trailing:evento['estado']? Icon(HeroIcons.check_circle,size: 45, color: Colors.green):Icon(Icons.cancel, size: 45, color: Colors.red),
                     
                    ),
                  ));
                },
              );
            }
          },
        ),
        
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          HeroIcons.plus,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Colors.black,
        onPressed: () {
          MaterialPageRoute ruta = MaterialPageRoute(builder: (context) => AgregarPage());
          
          Navigator.push(context, ruta);
        },
      ),
    );
  }
}