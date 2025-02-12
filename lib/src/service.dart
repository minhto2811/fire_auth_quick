import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum OAuth { google, apple, facebook, anonymous }

class FireAuthQuick {
  static final _auth = FirebaseAuth.instance;
  static final _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  static User? get currentUser => _auth.currentUser;

  static Future<void> signOut() async => await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
        _facebookLogOut(),
      ]);

  static Future<void> _facebookLogOut() async {
    try {
      await FacebookAuth.instance.logOut();
    } catch (e) {
      // ignore
    }
  }

  static Future<void> delete() async {
    final user = await reauthenticateWithProvider();
    await user.delete();
    await _googleSignIn.signOut();
  }

  static Future<UserCredential> loginWithProvider(
      {required OAuth oAuth}) async {
    if (_auth.currentUser != null) throw Exception('User already logged in');
    switch (oAuth) {
      case OAuth.google:
        return await _loginWithGoogle();
      case OAuth.apple:
        return await _loginWithApple();
      case OAuth.facebook:
        return await _loginWithFacebook();
      case OAuth.anonymous:
        return await _auth.signInAnonymously();
      }
  }

  static Future<User> unlink(String providerId) async =>
      await currentUser!.unlink(providerId);

  static Future<UserCredential> linkWithProvider({required OAuth oAuth}) async {
    if (_auth.currentUser == null) throw Exception('No user logged in');
    switch (oAuth) {
      case OAuth.google:
        return await _linkWithGoogle();
      case OAuth.apple:
        return await _linkWithApple();
      case OAuth.facebook:
        return await _linkWithFacebook();
      default:
        throw Exception('Unknown provider: $oAuth');
    }
  }

  static Future<UserCredential> _linkWithGoogle() async {
    final credential = await _getOAuthCredentialGoogle;
    return await _auth.currentUser!.linkWithCredential(credential);
  }

  static Future<UserCredential> _linkWithApple() async {
    final appleProvider = AppleAuthProvider()
      ..addScope('email')
      ..addScope('name');
    return await _auth.currentUser!.linkWithProvider(appleProvider);
  }

  static Future<UserCredential> _linkWithFacebook() async {
    final facebookProvider = FacebookAuthProvider();
    return await _auth.currentUser!.linkWithProvider(facebookProvider);
  }

  static Future<User> reauthenticateWithProvider(
      {AuthProvider? authProvider}) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');
    final provider =
        authProvider ?? _getProvider(user.providerData.first.providerId);
    await user.reauthenticateWithProvider(provider);
    return user;
  }

  static Future<OAuthCredential> get _getOAuthCredentialGoogle async {
    final googleUser = await _googleSignIn.signIn();
    final googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return credential;
  }

  static Future<UserCredential> _loginWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);
    return _auth.signInWithCredential(facebookAuthCredential);
  }

  static Future<UserCredential> _loginWithApple() async {
    final appleProvider = AppleAuthProvider()
      ..addScope('email')
      ..addScope('name');
    return await _auth.signInWithProvider(appleProvider);
  }

  static Future<UserCredential> _loginWithGoogle() async {
    final credential = await _getOAuthCredentialGoogle;
    return await _auth.signInWithCredential(credential);
  }

  static AuthProvider _getProvider(String provider) {
    switch (provider) {
      case 'google.com':
        return GoogleAuthProvider();
      case 'apple.com':
        return AppleAuthProvider();
      case 'facebook.com':
        return FacebookAuthProvider();
      default:
        throw Exception('Unknown provider: $provider');
    }
  }
}
