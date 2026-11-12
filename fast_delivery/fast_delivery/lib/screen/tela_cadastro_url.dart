import 'package:fast_delivery/screen/homepage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CadastroURLPage extends StatefulWidget {
  const CadastroURLPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CadastroURLPageState createState() => _CadastroURLPageState();
}

class _CadastroURLPageState extends State {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextEditingController url = TextEditingController();
  TextEditingController porta = TextEditingController();
  TextEditingController caminho = TextEditingController();
  String textBotao = "Salvar";
  String textValida = "Validar";
  String textValidado = "";
  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  carregarDados() async {
    final SharedPreferences prefs = await _prefs;
    url.text = prefs.getString("url") ?? "";
    caminho.text = prefs.getString("caminho") ?? "";
    porta.text = prefs.getString("porta") ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        widgetTextField(url, "Informe a url/host do servidor."),
        widgetTextField(porta, "Informe a porta do servidor."),
        widgetTextField(caminho, "Informe caminho do servidor."),
        Padding(
          padding: const EdgeInsets.only(top: 25, bottom: 25),
          child: Text(
            textValidado,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        ElevatedButton(
          child: Text(textValida),
          onPressed: () {
            atualizarCampo();
          },
        ),
        ElevatedButton(
            onPressed: () {
              salvarDados(caminho.text, porta.text, url.text);
            },
            child: Text(textBotao)),
      ]),
    );
  }

  void atualizarCampo() {
    setState(() {
      textValidado = "${url.text}:${porta.text}/${caminho.text}/";
    });
  }

  void salvarDados(String c, String p, String u) async {
    if (c.isEmpty || p.isEmpty || u.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Necessário informar todos os campos")));
    } else {
      final SharedPreferences prefs = await _prefs;
      setState(() {
        prefs.setString("caminho", c);
        prefs.setString("porta", p);
        prefs.setString("url", u);
      });
      chamarTela();
    }
  }

  chamarTela() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  widgetTextField(TextEditingController controller, String txt) {
    return Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: txt),
        ));
  }
}
