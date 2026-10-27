import 'package:flutter/material.dart';

void main() {
  runApp(const MiniMagazaUygulamasi());
}

class MiniMagazaUygulamasi extends StatelessWidget {
  const MiniMagazaUygulamasi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title:"Mini Mağaza",
      theme:ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
      ),
      home: const Scaffold(
        body: Center(
          child: Text(
            "Ana Sayfa",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}