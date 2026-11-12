class TempoEntrega {
  int? quantidadeEntrega;
  String? mediaTotal;

  TempoEntrega({this.quantidadeEntrega, this.mediaTotal});

  factory TempoEntrega.fromJson(Map<String, dynamic> json) {
    return TempoEntrega(
        quantidadeEntrega: json['quantidadeEntrega'] as int?,
        mediaTotal: json['cupomOrcamento'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'quantidadeEntrega': quantidadeEntrega, 'mediaTotal': mediaTotal};
  }
}
