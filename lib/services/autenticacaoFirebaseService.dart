import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_social_login/model/usuario.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_social_login/model/socialLoginException.dart';
import 'package:flutter_social_login/services/autenticacaoService.dart';

class AutenticacaoFirebaseService implements AutenticacaoService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Usuario _converterUsuarioFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return Usuario(
      uid: user.uid,
      email: user.email,
      nome: user.displayName,
      urlFoto: user.photoUrl,
    );
  }

  // @override
  // Stream<Usuario> aoMudarStatusAutenticacao(bool sucesso, {Usuario usuario}) {
  //   return sucesso ? Stream<Usuario>.value(usuario) : null;
  // }

  @override
  Future<Usuario> loginAnonimo() async {
    Usuario usuarioAnonimo;
    try {
      final AuthResult authResult = await _firebaseAuth.signInAnonymously();
      usuarioAnonimo = _converterUsuarioFirebase(authResult.user);
    } catch (e) {
      String mensagemErro;
      switch (e.code) {
        case "ERROR_OPERATION_NOT_ALLOWED":
          mensagemErro = "Não está configurado a possibilidade de login anônimo no Firebase";
          break;

        default:
          mensagemErro = e.message;
          break;
      }
      throw SocialLoginException(codigoErro: e.code, mensagemErro: mensagemErro);
    }
    return usuarioAnonimo;
  }

  @override
  Future<Usuario> login(String email, String senha) async {
    Usuario usuarioFirebaseEncontrado;
    try {
      final AuthResult authResult = await _firebaseAuth.signInWithCredential(EmailAuthProvider.getCredential(
        email: email,
        password: senha,
      ));
      usuarioFirebaseEncontrado = _converterUsuarioFirebase(authResult.user);
    } catch (e) {
      String mensagemErro;
      switch (e.code) {
        case "ERROR_INVALID_EMAIL":
          mensagemErro = "E-mail inválido";
          break;

        case "ERROR_WRONG_PASSWORD":
          mensagemErro = "Senha inválida ou não definida";
          break;

        case "ERROR_USER_NOT_FOUND":
          mensagemErro = "Não foi encontrado um usuário com este e-mail";
          break;

        case "ERROR_TOO_MANY_REQUESTS":
          mensagemErro = "Foram feitas muitas tentativas de login para este e-mail";
          break;

        case "ERROR_INVALID_CREDENTIAL":
          mensagemErro = "Credenciais inválidas";
          break;

        case "ERROR_USER_DISABLED":
          mensagemErro = "Este usuário está desabilitado";
          break;

        case "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL":
          mensagemErro = "Este email já está sendo usado por outra conta";
          break;

        case "ERROR_OPERATION_NOT_ALLOWED":
          mensagemErro = "Conta do Google não permitida";
          break;

        case "ERROR_INVALID_ACTION_CODE":
          mensagemErro = "ERROR_INVALID_ACTION_CODE";
          break;

        default:
          mensagemErro = e.message;
          break;
      }
      throw SocialLoginException(codigoErro: e.code, mensagemErro: mensagemErro);
    }
    return usuarioFirebaseEncontrado;
  }

  @override
  Future<Usuario> criarUsuario(String email, String senha, {String nome, String urlFoto}) async {
    Usuario usuarioFirebaseCriado;
    try {
      final AuthResult authResult = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: senha);
      if ((nome != null || urlFoto != null) && ((authResult.user?.uid ?? "").isNotEmpty)) {
        UserUpdateInfo userUpdateInfo = UserUpdateInfo();
        if (nome != null) {
          userUpdateInfo.displayName = nome;
        }

        if (urlFoto != null) {
          userUpdateInfo.photoUrl = urlFoto;
        }

        //Atualizo o usuário com informações adicionais
        await authResult.user.updateProfile(userUpdateInfo);

        //Como eu atualizei e o authResult.user.reload nao carrega as informações novas, eu forço pegar os resultados novos setados com _firebaseAuth.currentUser()
        usuarioFirebaseCriado = _converterUsuarioFirebase(await _firebaseAuth.currentUser());
      } else {
        usuarioFirebaseCriado = _converterUsuarioFirebase(authResult.user);
      }
    } catch (e) {
      String mensagemErro;
      switch (e.code) {
        case "ERROR_WEAK_PASSWORD":
          mensagemErro = "Senha fraca";
          break;

        case "ERROR_INVALID_EMAIL":
          mensagemErro = "E-mail inválido";
          break;

        case "ERROR_EMAIL_ALREADY_IN_USE":
          mensagemErro = "Este email já está sendo usado por outra conta";
          break;

        default:
          mensagemErro = e.message;
          break;
      }
      throw SocialLoginException(codigoErro: e.code, mensagemErro: mensagemErro);
    }
    return usuarioFirebaseCriado;
  }

  @override
  Future<void> enviarEmailComResetSenha(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      String mensagemErro;
      switch (e.code) {
        case "ERROR_INVALID_EMAIL":
          mensagemErro = "E-mail inválido";
          break;

        case "ERROR_USER_NOT_FOUND":
          mensagemErro = "Não existe um usuário cadastrado com este e-mail";
          break;

        default:
          mensagemErro = e.message;
          break;
      }
      throw SocialLoginException(codigoErro: e.code, mensagemErro: mensagemErro);
    }
  }

  @override
  Future<Usuario> loginComGoogle() async {
    Usuario usuarioLogadoGoogle;
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        if (googleAuth.accessToken != null && googleAuth.idToken != null) {
          final AuthResult authResult = await _firebaseAuth.signInWithCredential(GoogleAuthProvider.getCredential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken,
          ));
          usuarioLogadoGoogle = _converterUsuarioFirebase(authResult.user);
        } else {
          throw PlatformException(code: 'GOOGLE_AUTH_TOKEN_FALTANDO', message: 'Está faltando o Google Auth Token');
        }
      } else {
        throw PlatformException(code: 'GOOGLE_ABORTADO_PELO_USUARIO', message: 'Abortado pelo usuário');
      }
    } catch (e) {
      throw SocialLoginException(codigoErro: e.code, mensagemErro: e.message);
    }
    return usuarioLogadoGoogle;
  }

  @override
  Future<Usuario> loginComFacebook() async {
    Usuario usuarioLogadoFacebook;
    try {
      final FacebookLogin facebookLogin = FacebookLogin();
      final FacebookLoginResult facebookLoginResult = await facebookLogin.logIn(<String>['public_profile']);
      String urlFotoGraph;
      switch (facebookLoginResult.status) {
        case FacebookLoginStatus.error:
          throw PlatformException(code: 'FACEBOOK_LOGIN_ERRO', message: 'Erro ao realizar login com Facebook');
          break;
        case FacebookLoginStatus.cancelledByUser:
          throw PlatformException(code: 'FACEBBOOK_ABORTADO_PELO_USUARIO', message: 'Abortado pelo usuário');
          break;
        case FacebookLoginStatus.loggedIn:
          //Caso deu certo o login com o Facebook, agora eu pego informações como uma foto em maior resolução por exemplo, consumindo a API Graph do Facebook
          http.Response graphResponse = await http.get('https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.width(400)&access_token=${facebookLoginResult.accessToken.token}');

          final int statusCode = graphResponse.statusCode;
          if (statusCode >= 200 && statusCode <= 299) {
            var profile = json.decode(graphResponse.body);
            print(profile.toString());
            urlFotoGraph = profile['picture']['data']['url'];
          }

          break;
      }

      if (facebookLoginResult.accessToken != null) {
        //Faço o login
        final AuthResult authResult = await _firebaseAuth.signInWithCredential(FacebookAuthProvider.getCredential(accessToken: facebookLoginResult.accessToken.token));
        usuarioLogadoFacebook = _converterUsuarioFirebase(authResult.user);

        //Se deu certo o consumo do Graph do Facebook para pegar a foto, então jogo no resultado do usuário
        if (urlFotoGraph != null) {
          usuarioLogadoFacebook.urlFoto = urlFotoGraph;
        }
      } else {
        throw PlatformException(code: 'FACEBBOOK_ABORTADO_PELO_USUARIO', message: 'Abortado pelo usuário');
      }
    } catch (e) {
      throw SocialLoginException(codigoErro: e.code, mensagemErro: e.message);
    }
    return usuarioLogadoFacebook;
  }

  @override
  Future<Usuario> recuperarUsuarioAtual() async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    return _converterUsuarioFirebase(user);
  }

  @override
  Future<void> logout() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();

    final FacebookLogin facebookLogin = FacebookLogin();
    await facebookLogin.logOut();

    return _firebaseAuth.signOut();
  }

  @override
  void dispose() {}
}
