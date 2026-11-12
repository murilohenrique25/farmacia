import 'package:fast_delivery/screen/entrega_manipulacao/lista_tarefa_disponivel_manipulacao.dart';
import 'package:flutter/material.dart';

class HomeEntregasManipulacaoScreen extends StatefulWidget {
  final String caminhoFinal;
  final String user;
  final int manip;
  const HomeEntregasManipulacaoScreen(
      {Key? key,
      required this.user,
      required this.caminhoFinal,
      required this.manip})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeEntregasManipulacaoScreenState createState() =>
      _HomeEntregasManipulacaoScreenState();
}

class _HomeEntregasManipulacaoScreenState
    extends State<HomeEntregasManipulacaoScreen> {
  var caminhoFinal = "";
  var user = "";
  var manip = 0;
  @override
  void initState() {
    super.initState();
    caminhoFinal = widget.caminhoFinal;
    user = widget.user;
    manip = widget.manip;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ListaEntregasDisponiveisManipulacao(
                        caminhoFinal: caminhoFinal, user: user, nomeFarmacia: "Medalha Milagrosa",)));
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Container(
              decoration:
                  const BoxDecoration(color: Color.fromARGB(255, 30, 64, 120)),
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: Center(
                child: Text(
                  'Entregas Manipulação | $manip',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
