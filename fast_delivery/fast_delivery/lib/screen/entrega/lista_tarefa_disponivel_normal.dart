import 'package:fast_delivery/models/entrega.dart';
import 'package:fast_delivery/screen/homepage.dart';
import 'package:fast_delivery/screen/entrega/lista_tarefa_selecionada_normal.dart';
import 'package:fast_delivery/services/entrega_services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListaEntregasDisponiveisNormal extends StatefulWidget {
  final String caminhoFinal;
  final String user;
  final int numeroFarmacia;
  final String nomeFarmacia;

  const ListaEntregasDisponiveisNormal(
      {Key? key,
      required this.caminhoFinal,
      required this.user,
      required this.numeroFarmacia,
      required this.nomeFarmacia})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ListaEntregasDisponiveisNormalState createState() =>
      _ListaEntregasDisponiveisNormalState();
}

class _ListaEntregasDisponiveisNormalState
    extends State<ListaEntregasDisponiveisNormal> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<Entrega> entregasDisponiveis = [];
  List<Entrega> entregasDisponiveisRecebidos = [];
  List<Entrega> entregasSelecionadas = [];
  String user = "";
  String userAdministrador = "";
  String desejaSair = "Deseja Sair?";
  ApiServiceEntrega apiServicesEntrega = ApiServiceEntrega();
  bool _isCarregando = true;
  String caminhoFinal = "";
  int numeroFarmacia = 0;
  String nomeFarmacia = "";
  int quantidadeEntregasFarmacia = 0;
  @override
  void initState() {
    super.initState();
    entregasDisponiveis = [];
    entregasDisponiveisRecebidos = [];
    user = widget.user;
    caminhoFinal = widget.caminhoFinal;
    numeroFarmacia = widget.numeroFarmacia;
    nomeFarmacia = widget.nomeFarmacia;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  finalizarSelecao();
                });
              },
              icon: const Icon(Icons.add_task_sharp)),
          IconButton(
              icon: const Icon(Icons.refresh_outlined),
              onPressed: () {
                setState(() {
                  carregarDados();
                });
              }),
        ],
        backgroundColor: const Color.fromARGB(233, 118, 213, 203),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 110,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(233, 118, 213, 203)),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
                    child: Text(
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      'Seja bem vindo',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
                    child: Text(style: const TextStyle(fontSize: 16), user),
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
          : Column(
              children: [
                Container(
                  padding: const EdgeInsetsDirectional.only(top: 20.0),
                  child: const Text(
                    "Entregas Disponíveis\n",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
                entregasDisponiveis.isEmpty
                    ? entregasVazias()
                    : Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(10.0),
                            itemCount: entregasDisponiveis.length,
                            itemBuilder: (context, index) {
                              return _exibirDados(context, index);
                            }),
                      )
              ],
            ),
    );
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

  Widget entregasVazias() {
    return Container(
      padding: const EdgeInsets.only(top: 55),
      color: Colors.white,
      child: const Center(
          child: Text(
        'Não existe Entegras Disponíveis',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      )),
    );
  }

  Widget _exibirDados(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  flex: 7,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              "Cupom: ${entregasDisponiveis[index].cupomOrcamento}",
                              style: const TextStyle(fontSize: 14.0),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              "Farmácia: $nomeFarmacia",
                              style: const TextStyle(fontSize: 14.0),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              "Hora inclusão: ${entregasDisponiveis[index].dataCadastroEntrega}",
                              style: const TextStyle(fontSize: 14.0),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Valor: ${valorExbido(entregasDisponiveis[index].valorTotal.toString())}",
                            style: const TextStyle(fontSize: 14.0),
                          ),
                          const Text(" - "),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            "Troco: ${valorExbido(entregasDisponiveis[index].troco.toString())}",
                            style: const TextStyle(fontSize: 14.0),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                if ((entregasDisponiveis[index].observacao ?? '').isNotEmpty)
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Column(
                        children: [
                          const Text(""),
                          IconButton(
                              onPressed: () {
                                visualizarObser(
                                    entregasDisponiveis[index].observacao!);
                              },
                              icon: const Icon(Icons.document_scanner_sharp)),
                        ],
                      ),
                    ),
                  ),
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Column(
                      children: [
                        Text(entregasDisponiveis[index].selecionado == false ||
                                entregasDisponiveis[index].selecionado == null
                            ? "Selecionar"
                            : "Selecionado"),
                        Checkbox(
                          value:
                              entregasDisponiveis[index].selecionado ?? false,
                          onChanged: (valor) {
                            setState(() {
                              entregasDisponiveis[index].selecionado = valor;
                              if (valor == true) {
                                entregasSelecionadas
                                    .add(entregasDisponiveis[index]);
                              } else {
                                entregasSelecionadas
                                    .remove(entregasDisponiveis[index]);
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
      onTap: () {
        // _showOptions(context, index);
      },
    );
  }

  visualizarObser(String texto) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // retorna um objeto do tipo Dialog
          return AlertDialog(
            title: const Text("Observação"),
            content: Text(texto),
            actions: <Widget>[
              // define os botões na base do dialogo
              ElevatedButton(
                child: const Text("Fechar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  atualizarHorarioEntrega() {
    return DateTime.now();
  }

  atualizaEntregas(DateTime hora) {
    user = widget.user;
    for (var element in entregasSelecionadas) {
      element.dataSelecaoEntrega = hora.toIso8601String();
    }
    apiServicesEntrega.updateEntregaEntregador(
        entregasSelecionadas, user, caminhoFinal);

    chamarTelaSelecionadas();
  }

  carregarDados() async {
    entregasDisponiveisRecebidos =
        await apiServicesEntrega.getTodasEntregas(caminhoFinal);

    setState(() {
      entregasDisponiveis.clear();
      for (Entrega en in entregasDisponiveisRecebidos) {
        entregasDisponiveis.add(en);
      }
      entregasDisponiveis = entregasDisponiveis;
      _isCarregando = false;
    });
  }

  deslogar() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setString("pass", "");
      prefs.setString("user", "");
    });
  }

  chamarTelaSelecionadas() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => ListaEntregasSelecionadaNormal(
              caminhoFinal: caminhoFinal,
              user: user,
              nomeFarmacia: nomeFarmacia)),
    );
  }

  finalizarSelecao() {
    if (entregasSelecionadas.isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            // retorna um objeto do tipo Dialog
            return AlertDialog(
              title: const Text("Aviso"),
              content: const Text("Nenhuma entrega foi selecionada!"),
              actions: <Widget>[
                // define os botões na base do dialogo
                ElevatedButton(
                  child: const Text("Fechar"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    } else {
      atualizaEntregas(atualizarHorarioEntrega());
    }
  }

  String valorExbido(String valor) {
    bool val = valor.contains('.');

    if (valor == '0') {
      return '0,00';
    } else if (!val) {
      return '$valor,00';
    } else {
      String valCom = valor.substring(valor.length - 3);
      if (valCom.contains('.')) {
        if (valCom[1] == '.') {
          return '${valor}0'.replaceAll('.', ',');
        }
        return valor.replaceAll('.', ',');
      } else {
        return '$valor+0'.replaceAll('.', ',');
      }
    }
  }
}
