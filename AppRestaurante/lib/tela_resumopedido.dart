import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:convert';

import 'tela_cardapio.dart';
import 'tela_carrinho.dart';
import 'pedido.dart';

class TelaResumoPedido extends StatefulWidget {
  final bool Function()? onToggleTheme;
  final bool? isDarkMode;

  const TelaResumoPedido({super.key, this.onToggleTheme, this.isDarkMode});

  @override
  State<TelaResumoPedido> createState() => _TelaResumoPedidoState();
}

class _TelaResumoPedidoState extends State<TelaResumoPedido> {
  late int tempoEntrega;

  @override
  void initState() {
    super.initState();
    _carregarPedidos();
    tempoEntrega = 20 + Random().nextInt(41);
  }

  List<Pedido> pedidos = [];

  Future<void> _carregarPedidos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? listaSalva = prefs.getString('pedidos');

    if (listaSalva != null) {
      List<dynamic> listaJson = jsonDecode(listaSalva);

      setState(() {
        pedidos = listaJson.map((json) => Pedido.fromJson(json)).toList();
      });
    }
  }

  Future<void> removerPedido(Pedido pedido) async {
    final prefs = await SharedPreferences.getInstance();
    final String? listaSalva = prefs.getString('pedidos');

    if (listaSalva != null) {
      List<dynamic> listaJson = jsonDecode(listaSalva);

      listaJson.removeWhere((json) =>
        json['id'] == pedido.id
      );

      await prefs.setString('pedidos', jsonEncode(listaJson));

      setState(() {
        pedidos = listaJson.map((json) => Pedido.fromJson(json)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    if(pedidos.isEmpty) {
      return Scaffold(
        backgroundColor: color.background,
        body: Stack(
          children: [

            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                icon: Icon(
                  Icons.home,
                  size: 32,
                  color: color.onSurface,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TelaCardapio(
                        onToggleTheme: widget.onToggleTheme,
                        isDarkMode: widget.isDarkMode,
                      ),
                    ),
                  );
                },
              ),
            ),

            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Make your order",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (widget.isDarkMode ?? true)
                          ? Color(0xFFCDB9FB)
                          : Colors.yellow,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TelaCardapio(
                            onToggleTheme: widget.onToggleTheme,
                            isDarkMode: widget.isDarkMode,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "Menu",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: color.background,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(
                        Icons.home,
                        size: 32,
                        color: color.onSurface,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TelaCardapio(onToggleTheme: widget.onToggleTheme, isDarkMode: widget.isDarkMode,),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    "Your order is being prepared!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: color.onBackground,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    "It will arrive in about $tempoEntrega minutes",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: color.onSurface,
                    ),
                  ),

                  const SizedBox(height: 35),

                  Column(
                    children: pedidos.map((pedido) {
                      return Container(
                        width: 500,
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: color.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                              color: color.shadow.withOpacity(0.2),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Customer: ${pedido.nomeCliente}",
                                      style: TextStyle(fontSize: 18, color: color.onSurface)),
                                  Text("Address: ${pedido.enderecoCliente}",
                                      style: TextStyle(fontSize: 18, color: color.onSurface)),
                                  Text("Dish: ${pedido.pratoPedido}",
                                      style: TextStyle(fontSize: 18, color: color.onSurface)),
                                  Text("Quantity: ${pedido.quantidadePedido}",
                                      style: TextStyle(fontSize: 18, color: color.onSurface)),
                                  Text("Notes: ${pedido.observacaoPedido}",
                                      style: TextStyle(fontSize: 18, color: color.onSurface)),
                                ],
                              ),
                            ),

                            SizedBox(
                              height: 120,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: color.onSurface, size: 26),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TelaCarrinho(
                                            onToggleTheme: widget.onToggleTheme,
                                            isDarkMode: widget.isDarkMode,
                                            pedido: pedido,
                                          ),
                                        ),
                                      );
                                    },
                                  ),

                                  const SizedBox(height: 8),

                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red, size: 26),
                                    onPressed: () {
                                      removerPedido(pedido);
                                    },
                                  ),
                                ],
                              )
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 35),

                  Container(
                    width: 1000,
                    height: 500,
                    decoration: BoxDecoration(
                      color: color.surfaceVariant,
                      borderRadius: BorderRadius.circular(16),
                      image: const DecorationImage(
                        image: AssetImage("assets/images/mapa.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
