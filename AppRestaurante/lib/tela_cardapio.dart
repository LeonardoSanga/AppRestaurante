import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'tela_detalhescardapio.dart';
import 'tela_resumopedido.dart';

class ItemCardapioService {
  Future<List<ItemCardapio>> buscarItensCardapio() async {
    final url = Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s=');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      final List<dynamic> listaJson = jsonData['meals'];
      return listaJson.map((json) => ItemCardapio.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar os itens do cardápio da API.');
    }
  }
}

class ItemCardapio {
  final String id;
  final String descricao;
  final String imagem;
  final List<String> ingredientes;

  const ItemCardapio({
    required this.id,
    required this.descricao,
    required this.imagem,
    required this.ingredientes,
  });

  factory ItemCardapio.fromJson(Map<String, dynamic> json) {
    List<String> ingredientes = [];

    for (int i = 1; i <= 20; i++) {
      final ingrediente = json['strIngredient$i'];

      if (ingrediente != null && ingrediente.toString().trim().isNotEmpty) {
        ingredientes.add(ingrediente.toString());
      }
    }
    
    return ItemCardapio(
      id: json['idMeal'] ?? '',
      descricao: json['strMeal'] ?? '',
      imagem: json['strMealThumb'] ?? '',
      ingredientes: ingredientes,
    );
  }
}

class CardItemCardapio extends StatefulWidget {
  final ItemCardapio item;
  final VoidCallback onTap;

  const CardItemCardapio({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  State<CardItemCardapio> createState() => _CardItemCardapioState();
}

class _CardItemCardapioState extends State<CardItemCardapio> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedScale(
        scale: isHovered ? 1.08 : 1.00,
        duration: Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Card(
            elevation: isHovered ? 12 : 4,
            shadowColor: Colors.black54,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.network(
                      widget.item.imagem,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    widget.item.descricao,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TelaCardapio extends StatefulWidget {
  final bool Function()? onToggleTheme;
  final bool? isDarkMode;

  const TelaCardapio({
    super.key,
    this.onToggleTheme,
    this.isDarkMode,
  });

  @override
  State<TelaCardapio> createState() => _TelaCardapioState();
}

class _TelaCardapioState extends State<TelaCardapio> {
  late Future<List<ItemCardapio>> _futureItensCardapio;
  late bool? modoEscuro = widget.isDarkMode;

  @override
  void initState() {
    super.initState();
    _futureItensCardapio = ItemCardapioService().buscarItensCardapio();
  }

  void _onMenuSelected(String value) {
    if (value == 'toggle_theme') {
      modoEscuro = widget.onToggleTheme!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Menu',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 100,

        actions: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TelaResumoPedido(onToggleTheme: widget.onToggleTheme, isDarkMode: modoEscuro,)),
                );
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 150),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.shopping_cart,
                  size: 32,
                ),
              ),
            ),
          ),

          SizedBox(width: 8),

          PopupMenuButton<String>(
            tooltip: 'Settings',
            onSelected: _onMenuSelected,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'toggle_theme',
                child: Text(isDark ? 'Light Mode' : 'Dark Mode'),
              ),
            ],
            child: AnimatedContainer(
              duration: Duration(milliseconds: 150),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.settings,
                size: 28,
              ),
            ),
          ),

          SizedBox(width: 16),
        ],
      ),

      body: FutureBuilder<List<ItemCardapio>>(
        future: _futureItensCardapio,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final itens = snapshot.data!;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 400,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: itens.length,
                itemBuilder: (context, index) {
                  final item = itens[index];
                  return CardItemCardapio(
                    item: item,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TelaDetalhesCardapio(item: item, onToggleTheme: widget.onToggleTheme, isDarkMode: modoEscuro),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }

          return Center(child: Text('Nenhum item encontrado.'));
        },
      ),
    );
  }
}
