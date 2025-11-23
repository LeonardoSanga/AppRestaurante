class Pedido {
  final String id;
  final String nomeCliente;
  final String enderecoCliente;
  final String pratoPedido;
  final String pratoImagem;
  final String quantidadePedido;
  final String observacaoPedido;

  Pedido({
    required this.id,
    required this.nomeCliente,
    required this.enderecoCliente,
    required this.pratoPedido,
    required this.pratoImagem,
    required this.quantidadePedido,
    required this.observacaoPedido,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomeCliente': nomeCliente,
      'enderecoCliente': enderecoCliente,
      'pratoPedido': pratoPedido,
      'pratoImagem': pratoImagem,
      'quantidadePedido': quantidadePedido,
      'observacaoPedido': observacaoPedido,
    };
  }

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'] ?? '',
      nomeCliente: json['nomeCliente'] ?? '',
      enderecoCliente: json['enderecoCliente'] ?? '',
      pratoPedido: json['pratoPedido'] ?? '',
      pratoImagem: json['pratoImagem'] ?? '',
      quantidadePedido: json['quantidadePedido'] ?? '',
      observacaoPedido: json['observacaoPedido'] ?? '',
    );
  }

}
