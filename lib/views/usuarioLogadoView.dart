import 'package:flutter/material.dart';
import 'package:flutter_social_login/helper/navegacaoHelper.dart';
import 'package:flutter_social_login/model/usuario.dart';
import 'package:flutter_social_login/helper/geralHelper.dart';
import 'package:flutter_social_login/model/socialLoginException.dart';
import 'package:flutter_social_login/services/autenticacaoService.dart';
import 'package:flutter_social_login/services/autenticacaoFirebaseService.dart';

class UsuarioLogadoView extends StatefulWidget {
  final Usuario usuarioLogado;
  UsuarioLogadoView(this.usuarioLogado);

  @override
  _UsuarioLogadoViewState createState() => _UsuarioLogadoViewState();
}

class _UsuarioLogadoViewState extends State<UsuarioLogadoView> {
  final AutenticacaoService autenticacaoService = AutenticacaoFirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text("Usuário Logado"),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 15),
                      widget.usuarioLogado.urlFoto == null
                          ? Container()
                          : Container(
                              height: 200.0,
                              width: 200.0,
                              decoration: (widget.usuarioLogado.urlFoto ?? "").isEmpty
                                  ? Container()
                                  : BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(
                                          widget.usuarioLogado.urlFoto,
                                        ),
                                      ),
                                    ),
                            ),
                      SizedBox(height: 15),
                      Row(children: <Widget>[
                        Text("Identificador: ", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(widget.usuarioLogado.uid ?? ""),
                      ]),
                      SizedBox(height: 15),
                      Row(children: <Widget>[
                        Text("Nome: ", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(widget.usuarioLogado.nome ?? ""),
                      ]),
                      SizedBox(height: 15),
                      Row(children: <Widget>[
                        Text("Email: ", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(widget.usuarioLogado.email ?? ""),
                      ]),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              FlatButton(
                color: Colors.black,
                textColor: Colors.white,
                child: Center(child: Text("LOGOUT")),
                onPressed: () async {
                  try {
                    await autenticacaoService.logout();
                    NavegacaoHelper.resetaNavegacaoENavegaParaView(context, NavegacaoHelper.rotaPrincipal);
                  } on SocialLoginException catch (e) {
                    GeralHelper.instancia.exibirMensagem(context, "Erro", "Ocorreu um erro ao fazer o logout. Detalhes: \n  CODIGO: ${e.codigoErro}\n  MENSAGEM: ${e.mensagemErro}");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
