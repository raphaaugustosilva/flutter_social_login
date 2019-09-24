import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_social_login/helper/validators.dart';
import 'package:flutter_social_login/helper/geralHelper.dart';
import 'package:flutter_social_login/model/socialLoginException.dart';
import 'package:flutter_social_login/services/autenticacaoService.dart';
import 'package:flutter_social_login/services/autenticacaoFirebaseService.dart';

class EsqueceuSenhaView extends StatefulWidget {
  @override
  _EsqueceuSenhaViewState createState() => _EsqueceuSenhaViewState();
}

class _EsqueceuSenhaViewState extends State<EsqueceuSenhaView> {
  final FocusScopeNode _node = FocusScopeNode();
  final TextEditingController _emailController = TextEditingController();
  final EmailESenhaValidadores _emailESenhaValidadores = EmailESenhaValidadores();
  bool estaCarregando = false;
  final AutenticacaoService autenticacaoService = AutenticacaoFirebaseService();

  @override
  void dispose() {
    _node.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text("Esqueceu Senha"),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: estaCarregando
                  ? Center(child: CircularProgressIndicator())
                  : FocusScope(
                      node: _node,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          SizedBox(height: 8.0),
                          _constroiEmail(),
                          SizedBox(height: 8.0),
                          FlatButton(
                            color: Colors.red,
                            textColor: Colors.white,
                            child: Center(child: estaCarregando ? CircularProgressIndicator() : Text("Redefinir senha")),
                            onPressed: estaCarregando ? null : () => _enviarEmailComResetSenha(),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _enviarEmailComResetSenha() async {
    setState(() {
      estaCarregando = true;
    });

    try {
      await autenticacaoService.enviarEmailComResetSenha(_emailController.text);
      GeralHelper.instancia.exibirMensagem(context, "E-mail enviado", "Foi enviado um e-mail para ${_emailController.text} para redefinição de senha");
    } on SocialLoginException catch (e) {
      GeralHelper.instancia.exibirMensagem(context, "Erro ao recuperar a senha", "Ocorreu um erro ao recuperar a senha. Detalhes: \n  CODIGO: ${e.codigoErro}\n  MENSAGEM: ${e.mensagemErro}");
    }

    setState(() {
      estaCarregando = false;
    });
  }

  void _emailPreenchidoCompleto() {}

  Widget _constroiEmail() {
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: "Digite o email para redefinir a senha",
        hintText: "raphael@gmail.com",
        errorText: (_emailController.text.isEmpty || _emailESenhaValidadores.emailValidoValidador.estaValido(_emailController.text)) ? null : "Email inválido",
        enabled: !estaCarregando,
      ),
      autocorrect: false,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      keyboardAppearance: Brightness.light,
      onEditingComplete: _emailPreenchidoCompleto,
      inputFormatters: <TextInputFormatter>[
        _emailESenhaValidadores.emailEntradaFormatter,
      ],
    );
  }
}
