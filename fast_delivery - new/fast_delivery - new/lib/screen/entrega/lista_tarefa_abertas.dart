import 'package:fast_delivery/models/entrega_abertas.dart';
import 'package:fast_delivery/services/entrega_services.dart';
import 'package:flutter/material.dart';

class ListaEntregasAbertas extends StatefulWidget {
  final String caminhoFinal;

  const ListaEntregasAbertas({
    Key? key,
    required this.caminhoFinal,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ListaEntregasAbertasState createState() => _ListaEntregasAbertasState();
}

class _ListaEntregasAbertasState extends State<ListaEntregasAbertas> {
  List<EntregaAberta> entregasDisponiveis = [];

  ApiServiceEntrega apiServicesEntrega = ApiServiceEntrega();
  bool _isCarregando = true;
  String caminhoFinal = "";

  @override
  void initState() {
    super.initState();
    entregasDisponiveis = [];
    caminhoFinal = widget.caminhoFinal;
    carregarDados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh_outlined),
              onPressed: () {
                setState(() {
                  carregarDados();
                });
              }),
        ],
        backgroundColor: const Color.fromARGB(255, 30, 64, 120),
      ),
      body: _isCarregando
          ? carregamento()
          : Column(
              children: [
                Container(
                  padding: const EdgeInsetsDirectional.only(top: 20.0),
                  child: Text(
                    "Entregas Abertas ou em Rota - Total: ${entregasDisponiveis.length}\n",
                    style: const TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.bold),
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
        'Todas entregas realizadas',
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
                              "Status: ${entregasDisponiveis[index].statusEntrega}",
                              style: const TextStyle(fontSize: 14.0),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              "Data cadastro: ${entregasDisponiveis[index].dataCadastroEntrega!}",
                              style: const TextStyle(fontSize: 14.0),
                            ),
                          ),
                        ],
                      ),
                    ],
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


  carregarDados() async {
    entregasDisponiveis.clear();
    entregasDisponiveis =
        await apiServicesEntrega.getTodasEntregasAbertas(caminhoFinal);

    setState(() {
      _isCarregando = false;
    });
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
