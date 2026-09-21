import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_all_platforms_desktop/google_sign_in_all_platforms_desktop.dart';

enum OAuth { google, apple, anonymous }

class FireAuthQuick {
  static final _auth = FirebaseAuth.instance;
  static const _clientId = String.fromEnvironment(
    'GOOGLE_CLIENT_ID',
    defaultValue: '',
  );
  static const _serverClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
    defaultValue: '',
  );
  static GoogleSignIn? _googleSignIn;
  static GoogleSignInAllPlatformsDesktop? _googleSignInDesktop;

  static User? get currentUser => _auth.currentUser;

  static Future<void> googleInitialize({
    int redirectPort = 8000,
  }) async {
    if (isDesktop) {
      if (_googleSignInDesktop != null) return;
      _googleSignInDesktop = GoogleSignInAllPlatformsDesktop();
      return _googleSignInDesktop!.init(GoogleSignInParams(
        clientId: _clientId,
        clientSecret: _serverClientId,
        redirectPort: redirectPort,
        scopes: ['openid', 'profile', 'email'],
      ));
    }
    if (_googleSignIn != null) return;
    _googleSignIn = GoogleSignIn.instance;
    return _googleSignIn!.initialize();
  }

  static Future<UserCredential?> googleSignInSilentForDesktop() async {
    if (_googleSignInDesktop == null) {
      throw Exception('Google Sign In not initialized for desktop');
    }
    final googleAuth = await _googleSignInDesktop?.silentSignIn();
    if (googleAuth == null) return null;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );
    return _auth.signInWithCredential(credential);
  }

  static Future<void> signOut() => Future.wait([
        _auth.signOut(),
        _googleSignOut(),
      ]);

  static Future<void> _googleSignOut() {
    if (isDesktop && _googleSignInDesktop != null) {
      return _googleSignInDesktop!.signOut();
    } else if (!isDesktop && _googleSignIn != null) {
      return _googleSignIn!.signOut();
    }
    return Future.value();
  }

  /// Default: GoogleSignIn(scopes: ['email', 'profile'])

  /// please call method `reauthenticateWithProvider` before use method `delete`
  static Future<void> delete() async {
    if (isDesktop) {
      throw Exception('Function not supported on Windows');
    }
    await Future.wait([
      _auth.currentUser!.delete(),
      _googleSignIn!.disconnect(),
    ]);
  }

  static Future<UserCredential> loginWithProvider(
      {required OAuth oAuth}) async {
    if (!isDesktop && _auth.currentUser != null) {
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
    if (isDesktop) {
      final googleAuth = await _googleSignInDesktop!.signInOnline();
      return GoogleAuthProvider.credential(
        idToken: googleAuth!.idToken,
        accessToken: googleAuth.accessToken,
      );
    }
    final googleUser =
        await _googleSignIn!.authenticate(scopeHint: ['email', 'profile']);
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
