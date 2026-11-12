class Login{
  String? usuario;
  int? quantidadeEntregas;
  String? erro;

  Login({this.usuario, this.quantidadeEntregas});

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
        usuario: json['usuario'] as String,
        quantidadeEntregas: json['quantidadeEntregas'] as int);
  }
  Login.fromMap(Map map) {
    usuario = map["usuario"];
    quantidadeEntregas = map["quantidadeEntregas"];
  }
  Map toMap() {
    Map<String, dynamic> map = {
      "usuario": usuario,
      "quantidadeEntregas": quantidadeEntregas
    };
    return map;
  }
}