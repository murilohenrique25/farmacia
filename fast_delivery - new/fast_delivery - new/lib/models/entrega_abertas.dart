

class EntregaAberta {

   String? dataCadastroEntrega;
   String? statusEntrega;
   String cupomOrcamento;


  EntregaAberta({
    this.dataCadastroEntrega,
    required this.cupomOrcamento,
    this.statusEntrega
  });

  factory EntregaAberta.fromJson(Map<String, dynamic> json) {

    return EntregaAberta(
      dataCadastroEntrega: json['dataCadastroEntrega'] as String?,
      cupomOrcamento: json['cupomOrcamento'] as String,
      statusEntrega: json['statusEntrega'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dataCadastroEntrega': dataCadastroEntrega,
      'cupomOrcamento': cupomOrcamento,
      'statusEntrega': statusEntrega,
    };
  }
}
