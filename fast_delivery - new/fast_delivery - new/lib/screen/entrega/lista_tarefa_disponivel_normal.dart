import 'package:fast_delivery/models/entrega.dart';
import 'package:fast_delivery/screen/entrega/lista_tarefa_selecionada_normal.dart';
import 'package:fast_delivery/screen/homepage.dart';
import 'package:fast_delivery/services/entrega_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListaEntregasDisponiveisNormal extends StatefulWidget {
  final String caminhoFinal;
  final String user;
  final String nomeFarmacia;

  const ListaEntregasDisponiveisNormal({
    Key? key,
    required this.caminhoFinal,
    required this.user,
    required this.nomeFarmacia,
  }) : super(key: key);

  @override
  _ListaEntregasDisponiveisNormalState createState() =>
      _ListaEntregasDisponiveisNormalState();
}

class _ListaEntregasDisponiveisNormalState
    extends State<ListaEntregasDisponiveisNormal> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Set<Entrega> entregasSelecionadas = {};
  ApiServiceEntrega apiServicesEntrega = ApiServiceEntrega();
  String user = "";
  String caminhoFinal = "";
  String nomeFarmacia = "";

  @override
  void initState() {
    super.initState();
    user = widget.user;
    caminhoFinal = widget.caminhoFinal;
    nomeFarmacia = widget.nomeFarmacia;
  }

  Future<List<Entrega>> _carregarEntregas() async {
    List<Entrega> entregasDisponiveisRecebidos =
        await apiServicesEntrega.getTodasEntregas(caminhoFinal, user);
    return entregasDisponiveisRecebidos
        .where((en) => en.tipoEntrega != 'Manipulação')
        .toList();
  }

  Future<void> _showMyDialogLogout() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
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
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Deseja Sair?',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Não',
                style: TextStyle(
                  color: Color.fromARGB(233, 240, 16, 8),
                  fontWeight: FontWeight.bold,
                ),
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
                  fontWeight: FontWeight.bold,
                ),
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
              finalizarSelecao();
            },
            icon: const Icon(Icons.add_task_sharp),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 30, 64, 120),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 110,
              decoration:
                  const BoxDecoration(color: Color.fromARGB(255, 30, 64, 120)),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
                    child: Text(
                      'Seja bem vindo',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
                    child: Text(
                      user,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text("Deslogar"),
              onTap: () {
                _showMyDialogLogout();
              },
            ),
            const ListTile(
              leading: Icon(Icons.verified),
              title: Text("Versão 1.7 - r"),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Entrega>>(
        future: _carregarEntregas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _carregamento();
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erro: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _entregasVazias();
          } else {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsetsDirectional.only(top: 20.0),
                  child: const Text(
                    "Entregas Disponíveis\n",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(10.0),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return _exibirDados(
                          context, snapshot.data![index], index);
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _carregamento() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Image.asset(
          "assets/images/carregando.gif",
          height: 300.0,
          width: 300.0,
        ),
      ),
    );
  }

  Widget _entregasVazias() {
    return Container(
      padding: const EdgeInsets.only(top: 55),
      color: Colors.white,
      child: const Center(
        child: Text(
          'Não existe Entregas Disponíveis',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _exibirDados(BuildContext context, Entrega entrega, int index) {
    bool isSelecionada = entregasSelecionadas.contains(entrega);

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
                            "Cupom: ${entrega.cupomOrcamento}",
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
                            "Hora inclusão: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(entrega.dataCadastroEntrega!))} ",
                            style: const TextStyle(fontSize: 14.0),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Valor: ${_valorExibido(entrega.valorTotal.toString())}",
                          style: const TextStyle(fontSize: 14.0),
                        ),
                        const Text(" - "),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Troco: ${_valorExibido(entrega.troco.toString())}",
                          style: const TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if ((entrega.observacao ?? '').isNotEmpty)
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Column(
                      children: [
                        const Text(""),
                        IconButton(
                          onPressed: () {
                            _visualizarObservacao(entrega.observacao!);
                          },
                          icon: const Icon(Icons.document_scanner_sharp),
                        ),
                      ],
                    ),
                  ),
                ),
              Expanded(
                flex: 3,
                child: Center(
                  child: Column(
                    children: [
                      Text(isSelecionada ? "Selecionado" : "Selecionar"),
                      Checkbox(
                        value: isSelecionada,
                        onChanged: (valor) {
                          setState(() {
                            if (valor == true) {
                              entregasSelecionadas.add(entrega);
                            } else {
                              entregasSelecionadas.remove(entrega);
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        // _showOptions(context, index);
      },
    );
  }

  void _visualizarObservacao(String texto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Observação"),
          content: Text(texto),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("Fechar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void atualizaEntregas(DateTime hora) {
    for (var element in entregasSelecionadas) {
      element.dataSelecaoEntrega = hora.toIso8601String();
    }
    apiServicesEntrega.updateEntregaEntregador(
        entregasSelecionadas, user, caminhoFinal);

    _chamarTelaSelecionadas();
  }

  void deslogar() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("pass", "");
    prefs.setString("user", "");
  }

  void _chamarTelaSelecionadas() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ListaEntregasSelecionadaNormal(
          caminhoFinal: caminhoFinal,
          user: user,
          nomeFarmacia: nomeFarmacia,
        ),
      ),
    );
  }

  void finalizarSelecao() {
    if (entregasSelecionadas.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Aviso"),
            content: const Text("Nenhuma entrega foi selecionada!"),
            actions: <Widget>[
              ElevatedButton(
                child: const Text("Fechar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      atualizaEntregas(DateTime.now());
    }
  }

  String _valorExibido(String valor) {
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
