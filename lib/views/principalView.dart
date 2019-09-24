import 'package:flutter/material.dart';
import 'package:flutter_social_login/model/usuario.dart';
import 'package:flutter_social_login/helper/geralHelper.dart';
import 'package:flutter_social_login/helper/navegacaoHelper.dart';
import 'package:flutter_social_login/model/socialLoginException.dart';
import 'package:flutter_social_login/services/autenticacaoService.dart';
import 'package:flutter_social_login/services/autenticacaoFirebaseService.dart';

class PrincipalView extends StatefulWidget {
  @override
  _PrincipalViewState createState() => _PrincipalViewState();
}

class _PrincipalViewState extends State<PrincipalView> {
  bool estaCarregando = false;
  final AutenticacaoService autenticacaoService = AutenticacaoFirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text("Flutter Social Login"),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[200],
      body: _constroiTelaPrincipal(context),
    );
  }

  Widget _constroiTelaPrincipal(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 50.0,
            child: estaCarregando ? Center(child: CircularProgressIndicator()) : Text("Login", textAlign: TextAlign.center, style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w600)),
          ),
          SizedBox(height: 48.0),
          RaisedButton.icon(
            icon: Image.asset("assets/googleLogo.png"),
            label: Padding(padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15), child: Text("Login com o Google")),
            onPressed: estaCarregando ? null : () => _loginComGoogle(context),
            color: Colors.white,
          ),
          SizedBox(height: 15),
          RaisedButton.icon(
            icon: Image.asset("assets/facebookLogo.png"),
            label: Padding(padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15), child: Text("Login com o Facebook")),
            textColor: Colors.white,
            onPressed: estaCarregando ? null : () => _loginComFacebook(context),
            color: Color(0xFF334D92),
          ),
          SizedBox(height: 15),
          RaisedButton.icon(
            icon: Icon(Icons.email),
            label: Padding(padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15), child: Text("Login com usuário a senha")),
            onPressed: estaCarregando ? null : () => Navigator.of(context).pushNamed(NavegacaoHelper.rotaLogin),
            textColor: Colors.white,
            color: Colors.teal[700],
          ),
          SizedBox(height: 15),
          Text(
            "ou",
            style: TextStyle(fontSize: 14.0, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15),
          RaisedButton(
            child: Padding(padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15), child: Text("Login anônimo")),
            color: Colors.lime[300],
            textColor: Colors.black87,
            onPressed: estaCarregando ? null : () => _loginAnonimo(context),
          ),
        ],
      ),
    );
  }

  void _loginComFacebook(BuildContext context) async {
    setState(() {
      estaCarregando = true;
    });

    try {
      Usuario usuarioLogadoFacebook = await autenticacaoService.loginComFacebook();
      if (usuarioLogadoFacebook != null) {
        Navigator.of(context).pushNamed(NavegacaoHelper.rotaUsuarioLogado, arguments: {"usuario": usuarioLogadoFacebook});
      }
    } on SocialLoginException catch (e) {
      GeralHelper.instancia.exibirMensagem(context, "Atenção", "Ocorreu um erro ao realizar o login. Detalhes: \n  CODIGO: ${e.codigoErro}\n  MENSAGEM: ${e.mensagemErro}");
    }

    setState(() {
      estaCarregando = false;
    });
  }

  void _loginComGoogle(BuildContext context) async {
    setState(() {
      estaCarregando = true;
    });

    try {
      Usuario usuarioLogadoGoogle = await autenticacaoService.loginComGoogle();
      if (usuarioLogadoGoogle != null) {
        Navigator.of(context).pushNamed(NavegacaoHelper.rotaUsuarioLogado, arguments: {"usuario": usuarioLogadoGoogle});
      }
    } on SocialLoginException catch (e) {
      GeralHelper.instancia.exibirMensagem(context, "Atenção", "Ocorreu um erro ao realizar o login. Detalhes: \n  CODIGO: ${e.codigoErro}\n  MENSAGEM: ${e.mensagemErro}");
    }

    setState(() {
      estaCarregando = false;
    });
  }

  void _loginAnonimo(BuildContext context) async {
    setState(() {
      estaCarregando = true;
    });

    try {
      Usuario usuarioAnonimo = await autenticacaoService.loginAnonimo();
      if (usuarioAnonimo != null) {
        Navigator.of(context).pushNamed(NavegacaoHelper.rotaUsuarioLogado, arguments: {"usuario": usuarioAnonimo});
      }
    } on SocialLoginException catch (e) {
      GeralHelper.instancia.exibirMensagem(context, "Atenção", "Ocorreu um erro ao realizar o login. Detalhes: \n  CODIGO: ${e.codigoErro}\n  MENSAGEM: ${e.mensagemErro}");
    }

    setState(() {
      estaCarregando = false;
    });
  }
}
