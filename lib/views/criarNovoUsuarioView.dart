import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_social_login/model/usuario.dart';
import 'package:flutter_social_login/helper/validators.dart';
import 'package:flutter_social_login/helper/geralHelper.dart';
import 'package:flutter_social_login/helper/navegacaoHelper.dart';
import 'package:flutter_social_login/model/socialLoginException.dart';
import 'package:flutter_social_login/services/autenticacaoService.dart';
import 'package:flutter_social_login/services/autenticacaoFirebaseService.dart';

class CriarNovoUsuarioView extends StatefulWidget {
  @override
  _CriarNovoUsuarioViewState createState() => _CriarNovoUsuarioViewState();
}

class _CriarNovoUsuarioViewState extends State<CriarNovoUsuarioView> {
  final FocusScopeNode _node = FocusScopeNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final EmailESenhaValidadores _emailESenhaValidadores = EmailESenhaValidadores();

  final AutenticacaoService autenticacaoService = AutenticacaoFirebaseService();
  bool estaCarregando = false;

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
        title: Text("Criar Usuário"),
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
                          _constroiNome(),
                          _constroiEmail(),
                          _constroiSenha(),
                          SizedBox(height: 8.0),
                          FlatButton(
                            color: Colors.red,
                            textColor: Colors.white,
                            child: Center(child: estaCarregando ? CircularProgressIndicator() : Text("Criar Usuário")),
                            onPressed: () async {
                              await _criarUsuario();
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

  Future<void> _criarUsuario() async {
    setState(() {
      estaCarregando = true;
    });

    try {
      final Usuario usuarioCriado = await autenticacaoService.criarUsuario(_emailController.text, _senhaController.text, nome: _nomeController.text);
      if (usuarioCriado != null) {
        Navigator.of(context).pushNamed(NavegacaoHelper.rotaUsuarioLogado, arguments: {"usuario": usuarioCriado});
      } else {
        GeralHelper.instancia.exibirMensagem(context, "Erro ao criar usuário", "Ocorreu um erro ao criar o usuário");
      }
    } on SocialLoginException catch (e) {
      GeralHelper.instancia.exibirMensagem(context, "Erro ao criar usuário", "Ocorreu um erro ao criar o usuário. Detalhes: \n  CODIGO: ${e.codigoErro}\n  MENSAGEM: ${e.mensagemErro}");
    }

    setState(() {
      estaCarregando = false;
    });
  }

  void _nomePreenchidoCompleto() {
    _node.nextFocus();
  }

  void _emailPreenchidoCompleto() {
    _node.nextFocus();
  }

  void _senhaPreenchidaCompleta() {
    if (_senhaController.text.isNotEmpty) {
      _criarUsuario();
    }
  }

  Widget _constroiNome() {
    return TextField(
      controller: _nomeController,
      decoration: InputDecoration(
        labelText: "Nome",
        hintText: "Raphael Augusto da Silva",
        enabled: !estaCarregando,
      ),
      autocorrect: false,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      keyboardAppearance: Brightness.light,
      onEditingComplete: _nomePreenchidoCompleto,
    );
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
