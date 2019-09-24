import 'package:flutter/material.dart';
import 'package:flutter_social_login/model/usuario.dart';

abstract class AutenticacaoService {
  Future<Usuario> recuperarUsuarioAtual();
  Future<Usuario> loginAnonimo();
  Future<Usuario> login(String email, String password);
  Future<Usuario> criarUsuario(String email, String password);
  Future<void> sendPasswordResetEmail(String email);
  Future<Usuario> signInWithEmailAndLink({String email, String link});
  Future<bool> isSignInWithEmailLink(String link);
  Future<void> sendSignInWithEmailLink({
    @required String email,
    @required String url,
    @required bool handleCodeInApp,
    @required String iOSBundleID,
    @required String androidPackageName,
    @required bool androidInstallIfNotAvailable,
    @required String androidMinimumVersion,
  });
  Future<Usuario> loginComGoogle();
  Future<Usuario> loginComFacebook();
  Future<void> logout();
  Stream<Usuario> get onAuthStateChanged;
  void dispose();
}
