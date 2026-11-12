import 'package:date_format/date_format.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:fast_delivery/models/entrega.dart';
import 'package:fast_delivery/screen/home_entregas.dart';
import 'package:fast_delivery/services/entrega_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

class ListaEntregasSelecionadaManipulacao extends StatefulWidget {
  final String caminhoFinal;
  final String user;
  final String nomeFarmacia;
  const ListaEntregasSelecionadaManipulacao({
    Key? key,
    required this.caminhoFinal,
    required this.user,
    required this.nomeFarmacia,
  }) : super(key: key);

  @override
  _ListaEntregasSelecionadaManipulacaoState createState() =>
      _ListaEntregasSelecionadaManipulacaoState();
}

class _ListaEntregasSelecionadaManipulacaoState
    extends State<ListaEntregasSelecionadaManipulacao> {
  TextEditingController obsController = TextEditingController();
  String textoObs = "";
  ApiServiceEntrega apiServiceEntrega = ApiServiceEntrega();
  var location = Location();
  String lat = "";
  String long = "";

  late Entrega entrega;
  String selecionado = "";
  String user = "";
  String formatted = "";
  List<String> status = ["Entregue", "Não Entregue"];
  String caminhoFinal = "";
  String nomeFarmacia = "";

  @override
  void initState() {
    super.initState();
    caminhoFinal = widget.caminhoFinal;
    user = widget.user;
    nomeFarmacia = widget.nomeFarmacia;
  }

  Future<List<Entrega>> _carregarEntregas() async {
    await Future.delayed(const Duration(seconds: 2));
    var entregas =
        await apiServiceEntrega.getTodasEntregasEntregador(caminhoFinal, user);

    return entregas;
  }

  void chamarTelaEntregas() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DescriptionEntregas(
          caminhoFinal: caminhoFinal,
          user: user,
          carregarEntrega: true,
        ),
      ),
    );
  }

  void atualizarHorarioEntrega() {
    DateTime now = DateTime.now();
    formatted = formatDate(now, [HH, ':', nn]);
  }

  Future<void> finalizarPedido(Entrega entrega) async {
    final locationS = await location.getLocation();
    lat = locationS.latitude.toString();
    long = locationS.longitude.toString();

    await apiServiceEntrega.updateEntrega(
      caminhoFinal,
      entrega.idEntrega,
      entrega.observacao!,
      lat,
      long,
    );
  }

  Widget _entregasVazias() {
    return Container(
      padding: const EdgeInsets.only(top: 55),
      color: Colors.white,
      child: const Center(
        child: Text(
          'Você realizou todas entregas\nVolte a tela de seleção.\nOu recarrega a página',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Finalizar Entrega',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromARGB(255, 30, 64, 120),
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
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
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Cupom: ${entrega.cupomOrcamento}",
                              style: const TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const Divider(
                            color: Colors.black,
                            height: 2,
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Horário da Saída: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(entrega.dataCadastroEntrega!))}",
                              style: const TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const Divider(
                            color: Colors.black,
                            height: 2,
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Horário da Entrega: $formatted",
                              style: const TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const Divider(
                            color: Colors.black,
                            height: 2,
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Valor: ${valorExbido(entrega.valorTotal.toString())}",
                              style: const TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const Divider(
                            color: Colors.black,
                            height: 2,
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Troco: ${valorExbido(entrega.troco.toString())}",
                              style: const TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const Divider(
                            color: Colors.black,
                            height: 2,
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Form. Pgto: ${entrega.formaPagamento}",
                              style: const TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const Divider(
                            color: Colors.black,
                            height: 2,
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Observação: ${entrega.observacao ?? ''}",
                              style: const TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
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
                                color: Color.fromARGB(255, 30, 64, 120),
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
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
                              hintText: 'Informe o motivo',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Sair'),
            ),
            TextButton(
              child: const Text('Entregue'),
              onPressed: () {
                if (selecionado == "Não Entregue") {
                  textoObs = "Não Entregue - ${obsController.text}";
                }
                entrega.observacao = textoObs;
                finalizarPedido(entrega).then((_) {
                  setState(() {
                    _carregarEntregas();
                  });
                });
                Navigator.of(context).pop();
                selecionado = "";
                textoObs = "";
                setState(() {}); // Força a reconstrução do widget
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
        backgroundColor: const Color.fromARGB(255, 30, 64, 120),
        automaticallyImplyLeading: false,
        title: const Text("Entregas Selecionadas"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.reset_tv_rounded),
            onPressed: () {
              setState(() {
                chamarTelaEntregas();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Entrega>>(
        future: _carregarEntregas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Erro: ${snapshot.error}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return _entregasVazias();
            } else {
              print("oi");
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var entrega = snapshot.data![index];
                  return _exibirDados(context, entrega);
                },
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _exibirDados(BuildContext context, Entrega entrega) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
                          Text(
                            "Valor: ${valorExbido(entrega.valorTotal.toString())}",
                            style: const TextStyle(fontSize: 14.0),
                          ),
                          const Text(" - "),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            "Troco: ${valorExbido(entrega.troco.toString())}",
                            style: const TextStyle(fontSize: 14.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: () {
                      this.entrega = entrega;
                      atualizarHorarioEntrega();
                      _showMyDialog();
                    },
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 30, 64, 120),
                      ),
                      child: const Center(
                        child: Text(
                          "Entregar",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
