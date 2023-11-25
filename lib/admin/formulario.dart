import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';


import '../services/firesotre_service.dart';

class AgregarPage extends StatefulWidget {
  const AgregarPage({super.key});

  @override
  State<AgregarPage> createState() => _AgregarPageState();
}

class _AgregarPageState extends State<AgregarPage> {
  final formKey = GlobalKey<FormState>();
  DateTime fechaEvento = DateTime.now(); // Variable para almacenar fecha y hora
  final formatoFecha = DateFormat('dd-MM-yyyy');
  final formatoHora = DateFormat('HH:mm');
  String tipo = '';
  File? imagen_subir;


  TextEditingController nombreCtrl = TextEditingController();
  TextEditingController descripcionCtrl = TextEditingController();
  TextEditingController lugarCtrl = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar:AppBar(
        backgroundColor: Colors.black87,
        title: Text(
          'Agéndamelo', 
          style: GoogleFonts.comfortaa(
            textStyle: TextStyle(color: Colors.grey.shade300, fontWeight:FontWeight.bold, fontSize: 35)
          ) ,),
        leading: Icon(HeroIcons.musical_note, color: Colors.white,),
        
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
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [

            imagen_subir != null ? Container(height:200, child: Image.file(imagen_subir!,)) : Container(
              margin: EdgeInsets.all(10),
              height: 200,
              width: double.infinity,
              color: Colors.transparent,

            )
            ,
            SizedBox(
              height: 20,
            ),

            ElevatedButton(onPressed:() async {

              final imagen = await FirestoreService().galeria();

              setState(() {
                imagen_subir = File(imagen!.path);
              });


            }, child: Text('Seleccione imagen')),

            
            SizedBox(
              height: 20,
            ),
            //nombre evento
            TextFormField(
              
              controller: nombreCtrl,
              decoration: InputDecoration(
                
                border: OutlineInputBorder(),
                label: Text('Nombre'),
              ),
              validator: (nombre){
                if (nombre!.isEmpty){
                  return 'Es necesario ingresar el nombre';
                }
                return null;
              },
            ),
            SizedBox(
              height: 20,
            ),
            //descripción evento
            TextFormField(
              controller: descripcionCtrl,
              decoration: InputDecoration(
                
                border: OutlineInputBorder(),
                label: Text('Descripción'),
              ),
              validator: (descripcion){
                if (descripcion!.isEmpty){
                  return 'Es necesario ingresar una descripción del evento';
                }
                return null;
              },
            ),
            SizedBox(
              height: 20,
            ),
            //lugar
            TextFormField(
              controller: lugarCtrl,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text('Lugar del evento'),
              ),
              validator: (lugar){
                if (lugar!.isEmpty){
                  return 'Es necesario ingresar el lugar del evento';
                }
                return null;
              },
            ),
            SizedBox(
              height: 20,
            ),
          //fecha hora
            Container(
            margin: EdgeInsets.only(top: 15),
            child: Row(
            children: [
              Text('Fecha y hora del evento: '),
              Text(
                '${formatoFecha.format(fechaEvento)} ${formatoHora.format(fechaEvento)}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            SizedBox(
              height: 20,
            ),
              IconButton(
                icon: Icon(MdiIcons.calendar),
                onPressed: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2040),
                    locale: Locale('es', 'ES'),
                  ).then((fecha) {
                    if (fecha != null) {
                      showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      ).then((hora) {
                        if (hora != null) {
                          setState(() {
                            fechaEvento = DateTime(
                              fecha.year,
                              fecha.month,
                              fecha.day,
                              hora.hour,
                              hora.minute,
                            );
                          });
                        }
                      });
                    }
                  });
                },
              ),
            ],
            ),
          ) ,
            SizedBox(
              height: 20,
            ),

          //tipo de evento
              FutureBuilder(
                  future: FirestoreService().tipos(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                      //esperando
                      return Text('Tipo de Eventos');
                    } else {
                      var tipos = snapshot.data!.docs;
                      return DropdownButtonFormField<String>(
                        value: tipo == '' ? tipos[0]['tipo'] : tipo,
                        decoration: InputDecoration(labelText: 'Tipo de Evento'),
                        items: tipos.map<DropdownMenuItem<String>>((tip) {
                          return DropdownMenuItem<String>(
                            child: Text(tip['tipo']),
                            value: tip['tipo'],
                          );
                        }).toList(),
                        onChanged: (tiposSeleccionada) {
                          setState(() {
                            tipo = tiposSeleccionada!;
                          });
                        },
                      );
                    }
                  })
                  ,
            SizedBox(
              height: 20,
            ),
           ElevatedButton(onPressed:()async{

               if (formKey.currentState!.validate())
              {String url = await FirestoreService().subirImagen(imagen_subir!);

              if (url != ''){
                FirestoreService().AgregarEvento(
                nombreCtrl.text.trim(), 
                fechaEvento, 
                lugarCtrl.text.trim(), 
                descripcionCtrl.text.trim(), 
                tipo,
                url);

              Navigator.pop(context);
              }}

              

           }, child: Text('Agregar Evento'))
           ,
            SizedBox(
              height: 20,
            ),

            ElevatedButton(onPressed:()async{

              

              Navigator.pop(context);

           }, child: Text('Cancelar'))


          ],
        ),

      ),
    );
  }
}