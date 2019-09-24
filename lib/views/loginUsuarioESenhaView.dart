import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_social_login/model/usuario.dart';
import 'package:flutter_social_login/helper/validators.dart';
import 'package:flutter_social_login/helper/geralHelper.dart';
import 'package:flutter_social_login/helper/navegacaoHelper.dart';
import 'package:flutter_social_login/model/socialLoginException.dart';
import 'package:flutter_social_login/services/autenticacaoService.dart';
import 'package:flutter_social_login/services/autenticacaoFirebaseService.dart';

class LoginUsuarioESenhaView extends StatefulWidget {
  @override
  _LoginUsuarioESenhaViewState createState() => _LoginUsuarioESenhaViewState();
}

class _LoginUsuarioESenhaViewState extends State<LoginUsuarioESenhaView> {
  final FocusScopeNode _node = FocusScopeNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final EmailESenhaValidadores _emailESenhaValidadores = EmailESenhaValidadores();
  bool estaCarregando = false;
  final AutenticacaoService autenticacaoService = AutenticacaoFirebaseService();

  @override
  void dispose() {
    _node.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text("Login"),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: FocusScope(
                node: _node,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 8.0),
                    _constroiEmail(),
                    _constroiSenha(),
                    SizedBox(height: 8.0),
                    FlatButton(
                      color: Colors.red,
                      textColor: Colors.white,
                      child: Center(child: estaCarregando ? Container(child: CircularProgressIndicator(), height: 20, width: 20) : Text("Login")),
                      onPressed: () async {
                        await _efetuarLogin();
                      },
                    ),
                    SizedBox(height: 8.0),
                    FlatButton(
                      child: Text("Precisa de uma conta? Registre-se"),
                      onPressed: estaCarregando ? null : () => Navigator.of(context).pushNamed(NavegacaoHelper.rotaCriarNovoUsuario),
                    ),
                    FlatButton(
                      child: Text("Esqueceu sua senha?"),
                      onPressed: estaCarregando ? null : () => Navigator.of(context).pushNamed(NavegacaoHelper.rotaEsqueceuSenha),
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

  Future<void> _efetuarLogin() async {
    setState(() {
      estaCarregando = true;
    });

    try {
      final Usuario usuarioLogado = await autenticacaoService.login(_emailController.text, _senhaController.text);
      if (usuarioLogado != null) {
        Navigator.of(context).pushNamed(NavegacaoHelper.rotaUsuarioLogado, arguments: {"usuario": usuarioLogado});
      } else {
        GeralHelper.instancia.exibirMensagem(context, "Erro ao realizar login", "Ocorreu um erro ao realizar o login");
      }
    } on SocialLoginException catch (e) {
      GeralHelper.instancia.exibirMensagem(context, "Erro ao realizar login", "Ocorreu um erro ao realizar o login. Detalhes: \n  CODIGO: ${e.codigoErro}\n  MENSAGEM: ${e.mensagemErro}");
    }

    setState(() {
      estaCarregando = false;
    });
  }

  void _emailPreenchidoCompleto() {
    _node.nextFocus();
  }

  void _senhaPreenchidaCompleta() {
    if (_senhaController.text.isNotEmpty) {
      _efetuarLogin();
    }
  }

  Widget _constroiEmail() {
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: "Email",
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

  Widget _constroiSenha() {
    return TextField(
      controller: _senhaController,
      decoration: InputDecoration(
        labelText: "Senha",
        //errorText: "Informe sua senha",
        enabled: !estaCarregando,
      ),
      obscureText: true,
      autocorrect: false,
      textInputAction: TextInputAction.done,
      keyboardAppearance: Brightness.light,
      onEditingComplete: _senhaPreenchidaCompleta,
    );
  }
}
