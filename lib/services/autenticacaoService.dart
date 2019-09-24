import 'package:flutter_social_login/model/usuario.dart';

abstract class AutenticacaoService {
  Future<Usuario> recuperarUsuarioAtual();
  Future<Usuario> loginAnonimo();
  Future<Usuario> login(String email, String password);
  Future<Usuario> criarUsuario(String email, String password, {String nome, String urlFoto});
  Future<void> enviarEmailComResetSenha(String email);
  Future<Usuario> loginComGoogle();
  Future<Usuario> loginComFacebook();
  Future<void> logout();
  //Stream<Usuario> aoMudarStatusAutenticacao(bool sucesso, {Usuario usuario});
  void dispose();
}
