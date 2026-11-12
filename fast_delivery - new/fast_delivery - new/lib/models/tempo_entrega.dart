class TempoEntrega {
  int? quantidadeEntrega;
  String? mediaTotal;

  TempoEntrega({this.quantidadeEntrega, this.mediaTotal});

  factory TempoEntrega.fromJson(Map<String, dynamic> json) {
    return TempoEntrega(
        quantidadeEntrega: json['quantidadeEntrega'] as int? ?? 0,
        mediaTotal: json['mediaTotal'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'quantidadeEntrega': quantidadeEntrega, 'mediaTotal': mediaTotal};
  }
}
