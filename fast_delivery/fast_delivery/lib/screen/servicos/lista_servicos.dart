import 'package:date_format/date_format.dart';
import 'package:fast_delivery/models/entrega_avulsa.dart';
import 'package:fast_delivery/screen/home_entregas.dart';
import 'package:fast_delivery/services/entrega_services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListaServicos extends StatefulWidget {
  final String caminhoFinal;
  final String user;

  const ListaServicos({
    Key? key,
    required this.caminhoFinal,
    required this.user,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ListaServicosState createState() => _ListaServicosState();
}

class _ListaServicosState extends State<ListaServicos> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final TextEditingController descricaoController = TextEditingController();
  String dataInicio = '';
  String horaInicio = '';
  final TextEditingController observacaoController = TextEditingController();
  final List<String> farmacias = ['Praça Gaudencia Rincon'];
  ApiServiceEntrega apiServicesEntrega = ApiServiceEntrega();

  String farmacia = '';
  String user = "";
  String userAdministrador = "";
  String desejaSair = "Deseja Sair?";
  String caminhoFinal = "";
  String horaFinal = "";

  @override
  void initState() {
    super.initState();
    user = widget.user;
    caminhoFinal = widget.caminhoFinal;
    verificaSeExisteServico();
  }

  verificaSeExisteServico() async {
    final SharedPreferences prefs = await _prefs;
    if (!prefs.containsKey("horaInicioServico") ||
        prefs.getString("horaInicioServico") == "") {
      setState(() {
        horaInicio = atualizarHorarioEntrega();
        dataInicio = atualizarDataEntrega();
      });
    } else {
      setState(() {
        descricaoController.text = prefs.getString("descricaoServico") ?? "";
        horaInicio = prefs.getString("horaInicioServico") ?? "";
        dataInicio = prefs.getString("dataInicioServico") ?? "";
        farmacia = prefs.getString("farmaciaServico") ?? "";
        observacaoController.text = prefs.getString("observacaoServico") ?? "";
        user = prefs.getString("usuario") ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Serviço'),
        centerTitle: true,
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
            const ListTile(
              leading: Icon(Icons.verified),
              title: Text(
                "Versão 2.5 - n",
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),
              Text('Inicio: $horaInicio - $dataInicio'),
              const SizedBox(height: 16.0),
              TextField(
                controller: descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: observacaoController,
                decoration: const InputDecoration(labelText: 'Observação'),
              ),
              const SizedBox(height: 16.0),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        salvarEmCache();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Dados salvos no celular, ao finalizar serviço clique em "Enviar"'),
                          ),
                        );
                      });
                    },
                    child: const Text('Salvar'),
                  )),
                  const SizedBox(
                    width: 16.0,
                  ),
                  Expanded(
                      child: ElevatedButton(
                    onPressed: () async {
                      Future<bool> retorno = apiServicesEntrega
                          .inserirEntregaAvulsa(criarEntrega(), caminhoFinal);
                      if (await retorno) {
                        final SharedPreferences prefs = await _prefs;
                        prefs.setString("dataInicioServico", '');
                        prefs.setString("horaInicioServico", '');
                        prefs.setString("descricaoServico", '');
                        prefs.setString("observacaoServico", '');
                        prefs.setString("usuario", '');

                        chamarTelaEntregas();
                      } else {
                        setState(() {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Erro ao enviar entrega de serviço, verifique internet e tente novamente.'),
                            ),
                          );
                        });
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.green), // Cor de fundo
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.white), // Cor do texto
                    ),
                    child: const Text('Enviar'),
                  )),
                ],
              ),
              const SizedBox(
                height: 16.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  chamarTelaEntregas() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Serviço incluído com sucesso!'),
      ),
    );
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

  String atualizarHorarioEntrega() {
    DateTime now = DateTime.now();
    return formatDate(now, [HH, ':', nn]);
  }

  String atualizarDataEntrega() {
    DateTime now = DateTime.now();
    return formatDate(now, [dd, '/', mm, '/', yyyy]);
  }

  salvarEmCache() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("dataInicioServico", dataInicio);
    prefs.setString("horaInicioServico", horaInicio);
    prefs.setString(
        "descricaoServico", '${descricaoController.text} - $farmacia');
    prefs.setString("observacaoServico", observacaoController.text);
    prefs.setString("usuario", user);
  }

  EntregaAvulsa criarEntrega() {
    return EntregaAvulsa(
        dataInicioServico: dataInicio,
        horaInicioServico: horaInicio,
        dataTerminoServico: atualizarDataEntrega(),
        horaTerminoServico: atualizarHorarioEntrega(),
        descricaoServico: '${descricaoController.text} - $farmacia',
        observacaoServico: observacaoController.text,
        user: user);
  }
}
