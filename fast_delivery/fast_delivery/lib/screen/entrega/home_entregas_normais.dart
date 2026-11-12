import 'package:fast_delivery/models/entrega.dart';
import 'package:fast_delivery/screen/entrega/lista_tarefa_disponivel_normal.dart';
import 'package:fast_delivery/screen/entrega/lista_tarefa_selecionada_normal.dart';
import 'package:fast_delivery/services/entrega_services.dart';
import 'package:flutter/material.dart';

class HomeEntregasNormaisScreen extends StatefulWidget {
  final String caminhoFinal;
  final String user;
  final int quant;
  const HomeEntregasNormaisScreen(
      {Key? key,
      required this.caminhoFinal,
      required this.user,
      required this.quant})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeEntregasNormaisScreenState createState() =>
      _HomeEntregasNormaisScreenState();
}

class _HomeEntregasNormaisScreenState extends State<HomeEntregasNormaisScreen> {
  var caminhoFinal = "";
  var user = "";
  var nomeFarmacia = "";
  var numeroFarmacia = 0;
  var quant = 0;
   ApiServiceEntrega apiServicesEntrega = ApiServiceEntrega();

  @override
  void initState() {
    super.initState();
    caminhoFinal = widget.caminhoFinal;
    user = widget.user;
    quant = widget.quant;
    nomeFarmacia = "Centro - Praça Guadencio Rincon | $quant";
    verificaEntregasNaoVazias();
  }

   verificaEntregasNaoVazias() async {
    List<Entrega> entregas =
        await apiServicesEntrega.getTodasEntregasEntregador(caminhoFinal, user);

    if (entregas.isNotEmpty) {
      chamarTelaSelecionadas();
    }
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ListaEntregasDisponiveisNormal(
                        caminhoFinal: caminhoFinal,
                        user: user,
                        numeroFarmacia: numeroFarmacia,
                        nomeFarmacia: nomeFarmacia)));
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Container(
              decoration:
                  const BoxDecoration(color: Color.fromARGB(255, 76, 192, 136)),
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: Center(
                child: Text(
                  "Entregas $nomeFarmacia",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
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

          // ClipRRect(
          //   borderRadius: BorderRadius.circular(15.0),
          //   child: Stack(
          //     alignment: Alignment.center,
          //     children: [
          //       Image.asset(
          //         "assets/images/medicamento.jpg",
          //         height: 150.0,
          //         width: 150.0,
          //         color: const Color.fromRGBO(255, 255, 255, 0.7),
          //         colorBlendMode: BlendMode.modulate,
          //       ),
          //       SizedBox(
          //         height: 40.0,
          //         child: Row(
          //           children: [
          //             Text(
          //               textAlign: TextAlign.center,
          //               textImpressao,
          //               style: const TextStyle(
          //                 color: Colors.black,
          //                 fontSize: 16.5,
          //                 letterSpacing: 1.0,
          //                 fontWeight: FontWeight.bold,
          //               ),
          //             )
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),