import 'package:fast_delivery/screen/servicos/lista_servicos.dart';
import 'package:flutter/material.dart';

class ServicosScreen extends StatefulWidget {
  final String caminhoFinal;
  final String user;
  const ServicosScreen(
      {Key? key, required this.caminhoFinal, required this.user})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ServicosScreenState createState() => _ServicosScreenState();
}

class _ServicosScreenState extends State<ServicosScreen> {
  var caminhoFinal = "";
  var user = "";

  @override
  void initState() {
    super.initState();
    caminhoFinal = widget.caminhoFinal;
    user = widget.user;
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
                    builder: (context) =>
                        ListaServicos(caminhoFinal: caminhoFinal, user: user)));
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Container(
              decoration:
                  const BoxDecoration(color: Color.fromARGB(255, 30, 64, 120)),
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: const Center(
                child: Text(
                  "Criar Serviços",
                  style: TextStyle(
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
