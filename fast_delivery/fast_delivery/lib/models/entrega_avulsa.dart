class EntregaAvulsa {
  String dataInicioServico;
  String horaInicioServico;
  String dataTerminoServico;
  String horaTerminoServico;
  String descricaoServico;
  String observacaoServico;
  String user;

  // Construtor com parâmetros obrigatórios (não anuláveis)
  EntregaAvulsa({
    required this.dataInicioServico,
    required this.horaInicioServico,
    required this.dataTerminoServico,
    required this.horaTerminoServico,
    required this.descricaoServico,
    required this.observacaoServico,
    required this.user
  });

  Map<String, dynamic> toJson() {
    return {
      'dataInicioServico': dataInicioServico,
      'horaInicioServico': horaInicioServico,
      'dataTerminoServico': dataTerminoServico,
      'horaTerminoServico': horaTerminoServico,
      'descricaoServico': descricaoServico,
      'observacaoServico': observacaoServico,
    };
  }

}