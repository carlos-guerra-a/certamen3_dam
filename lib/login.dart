
import 'package:certamen3_dam/admin/eventos.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';

import 'public/index_public.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  @override
  void initState() {
    super.initState();
    auth.authStateChanges().listen((event) { 
      setState(() {
        user = event;
      });

    });
  }


  @override
  Widget build(BuildContext context) {
    return  user == null ? EventosAdminPage() : PublicPage();  }

  Widget googleSignInButton() {
    return Center(
      child: 
      SizedBox(
        height: 50,
        child: SignInButton(Buttons.google, text: 'Ingrese con Google',
        onPressed: (){
          handleGoogleSignIn();

        },),
      ),
    );
  }

  Widget userInfo() {
    return SizedBox(

      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              image: DecorationImage(image: NetworkImage(user!.photoURL!)
              )),
          ),
          Text(user!.email!),
          Text(user!.displayName ?? ""),
          MaterialButton(
            color: Colors.red,
            child: Text('Salir'),
            onPressed: (){
              auth.signOut();
            })

        ],
      ),

    );
  }

  void handleGoogleSignIn(){
    try {
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      auth.signInWithProvider(googleAuthProvider);

    } catch (error){
      print(error);
    }

  }

}