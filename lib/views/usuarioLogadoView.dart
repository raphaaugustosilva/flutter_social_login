import 'package:flutter/material.dart';
import 'package:flutter_social_login/model/usuario.dart';

class UsuarioLogadoView extends StatefulWidget {
  final Usuario usuarioLogado;
  UsuarioLogadoView(this.usuarioLogado);

  @override
  _UsuarioLogadoViewState createState() => _UsuarioLogadoViewState();
}

class _UsuarioLogadoViewState extends State<UsuarioLogadoView> {
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
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 15),
                  Container(
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
                  Row(children: <Widget>[Text("Identificador: ", style: TextStyle(fontWeight: FontWeight.bold),), Text(widget.usuarioLogado.uid)]),
                  SizedBox(height: 15),
                  Row(children: <Widget>[Text("Nome: ", style: TextStyle(fontWeight: FontWeight.bold),), Text(widget.usuarioLogado.nome)]),
                  SizedBox(height: 15),
                  Row(children: <Widget>[Text("Email: ", style: TextStyle(fontWeight: FontWeight.bold),), Text(widget.usuarioLogado.email)]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
