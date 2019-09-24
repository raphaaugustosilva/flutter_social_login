import 'package:flutter/material.dart';

enum TipoSnackBarEnum { informacao, erro, correto }

class GeralHelper {
  GeralHelper._construtorPrivate();
  static final instancia = GeralHelper._construtorPrivate();

  Offset recuperaPosicaoElemento(GlobalKey keyElemento) {
    final RenderBox renderBloco = keyElemento?.currentContext?.findRenderObject();
    final Offset posicao = renderBloco?.localToGlobal(Offset.zero);
    return posicao;
  }

  Size recuperaTamanhoElemento(GlobalKey keyElemento) {
    final RenderBox renderBloco = keyElemento?.currentContext?.findRenderObject();
    final Size tamanho = renderBloco?.size;
    return tamanho;
  }

  Future exibirMensagem(BuildContext context, String titulo, String mensagem) async {
    // flutter defined function
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(titulo),
          content: Text(mensagem),
          actions: <Widget>[
            FlatButton(
              child: Text("Fechar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // void exibirMensagemNoSnackBar(GlobalKey<ScaffoldState> scaffoldKey, String mensagem, {Color corSnackBar}) {
  //   final Color _corSnackBar = corSnackBar ?? Colors.black.withOpacity(0.5);
  //   scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(mensagem), backgroundColor: _corSnackBar));
  // }

  bool validaEmail(String email) {
    return RegExp("[a-z0-9!#\$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#\$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?").hasMatch(email);
  }
}
