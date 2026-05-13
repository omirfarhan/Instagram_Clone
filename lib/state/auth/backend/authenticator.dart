import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instagramclone/state/auth/constants/constants.dart';
import 'package:instagramclone/state/auth/models/auth_result.dart';
import 'package:instagramclone/state/posts/user_id.dart';

class Authenticator {
  bool get isAlreadyLogin => UserId != null;

  UserId? get userId => FirebaseAuth.instance.currentUser?.uid;

  String get displayName =>
      FirebaseAuth.instance.currentUser?.displayName ?? '';

  String? get email => FirebaseAuth.instance.currentUser?.email;

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn.instance.signOut();
  }

  Future<AuthResult> loginWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn.instance;
    await googleSignIn.initialize(
      serverClientId:
          '799885128046-grv1a6qi00kcsm9goh4s8s486atj9ml7.apps.googleusercontent.com',
    );
    final account = await googleSignIn.authenticate();
    final authserver = await account.authorizationClient.authorizeScopes([
      Constants.emailScope,
    ]);

    // if (account == null) {
    //   return AuthResult.aborted;
    // }

    final oauthcredential = GoogleAuthProvider.credential(
      accessToken: authserver.accessToken,
    );
    print('AccessToken is ready====${oauthcredential.accessToken}');
    try {
      await FirebaseAuth.instance.signInWithCredential(oauthcredential);
      return AuthResult.success;
    } catch (e) {
      return AuthResult.failure;
    }
  }
}
