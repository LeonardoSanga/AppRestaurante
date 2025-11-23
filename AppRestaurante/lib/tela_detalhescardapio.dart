import 'package:flutter/material.dart';

import 'tela_cardapio.dart';
import 'tela_carrinho.dart';

class TelaDetalhesCardapio extends StatelessWidget {
  final bool Function()? onToggleTheme;
  final bool? isDarkMode;
  final ItemCardapio item;

  const TelaDetalhesCardapio({super.key, required this.item, this.onToggleTheme, this.isDarkMode});

  Widget buildIngredient(BuildContext context, String ingrediente) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.only(top: 6, right: 10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        Expanded(
          child: Text(
            ingrediente,
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  child: Text(
                    item.descricao,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    item.imagem,
                    height: 500,
                    width: 1000,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 25),

                LayoutBuilder(
                  builder: (context, constraints) {
                    final double width = constraints.maxWidth;
                    final bool useTwoColumns = width > 700;

                    List<String> left;
                    List<String> right;

                    if (useTwoColumns) {
                      final half = (item.ingredientes.length / 2).ceil();
                      left = item.ingredientes.sublist(0, half);
                      right = item.ingredientes.sublist(half);
                    } else {
                      left = item.ingredientes; 
                      right = [];
                    }

                    return Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 700),
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 8,
                              offset: Offset(0, 4),
                              color: Colors.black12,
                            )
                          ],
                        ),
                        child: useTwoColumns
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:
                                          left.map((i) => buildIngredient(context, i)).toList(),
                                    ),
                                  ),
                                  const SizedBox(width: 50),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:
                                          right.map((i) => buildIngredient(context, i)).toList(),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:
                                    left.map((i) => buildIngredient(context, i)).toList(),
                              ),
                      ),
                    );
                  },
                ),


                const SizedBox(height: 35),

                SizedBox(
                  width: 220,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TelaCarrinho(item: item, onToggleTheme: onToggleTheme, isDarkMode: isDarkMode),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (isDarkMode ?? true) ? Color(0xFFCDB9FB) : Colors.yellow,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Continue",
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
        ),
      ),
    );
  }
}
