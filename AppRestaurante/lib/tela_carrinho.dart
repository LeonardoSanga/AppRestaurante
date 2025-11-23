import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'tela_cardapio.dart';
import 'tela_resumopedido.dart';
import 'pedido.dart';

class TelaCarrinho extends StatefulWidget {
  final bool Function()? onToggleTheme;
  final bool? isDarkMode;
  final ItemCardapio? item;
  final Pedido? pedido;

  const TelaCarrinho({super.key, this.item, this.onToggleTheme, this.isDarkMode, this.pedido});

  @override
  State<TelaCarrinho> createState() => _TelaCarrinhoState();
}

class _TelaCarrinhoState extends State<TelaCarrinho> {
  final _formKey = GlobalKey<FormState>();

  final String _id = DateTime.now().millisecondsSinceEpoch.toString();
  late String _imagem;
  final _nomeController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _quantidadeController = TextEditingController(text: "1");
  final _observacoesController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _imagem = (widget.pedido == null) ? widget.item!.imagem : widget.pedido!.pratoImagem;
    _nomeController.text = (widget.pedido == null) ? "" : widget.pedido!.nomeCliente;
    _enderecoController.text = (widget.pedido == null) ? "" : widget.pedido!.enderecoCliente;
    _quantidadeController.text = (widget.pedido == null) ? "1" : widget.pedido!.quantidadePedido;
    _observacoesController.text = (widget.pedido == null) ? "" : widget.pedido!.observacaoPedido;
  }

  Future<void> salvarPedido(ItemCardapio item) async {
    final prefs = await SharedPreferences.getInstance();

    Pedido pedido = Pedido(
      id: _id,
      nomeCliente: _nomeController.text,
      enderecoCliente: _enderecoController.text,
      pratoPedido: item.descricao,
      pratoImagem: _imagem,
      quantidadePedido: _quantidadeController.text,
      observacaoPedido: _observacoesController.text,
    );

    final String? listaSalva = prefs.getString('pedidos');
    List<dynamic> lista = [];

    if (listaSalva != null) {
      lista = jsonDecode(listaSalva);
    }

    lista.add(pedido.toJson());
    await prefs.setString('pedidos', jsonEncode(lista));
  }

  Future<void> atualizarPedido() async {

    final prefs = await SharedPreferences.getInstance();

    Pedido pedidoAtualizado = Pedido(
      id: widget.pedido!.id,
      nomeCliente: _nomeController.text,
      enderecoCliente: _enderecoController.text,
      pratoPedido:  widget.pedido!.pratoPedido,
      pratoImagem: _imagem,
      quantidadePedido: _quantidadeController.text,
      observacaoPedido: _observacoesController.text,
    );

    final String? listaSalva = prefs.getString('pedidos');

    if (listaSalva == null) return;

    List<dynamic> listaJson = jsonDecode(listaSalva);

    List<Pedido> pedidos = listaJson.map((e) => Pedido.fromJson(e)).toList();

    int index = pedidos.indexWhere((p) => p.id == pedidoAtualizado.id);

    if (index != -1) {
      pedidos[index] = pedidoAtualizado;

      await prefs.setString(
        'pedidos',
        jsonEncode(pedidos.map((p) => p.toJson()).toList()),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final larguraTela = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double larguraForm =
                constraints.maxWidth < 600 ? constraints.maxWidth * 0.90 : 500;

            return SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, size: 30),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        widget.pedido == null 
                          ? widget.item!.descricao 
                          : widget.pedido!.pratoPedido,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 8,
                            offset: Offset(0, 4),
                            color: Colors.black12,
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              widget.pedido == null 
                                ? widget.item!.imagem 
                                : widget.pedido!.pratoImagem,
                              width: larguraTela < 400 ? 90 : 120,
                              height: larguraTela < 400 ? 90 : 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    Center(
                      child: Container(
                        width: larguraForm,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 8,
                              offset: Offset(0, 4),
                              color: Colors.black12,
                            ),
                          ],
                        ),

                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Name:",
                                  style: TextStyle(
                                      color: Theme.of(context).colorScheme.onSurface,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 5),
                              TextFormField(
                                controller: _nomeController,
                                decoration: _inputDecoration("Full name", context, widget.isDarkMode),
                                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty) {
                                    return "This field is required";
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 20),

                              Text("Address:",
                                  style: TextStyle(
                                      color: Theme.of(context).colorScheme.onSurface,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 5),
                              TextFormField(
                                controller: _enderecoController,
                                decoration: _inputDecoration("Street, number, neighborhood…", context, widget.isDarkMode),
                                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty) {
                                    return "This field is required";
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 20),

                              Text("Quantity:",
                                  style: TextStyle(
                                      color: Theme.of(context).colorScheme.onSurface,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 5),
                              TextFormField(
                                controller: _quantidadeController,
                                keyboardType: TextInputType.number,
                                decoration: _inputDecoration("1", context, widget.isDarkMode),
                                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty) {
                                    return "This field is required";
                                  }
                                  if (int.tryParse(value) == null ||
                                      int.parse(value) <= 0) {
                                    return "Enter a valid number";
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 20),

                               Text("Notes (optional):",
                                  style: TextStyle(
                                      color: Theme.of(context).colorScheme.onSurface,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 5),
                              TextFormField(
                                controller: _observacoesController,
                                maxLines: 3,
                                decoration: _inputDecoration("e.g., no onions", context, widget.isDarkMode),
                                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 35),
                    
                    SizedBox(
                      width: 220,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (widget.pedido == null) {
                              salvarPedido(widget.item!);
                            } else {
                              atualizarPedido();
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TelaResumoPedido(onToggleTheme: widget.onToggleTheme, isDarkMode: widget.isDarkMode),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: (widget.isDarkMode ?? true) ? Color(0xFFCDB9FB) : Colors.yellow,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          "Place Order",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, BuildContext context, bool? isDarkMode) {
    final color = Theme.of(context).colorScheme;

    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: color.onSurface.withOpacity(0.6),
      ),
      filled: true,
      fillColor: color.surfaceVariant,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: (isDarkMode ?? true) ? color.outline.withOpacity(0.4) : Colors.black.withOpacity(0.4),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: (isDarkMode ?? true) ? color.outline.withOpacity(0.4) : Colors.black.withOpacity(0.4),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: (isDarkMode ?? true) ? color.outline.withOpacity(0.4) : Colors.black.withOpacity(0.4),
          width: 2,
        ),
      ),
    );
  }

}
