import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum OAuth { google, apple, anonymous }

class FireAuthQuick {
  static final _auth = FirebaseAuth.instance;

  static User? get currentUser => _auth.currentUser;

  static Future<void> googleInitialize() => GoogleSignIn.instance.initialize();

  static Future<void> signOut() => Future.wait([
        _auth.signOut(),
        _googleSignOut(),
      ]);

  static Future<void> _googleSignOut() => GoogleSignIn.instance.signOut();

  static Future<void> _googleDisconnect() => GoogleSignIn.instance.disconnect();

  /// Default: GoogleSignIn(scopes: ['email', 'profile'])

  /// please call method `reauthenticateWithProvider` before use method `delete`
  static Future<void> delete() => _auth.currentUser!.delete();

  static Future<UserCredential> loginWithProvider(
      {required OAuth oAuth}) async {
    if (_auth.currentUser != null) {
      throw Exception('User already logged in');
    }
    switch (oAuth) {
      case OAuth.google:
        return await _loginWithGoogle();
      case OAuth.apple:
        return await _loginWithApple();
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

  static Future<User> reauthenticateWithProvider(
      {AuthProvider? authProvider}) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');
    if (user.isAnonymous) return user;
    final provider =
        authProvider ?? _getProvider(user.providerData.first.providerId);
    await user.reauthenticateWithProvider(provider);
    return user;
  }

  static Future<OAuthCredential> get _getOAuthCredentialGoogle async {
    final googleUser = await GoogleSignIn.instance
        .authenticate(scopeHint: ['email', 'profile']);
    final idToken = googleUser.authentication.idToken;
    return GoogleAuthProvider.credential(
      idToken: idToken,
    );
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
      default:
        throw Exception('Unknown provider: $provider');
    }
  }
}
