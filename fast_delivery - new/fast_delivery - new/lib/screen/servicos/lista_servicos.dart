import 'package:fast_delivery/models/entrega_avulsa.dart';
import 'package:fast_delivery/screen/home_entregas.dart';
import 'package:fast_delivery/services/entrega_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  String dataHoraInicioServico = '';
  final TextEditingController observacaoController = TextEditingController();

  ApiServiceEntrega apiServicesEntrega = ApiServiceEntrega();

  String userId = "";
  String userAdministrador = "";
  String desejaSair = "Deseja Sair?";
  String caminhoFinal = "";
  String horaFinal = "";

  @override
  void initState() {
    super.initState();
    userId = widget.user;
    caminhoFinal = widget.caminhoFinal;
    verificaSeExisteServico();
  }

  verificaSeExisteServico() async {
    final SharedPreferences prefs = await _prefs;
    if (!prefs.containsKey("dataHoraInicioServico") ||
        prefs.getString("dataHoraInicioServico") == "") {
      setState(() {
        dataHoraInicioServico = atualizarHorarioEntrega();
      });
    } else {
      setState(() {
        descricaoController.text = prefs.getString("descricaoServico") ?? "";
        dataHoraInicioServico = prefs.getString("dataHoraInicioServico") ?? "";
        observacaoController.text = prefs.getString("observacaoServico") ?? "";
        userId = prefs.getString("usuario") ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Serviço'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 30, 64, 120),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),
              Text(
                  'Inicio: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(dataHoraInicioServico))}'),
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
                        prefs.setString("dataHoraInicioServico", '');
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
                          const Color.fromARGB(
                              255, 30, 64, 120)), // Cor de fundo
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
                user: userId,
                carregarEntrega: true,
              )),
    );
  }

  String atualizarHorarioEntrega() {
    DateTime now = DateTime.now();
    return now.toIso8601String();
  }

  salvarEmCache() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("dataHoraInicioServico", dataHoraInicioServico);
    prefs.setString("descricaoServico", descricaoController.text);
    prefs.setString("observacaoServico", observacaoController.text);
    prefs.setString("usuario", userId);
  }

  EntregaAvulsa criarEntrega() {
    return EntregaAvulsa(
        dataHoraInicioServico: dataHoraInicioServico,
        dataHoraTerminoServico: atualizarHorarioEntrega(),
        descricaoServico: descricaoController.text,
        observacaoServico: observacaoController.text,
        userId: userId);
  }
}
