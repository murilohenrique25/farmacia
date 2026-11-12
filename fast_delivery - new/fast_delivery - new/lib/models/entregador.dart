class Entregador {
  String? loginEntregador;
  String? senha;

  Entregador({this.loginEntregador, this.senha});

  factory Entregador.fromJson(Map<String, dynamic> json) {
    return Entregador(
        loginEntregador: json['login-entregador'] as String,
        senha: json['senha'] as String);
  }
  Entregador.fromMap(Map map) {
    loginEntregador = map["login_entregador"];
    senha = map["senha"];
  }
  Map toMap() {
    Map<String, dynamic> map = {
      "login_entregador": loginEntregador,
      "senha": senha
    };
    return map;
  }
}
