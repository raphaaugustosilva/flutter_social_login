import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_social_login/helper/geralHelper.dart';
import 'package:flutter_social_login/helper/navegacaoHelper.dart';
import 'package:flutter_social_login/helper/validators.dart';

class LoginUsuarioESenhaView extends StatefulWidget {
  @override
  _LoginUsuarioESenhaViewState createState() => _LoginUsuarioESenhaViewState();
}

class _LoginUsuarioESenhaViewState extends State<LoginUsuarioESenhaView> {
  final FocusScopeNode _node = FocusScopeNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final EmailESenhaValidadores _emailESenhaValidadores = EmailESenhaValidadores();
  bool isLoading = false;

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
                      child: Center(child: isLoading ? CircularProgressIndicator() : Text("Login")),
                      onPressed: () async {
                        await _efetuarLogin();
                      },
                    ),
                    SizedBox(height: 8.0),
                    FlatButton(
                        child: Text("Precisa de uma conta? Registre-se"),
                        onPressed: isLoading
                            ? null
                            : () {
                                Navigator.of(context).pushNamed(NavegacaoHelper.rotaCriarNovoUsuario);
                              }),
                    FlatButton(
                      child: Text("Esqueceu sua senha?"),
                      onPressed: isLoading
                          ? null
                          : () {
                              Navigator.of(context).pushNamed(NavegacaoHelper.rotaEsqueceuSenha);
                            },
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
    try {
      //final bool loginSucesso = await model.submit();
      bool loginSucesso = false;
      if (loginSucesso) {
        Navigator.of(context).pushNamed(NavegacaoHelper.rotaUsuarioLogado);
        //Navegar para página principal logada
        return;
      } else {
        GeralHelper.instancia.exibirMensagem(context, "Erro ao realizar login", "Ocorreu um erro ao realizar o login");
      }
    } catch (e) {
      GeralHelper.instancia.exibirMensagem(context, "Erro ao realizar login", "Ocorreu um erro ao realizar o login");
    }
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
        enabled: !isLoading,
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
        enabled: !isLoading,
      ),
      obscureText: true,
      autocorrect: false,
      textInputAction: TextInputAction.done,
      keyboardAppearance: Brightness.light,
      onEditingComplete: _senhaPreenchidaCompleta,
    );
  }
}
