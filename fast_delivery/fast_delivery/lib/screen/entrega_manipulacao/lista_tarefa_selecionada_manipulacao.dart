/*import 'package:date_format/date_format.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:fast_delivery/models/entrega.dart';
import 'package:fast_delivery/screen/home_entregas.dart';
import 'package:fast_delivery/services/entrega_services.dart';
import 'package:flutter/material.dart';

class ListaEntregasSelecionadaManipulacao extends StatefulWidget {
  final String caminhoFinal;
  final String user;
  const ListaEntregasSelecionadaManipulacao(
      {Key? key, required this.caminhoFinal, required this.user})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ListaEntregasSelecionadaManipulacaoState createState() =>
      _ListaEntregasSelecionadaManipulacaoState();
}

class _ListaEntregasSelecionadaManipulacaoState
    extends State<ListaEntregasSelecionadaManipulacao> {
  TextEditingController obsController = TextEditingController();
  String textoObs = "";
  List<Entrega> entregasSelecionadasEntregador = [];
  List<Entrega> entregasSelecionadasNormal = [];
  ApiServiceEntrega apiServiceEntrega = ApiServiceEntrega();
  late Entrega entrega;
  String selecionado = "";
  String user = "";
  int? val;
  String formatted = "";
  String saida = "";
  bool _isCarregando = true;
  bool temDados = true;
  List<String> status = ["Pedido Entregue", "Entrega não realizada"];
  String caminhoFinal = "";

  @override
  void initState() {
    super.initState();
    caminhoFinal = widget.caminhoFinal;
    user = widget.user;
    entregasSelecionadasEntregador.clear();
    entregasSelecionadasNormal.clear();
    carregaListaEntrega();
  }

  carregaListaEntrega() async {
    entregasSelecionadasNormal.clear();
    entregasSelecionadasNormal =
        await apiServiceEntrega.getTodasEntregasEntregador(caminhoFinal, user);

    setState(() {
      entregasSelecionadasEntregador.clear();
      for (Entrega en in entregasSelecionadasNormal) {
        if (en.manipulacao == "MANIPULACAO") {
          entregasSelecionadasEntregador.add(en);
        }
      }
      entregasSelecionadasEntregador = entregasSelecionadasEntregador;
      _isCarregando = false;
      if (entregasSelecionadasEntregador.isNotEmpty) {
        temDados = false;
      } else {
        temDados = true;
      }
    });
  }

  chamarTelaEntregas() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DescriptionEntregas(
                caminhoFinal: caminhoFinal,
                user: user,
                carregarEntrega: true,
              )),
    );
  }

  verificaEntregaRealizada(Entrega entrega) {
    setState(() {
      entregasSelecionadasEntregador.remove(entrega);
      _isCarregando = false;
    });
  }

  atualizarHorarioEntrega() {
    DateTime now = DateTime.now();
    formatted = formatDate(now, [HH, ':', nn]);
  }

  finalizarPedido(Entrega entrega) async {
    setState(() {
      _isCarregando = true;
    });

    await apiServiceEntrega.updateEntrega(caminhoFinal, entrega.idEntrega!,
        formatted, textoObs, entrega.idEntrega.toString());
    carregaListaEntrega();
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
        'Você realizou todas entregas\nVolte a tela de seleção.',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      )),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Finalizar Entrega',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color.fromARGB(233, 118, 213, 203),
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.all(2),
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
                            child: Text(
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w700),
                                "Cupom: ${entrega.cupomOrcamento}"),
                          ),
                          const Divider(
                            color: Colors.black,
                            height: 2,
                          ),
                          const Divider(
                            color: Colors.black,
                            height: 2,
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                style: const TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w700),
                                "Tipo: ${entrega.manipulacao}"),
                          ),
                          const Divider(
                            color: Colors.black,
                            height: 2,
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w700),
                                "Horário da Saída: ${entrega.dataAssinaturaEntrega}"),
                          ),
                          const Divider(
                            color: Colors.black,
                            height: 2,
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w700),
                                "Horário da Entrega: $formatted"),
                          ),
                          const Divider(
                            color: Colors.black,
                            height: 2,
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w700),
                                "Valor: ${valorExbido(entrega.valorTotal.toString())}"),
                          ),
                          const Divider(
                            color: Colors.black,
                            height: 2,
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w700),
                                "Troco: ${valorExbido(entrega.troco.toString())}"),
                          ),
                          const Divider(
                            color: Colors.black,
                            height: 2,
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w700),
                                "Form. Pgto: ${entrega.formaPagamento}"),
                          ),
                          const Divider(
                            color: Colors.black,
                            height: 2,
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w700),
                                "Observação: ${entrega.observacao}"),
                          ),
                          const Divider(
                            color: Colors.black,
                            height: 2,
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(10, 15, 5, 3),
                            child: Text(
                              "Situação Pedido: ",
                              style: TextStyle(
                                  color: Color.fromARGB(233, 118, 213, 203),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          DropdownSearch<String>(
                            popupProps: const PopupProps.menu(
                              showSelectedItems: true,
                            ),
                            items: status,
                            dropdownDecoratorProps:
                                const DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                labelText: "Situação",
                                hintText: "Selecione uma situação",
                              ),
                            ),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  selecionado = value;
                                  textoObs = value;
                                });
                              }
                            },
                            selectedItem: selecionado,
                          ),
                          TextField(
                            controller: obsController,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Informe o motivo'),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Entregue'),
              onPressed: () {
                if (selecionado == "Entrega não realizada" &&
                    (obsController.text.isEmpty || obsController.text == "")) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("É necessário informar o campo motivo!")));
                } else {
                  if (selecionado == "Entrega não realizada") {
                    textoObs = "NAO ENTREGUE - ${obsController.text}";
                  }
                  finalizarPedido(entrega);
                  Navigator.of(context).pop();
                }
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
        backgroundColor: const Color.fromARGB(233, 118, 213, 203),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              icon: const Icon(Icons.reset_tv_rounded),
              onPressed: () {
                setState(() {
                  buscarNovas();
                });
              }),
          IconButton(
              icon: const Icon(Icons.refresh_outlined),
              onPressed: () {
                setState(() {
                  _isCarregando = true;
                  carregaListaEntrega();
                });
              }),
        ],
      ),
      body: _isCarregando
          ? carregamento()
          : Column(
              children: [
                Container(
                  padding: const EdgeInsetsDirectional.only(top: 20.0),
                  child: const Text(
                    "Entregas Selecionadas",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
                temDados
                    ? entregasVazias()
                    : Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(10.0),
                            itemCount: entregasSelecionadasEntregador.length,
                            itemBuilder: (context, index) {
                              return _exibirDados(context, index);
                            }),
                      )
              ],
            ),
    );
  }

  buscarNovas() {
    if (entregasSelecionadasEntregador.isNotEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            // retorna um objeto do tipo Dialog
            return AlertDialog(
              title: const Text("Aviso"),
              content: const Text("Realize todas suas entregas."),
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
      chamarTelaEntregas();
    }
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
                              "Cupom: ${entregasSelecionadasEntregador[index].cupomOrcamento}",
                              style: const TextStyle(fontSize: 14.0),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              "Tipo: ${entregasSelecionadasEntregador[index].manipulacao}",
                              style: const TextStyle(fontSize: 14.0),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Valor: ${valorExbido(entregasSelecionadasEntregador[index].valorTotal.toString())}",
                            style: const TextStyle(fontSize: 14.0),
                          ),
                          const Text(" - "),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            "Troco: ${valorExbido(entregasSelecionadasEntregador[index].troco.toString())}",
                            style: const TextStyle(fontSize: 14.0),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: (() {
                      entrega = entregasSelecionadasEntregador[index];
                      atualizarHorarioEntrega();
                      _showMyDialog();
                    }),
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(233, 118, 213, 203)),
                      child: const Center(
                        child: Text(
                          "Entregar",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
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
*/
