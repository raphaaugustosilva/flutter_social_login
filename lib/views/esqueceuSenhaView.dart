import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_social_login/helper/geralHelper.dart';
import 'package:flutter_social_login/helper/navegacaoHelper.dart';
import 'package:flutter_social_login/helper/validators.dart';

class EsqueceuSenhaView extends StatefulWidget {
  @override
  _EsqueceuSenhaViewState createState() => _EsqueceuSenhaViewState();
}

class _EsqueceuSenhaViewState extends State<EsqueceuSenhaView> {
  final FocusScopeNode _node = FocusScopeNode();
  final TextEditingController _emailController = TextEditingController();
  final EmailESenhaValidadores _emailESenhaValidadores = EmailESenhaValidadores();
  bool isLoading = false;

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
              child: FocusScope(
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
                      child: Center(child: isLoading ? CircularProgressIndicator() : Text("Redefinir senha")),
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
    try {
      //final bool loginSucesso = await model.submit();
      bool loginSucesso = false;
      if (loginSucesso) {
        Navigator.of(context).pushNamed(NavegacaoHelper.rotaUsuarioLogado);
        //Navegar para página principal logada
        return;
      } else {
        GeralHelper.instancia.exibirMensagem(context, "Erro ao recuperar a senha", "Ocorreu um erro ao recuperar a senha");
      }
    } catch (e) {
      GeralHelper.instancia.exibirMensagem(context, "Erro ao recuperar a senha", "Ocorreu um erro ao recuperar a senha");
    }
  }

  void _emailPreenchidoCompleto() {
    
  }

  Widget _constroiEmail() {
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: "Digite o email para redefinir a senha",
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
  
}
