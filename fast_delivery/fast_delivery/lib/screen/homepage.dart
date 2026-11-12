import 'package:fast_delivery/models/login.dart';
import 'package:fast_delivery/screen/home_entregas.dart';
import 'package:fast_delivery/screen/tela_cadastro_url.dart';
import 'package:fast_delivery/services/login_services.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _senhaAdminController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  ApiServicesLogin apiServiceLogin = ApiServicesLogin();
  bool esconderSenha = true;
  bool logando = false;
  final String url = "http://165.22.181.136";
  final String porta = "8080";
  String caminhoFinal = "";
  String user = "";
  String pass = "";
  @override
  void initState() {
    super.initState();
    var location = Location();
    location.hasPermission;
    verificaUsuarioLogado();
  }

  verificaUsuarioLogado() async {
    final SharedPreferences prefs = await _prefs;
    user = prefs.getString("user") ?? "";
    pass = prefs.getString("pass") ?? "";

    caminhoFinal = "$url:$porta";

    if ((user != "" || pass != "") && url.isNotEmpty) {
      chamarTela(user);
    }
  }

  deslogar() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.clear();
  }

  verificaSenha(String u, String p, BuildContext context) async {
    final SharedPreferences prefs = await _prefs;

    if (u.trim() != 'null' && u.trim() != "") {
      Login login = await apiServiceLogin.realizarLogin(caminhoFinal, u, p);
      String passAdministrador = 'excluirTodosDados';
      String userAdministrador = 'temos.permissao';

      if (login.erro == null) {
        setState(() {
          prefs.setString("user", u);
          prefs.setString("pass", p);
        });

        chamarTela(u);
      } else if (u == userAdministrador && p == passAdministrador) {
        prefs.setString("userAdministrador", userAdministrador);
        chamarTela(userAdministrador);
      } else {
        chamarScroll();
      }
    } else {
      chamarScroll();
    }
  }

  chamarTela(String u) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DescriptionEntregas(
              caminhoFinal: caminhoFinal, user: u, carregarEntrega: true)),
    );
  }

  chamarTelaURL() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CadastroURLPage()),
    );
  }

  void showPassword() {
    setState(() {
      esconderSenha = !esconderSenha;
    });
  }

  chamarScroll() {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Dados informados estão incorretos")));
    setState(() {
      logando = false;
    });
  }

  chamarScrollUrl() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Será necessário informar a URL do servidor")));
    setState(() {
      logando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 400,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/background.jpg'),
                        fit: BoxFit.fill)),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      right: 40,
                      top: 40,
                      width: 80,
                      height: 150,
                      child: Container(
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/clock.png'))),
                      ),
                    ),
                    Positioned(
                      child: Container(
                        margin: const EdgeInsets.only(top: 50),
                        child: const Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                                color: Color.fromRGBO(143, 148, 251, .2),
                                blurRadius: 20.0,
                                offset: Offset(0, 10))
                          ]),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.grey))),
                            child: TextField(
                              controller: _userController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Entre com seu usuário",
                                  hintStyle:
                                      TextStyle(color: Colors.grey[700])),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              obscureText: esconderSenha,
                              controller: _passController,
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: showPassword,
                                    icon: Icon(esconderSenha == true
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                  ),
                                  border: InputBorder.none,
                                  hintText: "Senha",
                                  hintStyle:
                                      TextStyle(color: Colors.grey[700])),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: (() {
                        verificaSenha(_userController.text,
                            _passController.text, context);
                      }),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(233, 2, 116, 104)),
                        child: Center(
                          child: Text(
                            logando == false ? "Login" : "Aguarde ...",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    GestureDetector(
                      onTap: (() {}),
                      child: const Center(
                        child: Text(
                          "Versão 2.5 - n",
                          style: TextStyle(
                              color: Color.fromARGB(233, 2, 116, 104),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }

  void verificaSenhaAdmin() async {
    if (_senhaAdminController.text == "2022testeDM") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CadastroURLPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text("Você não tem permissão para alterar/cadastrar host.")));
    }
  }

  Future<void> showMyDialogAdmin() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromRGBO(143, 148, 251, .2),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 10))
                            ]),
                        child: Center(
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: TextField(
                                  controller: _senhaAdminController,
                                  decoration: const InputDecoration(
                                      hintText:
                                          'Informe a senha de administrador!'),
                                )))),
                  ],
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Sair',
                style: TextStyle(
                    color: Color.fromARGB(233, 240, 16, 8),
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Logar',
                style: TextStyle(
                    color: Color.fromARGB(233, 7, 197, 39),
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                verificaSenhaAdmin();
              },
            ),
          ],
        );
      },
    );
  }
}
