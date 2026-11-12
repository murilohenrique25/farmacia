class Entrega {
  int idEntrega;
  String? dataCadastroEntrega;
  String? dataAssinaturaEntrega;
  String? dataSelecaoEntrega;
  String? dataFinalizacaoEntrega;
  int idUser;
  int? idEntregador;
  String? latitude;
  String? longitude;
  double valorTotal;
  double valorReceber;
  double troco;
  String cupomOrcamento;
  String? tipoEntrega;
  String formaPagamento;
  String? observacao;
  bool? selecionado = false;

  Entrega(
      {required this.idEntrega,
      this.dataCadastroEntrega,
      this.dataAssinaturaEntrega,
      this.dataSelecaoEntrega,
      this.dataFinalizacaoEntrega,
      required this.idUser,
      this.idEntregador,
      this.latitude,
      this.longitude,
      required this.valorTotal,
      required this.valorReceber,
      required this.troco,
      required this.cupomOrcamento,
      this.tipoEntrega,
      required this.formaPagamento,
      this.observacao,
      this.selecionado});

  factory Entrega.fromJson(Map<String, dynamic> json) {
    return Entrega(
      idEntrega: json['idEntrega'] as int,
      dataCadastroEntrega: json['dataCadastroEntrega'] as String?,
      dataAssinaturaEntrega: json['dataAssinaturaEntrega'] as String?,
      dataSelecaoEntrega: json['dataSelecaoEntrega'] as String?,
      dataFinalizacaoEntrega: json['dataFinalizacaoEntrega'] as String?,
      idUser: json['idUser'] as int,
      idEntregador: json['idEntregador'] as int?,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
      valorTotal: json['valorTotal'] != null
          ? (json['valorTotal'] as num).toDouble()
          : 0,
      valorReceber: json['valorReceber'] != null
          ? (json['valorReceber'] as num).toDouble()
          : 0,
      troco: json['troco'] != null ? (json['troco'] as num).toDouble() : 0,
      cupomOrcamento: json['cupomOrcamento'] as String,
      tipoEntrega: json['tipoEntrega'] as String?,
      formaPagamento: json['formaPagamento'] as String,
      observacao: json['observacao'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idEntrega': idEntrega,
      'dataCadastroEntrega': dataCadastroEntrega,
      'dataAssinaturaEntrega': dataAssinaturaEntrega,
      'dataSelecaoEntrega': dataSelecaoEntrega,
      'dataFinalizacaoEntrega': dataFinalizacaoEntrega,
      'idUser': idUser,
      'idEntregador': idEntregador,
      'latitude': latitude,
      'longitude': longitude,
      'valorTotal': valorTotal,
      'valorReceber': valorReceber,
      'troco': troco,
      'cupomOrcamento': cupomOrcamento,
      'tipoEntrega': tipoEntrega,
      'formaPagamento': formaPagamento,
      'observacao': observacao,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Entrega && other.idEntrega == idEntrega;
  }

  @override
  int get hashCode => idEntrega.hashCode;
}
