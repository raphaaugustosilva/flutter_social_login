import 'package:flutter/material.dart';
import 'package:flutter_social_login/model/usuario.dart';
import 'package:flutter_social_login/views/landingPage.dart';
import 'package:flutter_social_login/views/principalView.dart';
import 'package:flutter_social_login/views/esqueceuSenhaView.dart';
import 'package:flutter_social_login/views/usuarioLogadoView.dart';
import 'package:flutter_social_login/views/criarNovoUsuarioView.dart';
import 'package:flutter_social_login/views/loginUsuarioESenhaView.dart';

class NavegacaoHelper {
  static const rotaRoot = "/";
  static const rotaLandingPage = "/landingPage";
  static const rotaLogin = "/login";
  static const rotaCriarNovoUsuario = "/criarNovoUsuario";
  static const rotaEsqueceuSenha = "/esqueceuSenha";
  static const rotaPrincipal = "/principal";
  static const rotaUsuarioLogado = "/usuariologado";

  static RouteFactory rotas() {
    return (settings) {
      final Map<String, dynamic> parametros = settings.arguments;
      Widget viewEncontrada;

      switch (settings.name) {
        case rotaRoot:
          //viewEncontrada = LandingPage();
          viewEncontrada = PrincipalView();
          break;

        case rotaLandingPage:
          viewEncontrada = LandingPage();
          break;

        case rotaPrincipal:
          viewEncontrada = PrincipalView();
          break;

        case rotaLogin:
          viewEncontrada = LoginUsuarioESenhaView();
          break;

        case rotaCriarNovoUsuario:
          viewEncontrada = CriarNovoUsuarioView();
          break;

        case rotaEsqueceuSenha:
          viewEncontrada = EsqueceuSenhaView();
          break;

        case rotaUsuarioLogado:
          Usuario usuarioLogado = parametros != null ? parametros["usuarioLogado"] : null;
          if (usuarioLogado != null) {
            viewEncontrada = UsuarioLogadoView(usuarioLogado);
          }
          break;

        // case rotaVisualizadorPDF:
        //   //Faço aqui a extração dos parâmetros
        //   File arquivoPDF = parametros != null ? parametros["arquivoPDF"] : null;
        //   viewEncontrada = VisualizadorPDFView(arquivoPDF);
        //   break;

        default:
          return null;
      }

      return MaterialPageRoute(builder: (BuildContext context) => viewEncontrada);
    };
  }

  static RouteFactory rotaNaoEncontrada() {
    return (settings) {
      String rotaNaoEncontrada = settings.name;
      return MaterialPageRoute(builder: (context) => _widgetRotaNaoEncontrada(rotaNaoEncontrada));
    };
  }

  static Widget _widgetRotaNaoEncontrada(String rotaNaoEncontrada) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        title: Text("Rota não encontrada"),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(20),
        child: Text.rich(
          TextSpan(
            children: <TextSpan>[
              TextSpan(text: "A rota ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              TextSpan(text: "$rotaNaoEncontrada", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.yellow)),
              TextSpan(text: " não foi encontrada/definida", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  static resetaNavegacaoENavegaParaLogin(BuildContext context, {String email, String senha}) {
    Navigator.of(context).pushNamedAndRemoveUntil(NavegacaoHelper.rotaLogin, (Route<dynamic> route) => false);
    Navigator.of(context).pushNamed(NavegacaoHelper.rotaLogin);
  }
}
