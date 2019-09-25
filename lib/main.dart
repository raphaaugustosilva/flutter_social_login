import 'helper/navegacaoHelper.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Social Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: NavegacaoHelper.rotas(),
      onUnknownRoute: NavegacaoHelper.rotaNaoEncontrada(),
    );
  } 
}
