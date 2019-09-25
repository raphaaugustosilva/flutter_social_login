import 'package:flutter/material.dart';
import 'package:flutter_social_login/helper/navegacaoHelper.dart';
import 'package:flutter_social_login/services/autenticacaoService.dart';
import 'package:flutter_social_login/services/autenticacaoFirebaseService.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  void initState() {
    super.initState();
    final AutenticacaoService autenticacaoService = AutenticacaoFirebaseService();
    autenticacaoService.recuperarUsuarioAtual().then((usuarioLogado) {
      if (usuarioLogado != null) {
        NavegacaoHelper.resetaNavegacaoENavegaParaView(context, NavegacaoHelper.rotaUsuarioLogado, arguments: {"usuario": usuarioLogado});
      } else {
        NavegacaoHelper.resetaNavegacaoENavegaParaView(context, NavegacaoHelper.rotaPrincipal);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
