


import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future <User?> signInWithGoogle() async {

  try {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null ) return null;

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken

    );

    UserCredential userCredential = await auth.signInWithCredential(credential);

    return userCredential.user;

  }catch (ex) {
    throw Exception(ex);

  }

  



}

Future<void> signOut() async{
  await auth.signOut();
  await googleSignIn.signOut();

}