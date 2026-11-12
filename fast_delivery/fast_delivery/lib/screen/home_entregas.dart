import 'package:fast_delivery/models/entrega.dart';
import 'package:fast_delivery/models/tempo_entrega.dart';
import 'package:fast_delivery/screen/entrega/home_entregas_normais.dart';
import 'package:fast_delivery/screen/homepage.dart';
import 'package:fast_delivery/screen/servicos/home_servicos.dart';
import 'package:fast_delivery/services/entrega_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class DescriptionEntregas extends StatefulWidget {
  final String user;
  final String caminhoFinal;
  final bool carregarEntrega;
  const DescriptionEntregas(
      {Key? key,
      required this.user,
      required this.caminhoFinal,
      required this.carregarEntrega})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DescriptionEntregasState createState() => _DescriptionEntregasState();
}

class _DescriptionEntregasState extends State<DescriptionEntregas> {
  final double _height = 130.0;
  final double _width = 80.0;
  var caminhoFinal = "";
  var user = "";
  TempoEntrega tempoEntrega = TempoEntrega();
  int quantidadeEntregas = 0;
  bool _isCarregando = true;
  String desejaSair = "Deseja Sair?";
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  ApiServiceEntrega api = ApiServiceEntrega();
  @override
  void initState() {
    super.initState();
    caminhoFinal = widget.caminhoFinal;
    user = widget.user;
    carregarQuantidadeEntrega();
    verificaQuantidade();
  }

  Widget carregamento() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Image.asset("assets/images/carregando.gif",
            height: 300.0, width: 300.0),
      ),
    );
  }

  verificaQuantidade() async {
    tempoEntrega =
        await api.quantidadeEntregaFinalizadasPorMes(caminhoFinal, user);

    setState(() {
      tempoEntrega;
    });
  }

  carregarQuantidadeEntrega() async {
    List<Entrega> entregas = await api.getTodasEntregas(caminhoFinal);
    setState(() {
      quantidadeEntregas = entregas.length;
      _isCarregando = false;
    });
  }

  deslogar() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.clear();
  }

  Future<void> _showMyDialogLogout() async {
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
                          child: Text(
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                              desejaSair),
                        )),
                  ],
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Não',
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
                'Sim',
                style: TextStyle(
                    color: Color.fromARGB(233, 7, 197, 39),
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                deslogar();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMyDialogQuantidadeEntregas() async {
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
                    Column(
                      children: [
                        Center(
                          child: Text(
                              style: const TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                              "Entregas realizadas no mês de ${verificaMes()}:\n ${tempoEntrega.quantidadeEntrega} \nCom tempo médio de ${tempoEntrega.mediaTotal}"),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Center(
                            child: Text(
                          "Informamos que a contagem é zerada após iniciar novo mês",
                          style: TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'ok',
                style: TextStyle(
                    color: Color.fromARGB(233, 7, 197, 39),
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestão de Entregas"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(233, 118, 213, 203),
        actions: [
          IconButton(
              onPressed: () {
                verificaQuantidade();
                _showMyDialogQuantidadeEntregas();
              },
              icon: const Icon(Icons.add_chart_sharp))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 110,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(233, 118, 213, 203)),
              child: const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
                    child: Text(
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      'Seja bem vindo',
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
                leading: const Icon(Icons.close),
                title: const Text(
                  "Deslogar",
                ),
                onTap: () {
                  _showMyDialogLogout();
                }),
            const ListTile(
              leading: Icon(Icons.verified),
              title: Text(
                "Versão 2.5 - n",
              ),
            ),
          ],
        ),
      ),
      body: _isCarregando
          ? carregamento()
          : SingleChildScrollView(
              child: Padding(
              padding: const EdgeInsets.only(top: 35),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /*Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: _width,
                            height: _height,
                            color: Colors.grey[50],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: HomeEntregasManipulacaoScreen(
                                caminhoFinal: caminhoFinal,
                                user: user,
                                manip: manip),
                          ),
                        ],
                      ),*/
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: _width,
                            height: _height,
                            color: Colors.grey[50],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: HomeEntregasNormaisScreen(
                              caminhoFinal: caminhoFinal,
                              user: user,
                              quant: quantidadeEntregas,
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: _width,
                            height: _height,
                            color: Colors.grey[50],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ServicosScreen(
                                caminhoFinal: caminhoFinal, user: user),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )),
    );
  }

  verificaMes() {
    initializeDateFormatting('pt_BR', null);
    DateTime now = DateTime.now();
    String formattedMonth = DateFormat('MMMM', 'pt_BR').format(now);

    return formattedMonth;
  }
}
