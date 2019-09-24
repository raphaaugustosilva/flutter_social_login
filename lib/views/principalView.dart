import 'dart:convert';
import 'package:flutter_social_login/model/usuario.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_social_login/helper/navegacaoHelper.dart';

class PrincipalView extends StatefulWidget {
  @override
  _PrincipalViewState createState() => _PrincipalViewState();
}

class _PrincipalViewState extends State<PrincipalView> {
  bool isLoading = false;

  static const Key googleButtonKey = Key('google');
  static const Key facebookButtonKey = Key('facebook');
  static const Key emailPasswordButtonKey = Key('email-password');
  static const Key anonymousButtonKey = Key('anonymous');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text("Flutter Social Login"),
        centerTitle: true,
      ),
      // Hide developer menu while loading in progress.
      // This is so that it's not possible to switch auth service while a request is in progress
      backgroundColor: Colors.grey[200],
      body: _constroiTelaPrincipal(context),
    );
  }

  Widget _constroiTelaPrincipal(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 50.0,
            child: isLoading ? Center(child: CircularProgressIndicator()) : Text("Login", textAlign: TextAlign.center, style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w600)),
          ),
          SizedBox(height: 48.0),
          RaisedButton.icon(
            key: googleButtonKey,
            icon: Image.asset("assets/googleLogo.png"),
            label: Padding(padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15), child: Text("Login com o Google")),
            //onPressed: isLoading ? null : () => _signInWithGoogle(context),
            onPressed: () {},
            color: Colors.white,
          ),
          SizedBox(height: 15),
          RaisedButton.icon(
            key: facebookButtonKey,
            icon: Image.asset("assets/facebookLogo.png"),
            label: Padding(padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15), child: Text("Login com o Facebook")),
            textColor: Colors.white,
            //onPressed: isLoading ? null : () => _signInWithFacebook(context),
            onPressed: () async {
              //var facebookLoginResult = await facebookLogin.logInWithReadPermissions(['email']);
              var facebookLogin = FacebookLogin();
              var facebookLoginResult = await facebookLogin.logIn(['email']);

              switch (facebookLoginResult.status) {
                case FacebookLoginStatus.error:
                  //onLoginStatusChanged(false);
                  break;
                case FacebookLoginStatus.cancelledByUser:
                  //onLoginStatusChanged(false);
                  break;
                case FacebookLoginStatus.loggedIn:
                  var graphResponse = await http.get('https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.width(400)&access_token=${facebookLoginResult.accessToken.token}');

                  var profile = json.decode(graphResponse.body);
                  print(profile.toString());

                  String id = profile['id'];
                  String nome = profile['name'];
                  String email = profile['email'];
                  String urlFoto = profile['picture']['data']['url'];
                  
                  Usuario usuarioLogado = Usuario(uid: id, nome: nome, email: email, urlFoto: urlFoto);

                  Navigator.of(context).pushNamed(NavegacaoHelper.rotaUsuarioLogado, arguments: {"usuarioLogado" : usuarioLogado});

                  //onLoginStatusChanged(true, profileData: profile);
                  break;
              }
            },
            color: Color(0xFF334D92),
          ),
          SizedBox(height: 15),
          RaisedButton.icon(
            key: emailPasswordButtonKey,
            icon: Icon(Icons.email),
            label: Padding(padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15), child: Text("Login com usuário a senha")),
            onPressed: isLoading
                ? null
                : () {
                    Navigator.of(context).pushNamed(NavegacaoHelper.rotaLogin);
                  },
            textColor: Colors.white,
            color: Colors.teal[700],
          ),
          SizedBox(height: 15),
          Text(
            "ou",
            style: TextStyle(fontSize: 14.0, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15),
          RaisedButton(
            key: anonymousButtonKey,
            child: Padding(padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15), child: Text("Login anônimo")),
            color: Colors.lime[300],
            textColor: Colors.black87,
            //onPressed: isLoading ? null : () => _signInAnonymously(context),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
