import 'dart:convert';
import 'package:fast_delivery/models/entrega.dart';
import 'package:fast_delivery/models/entrega_abertas.dart';
import 'package:fast_delivery/models/entrega_avulsa.dart';
import 'package:fast_delivery/models/tempo_entrega.dart';
import 'package:http/http.dart';

class ApiServiceEntrega {
  Future<List<Entrega>> getTodasEntregas(caminhoFinal, loginEntregador) async {
    Response res = await get(
        Uri.parse('$caminhoFinal/api/app/v1/entrega/$loginEntregador'));

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(res.bodyBytes));
      List<Entrega> entregas =
          body.map((dynamic item) => Entrega.fromJson(item)).toList();
      return entregas;
    } else {
      return [];
    }
  }

  Future<List<Entrega>> getTodasEntregasEntregador(
      String caminhoFinal, String loginEntregador) async {
    String url = '$caminhoFinal/api/app/v1/entrega/entregador/$loginEntregador';

    try {
      Response res = await get(Uri.parse(url));

      if (res.statusCode == 200) {
        // Decodificando o JSON e criando a lista de entregas
        List<dynamic> body = jsonDecode(utf8.decode(res.bodyBytes));
        List<Entrega> entregas =
            body.map((dynamic item) => Entrega.fromJson(item)).toList();
        return entregas;
      } else {
        // Em caso de falha, retornar uma lista vazia e logar o erro
        print('Erro ao buscar entregas: ${res.statusCode}');
        return [];
      }
    } catch (e) {
      // Captura de exceções em casos de erro de rede ou outro tipo de erro
      print('Erro ao realizar requisição: $e');
      return [];
    }
  }

  Future<TempoEntrega> quantidadeEntregaFinalizadasPorMes(
      String caminhoFinal, String loginEntregador) async {
    Response response = await get(Uri.parse(
        '$caminhoFinal/api/app/v1/entrega/quantidade/$loginEntregador'));
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return TempoEntrega.fromJson(body);
    }
    return TempoEntrega();
  }

  Future<String> updateEntregaEntregador(Set<Entrega> entregasSelecionadas,
      String user, String caminhoFinal) async {
    final List<Map<String, dynamic>> entregasJson =
        entregasSelecionadas.map((entrega) => entrega.toJson()).toList();

    final Response response = await put(
      Uri.parse('$caminhoFinal/api/app/v1/entrega/selecionar/$user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(entregasJson),
    );
    if (response.statusCode == 200) {
      return 'Pegou';
    } else {
      return response.body;
      // throw Exception('Falha ao atualizar ${response.body}');
    }
  }

  Future<bool> updateEntrega(
      String caminhoFinal, int idEntrega, String obs, lat, long) async {
    Map data = {
      'idEntrega': idEntrega,
      'observacao': obs,
      'latitude': lat,
      'longitude': long
    };

    final Response response = await put(
      Uri.parse('$caminhoFinal/api/app/v1/entrega/finalizar'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  //Entrega avulsa

  Future<bool> inserirEntregaAvulsa(
      EntregaAvulsa entregaAvulsa, String caminhoFinal) async {
    final Response response = await post(
      Uri.parse('$caminhoFinal/api/app/v1/entrega/avulsa'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(entregaAvulsa.toJson()),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<EntregaAberta>> getTodasEntregasAbertas(
      String caminhoFinal) async {
    String url = '$caminhoFinal/api/app/v1/entrega/abertas';
    Response res = await get(Uri.parse(url));

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<EntregaAberta> entregas =
          body.map((dynamic item) => EntregaAberta.fromJson(item)).toList();
      return entregas;
    } else {
      return [];
    }
  }
}
