import 'package:fast_delivery/models/tempo_entrega.dart';

class Login{
  String? usuario;
  TempoEntrega? tempoEntrega;
  String? erro;

  Login({this.usuario, this.tempoEntrega});

  factory Login.fromJson(Map<String, dynamic> json) {
  dynamic valueLogin = json['dadosEntregadorApp'];
  TempoEntrega tempoEntrega = TempoEntrega();
  tempoEntrega.mediaTotal = valueLogin['mediaTotal'] ?? '';
  tempoEntrega.quantidadeEntrega = valueLogin['quantidadeEntrega'] ?? 0;
    return Login(
        usuario: json['usuario'] as String,
        tempoEntrega: tempoEntrega
        );
  }
  Login.fromMap(Map map) {
    usuario = map["usuario"];
    tempoEntrega = map["tempoEntrega"];
  }
  Map toMap() {
    Map<String, dynamic> map = {
      "usuario": usuario,
      "tempoEntrega": tempoEntrega
    };
    return map;
  }
}