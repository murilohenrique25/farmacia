import 'package:fast_delivery/screen/homepage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          iconTheme:
              IconThemeData(color: Colors.white), // Ícones do AppBar em branco
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          backgroundColor: Colors.blue, // Cor de fundo do AppBar
        ),
        iconTheme:
            const IconThemeData(color: Colors.white), // Ícones padrão em branco
      ),
      initialRoute: '/',
      routes: {
        '/tela_login': (context) => const HomePage(),
      },
      home: const HomePage(),
    );
  }
}
