import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FirestoreService{

  //listar eventos
  Stream<QuerySnapshot>eventos(){
    return FirebaseFirestore.instance.collection('eventos').orderBy('fechaHora').snapshots();
  }


  //finalizados s

   Stream<QuerySnapshot> eventosFinalizados() {
  return FirebaseFirestore.instance.collection('eventos').where('estado', isEqualTo: false).snapshots();
}

//proximos
   Stream<QuerySnapshot> eventosProximos() {
  return FirebaseFirestore.instance.collection('eventos').where('estado', isEqualTo: true).snapshots();
}

  //agregar evento

   Future<void> AgregarEvento(String nombre,  DateTime fechaHora, String lugar, String descripcion, String tipo,  String imagen) async {
    return FirebaseFirestore.instance.collection('eventos').doc().set({
      'nombre': nombre,      
      'fechaHora': fechaHora,
      'lugar': lugar,
      'descripcion' :descripcion ,
      'tipo' : tipo,
      'meGusta': 0,
      'imagen': imagen,
      'estado' : true
    });
  }

  //borrar 
  Future<void> BorrarEvento(String docId) async {
    return FirebaseFirestore.instance.collection('eventos').doc(docId).delete();
  }

  //listar eventos
  Future<DocumentSnapshot> MostrarEvento(String docId) async {
    return FirebaseFirestore.instance.collection('eventos').doc(docId).get() ; 
  }

  //listar tipo de eventos
  //listar eventos
  Future<QuerySnapshot>tipos(){
    return FirebaseFirestore.instance.collection('tipos').orderBy('tipo').get();
  }


  //megusta
  Stream<DocumentSnapshot> streamEvento(String docId) {
  return FirebaseFirestore.instance.collection('eventos').doc(docId).snapshots();
  } 

  Future<void> MeGusta(String docId, int meGusta) async {
    int numero = meGusta +1; 
    return FirebaseFirestore.instance.collection('eventos').doc(docId).update({
   
      'meGusta': numero,
      
    });
  }


  //editar
  Future<void> editar(String docId, bool estado) async {
    bool nuevoEstado = !estado; 
    return FirebaseFirestore.instance.collection('eventos').doc(docId).update({
   
      'estado': nuevoEstado,
      
    });
    }


  //seleccionar imagen de galería
  Future<XFile?> galeria() async{
    final ImagePicker picker = ImagePicker();
    final XFile? imagen = await picker.pickImage(source: ImageSource.gallery);
  return imagen;
}



  //subir imagen
  final FirebaseStorage storage = FirebaseStorage.instance;

Future<String> subirImagen(File imagen) async {
  final String nombre = imagen.path.split('/').last;

  final Reference ref = storage.ref().child("images").child(nombre);

  final UploadTask uploadTask = ref.putFile(imagen);

  final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);

  final String url = await snapshot.ref.getDownloadURL();
  
  if(snapshot.state == TaskState.success){
    return url;
  }else{
    return '';
  }
}
  
}