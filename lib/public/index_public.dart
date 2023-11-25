import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'eventos_public.dart';
import 'finalizados.dart';
import 'proximos.dart';


class PublicPage extends StatefulWidget {
  const PublicPage({super.key});

  @override
  State<PublicPage> createState() => _PublicPageState();
}

class _PublicPageState extends State<PublicPage> {

  int paginaSeleccionada = 1;
  Widget pagina = EventosPublicPage();
  String titulo = 'Home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: pagina,
    bottomNavigationBar:    ConvexAppBar(
        initialActiveIndex: 1,
        activeColor: Colors.pink.shade300,
        shadowColor: Colors.pink,
        style: TabStyle.react,
        backgroundColor: Colors.black,
    items: [
      
      TabItem(icon: Icons.arrow_back, title: 'Finalizados'),
      TabItem(icon: EvaIcons.headphones, title: 'Todos'),
      TabItem(icon: Icons.arrow_forward, title: 'Próximos'),
      
    ],
    onTap: (index) {
       paginaSeleccionada = index;
           DateTime ahora = DateTime.now();
          switch (paginaSeleccionada) {
            case 0:
              pagina = EventosFinalizadosPage();
              titulo = 'Finalizados';
              print(ahora);
              setState(() {
                
              });
              break;
            case 1:
              pagina = EventosPublicPage();
              titulo = 'Eventos';
              setState(() {
                
              });
              break;
            case 2:
              pagina = EventosProxPage();
              titulo = 'Próximos';
              setState(() {
                
              });
             break;
          }

    } ,
  ),
    );
  }
}