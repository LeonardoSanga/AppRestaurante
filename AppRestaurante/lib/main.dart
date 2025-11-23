import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'tela_cardapio.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;
  bool carregandoTema = true;

  @override
  void initState() {
    super.initState();
    _carregarTema();
  }

  Future<void> _carregarTema() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('tema_escuro') ?? false;
      carregandoTema = false;
    });
  }

  Future<void> _salvarTema(bool valor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tema_escuro', valor);
  }

  bool _alternarTema() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
    _salvarTema(isDarkMode);
    return isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    if (carregandoTema) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: TelaCardapio(
        onToggleTheme: _alternarTema,
        isDarkMode: isDarkMode,
      ),
    );
  }
}
