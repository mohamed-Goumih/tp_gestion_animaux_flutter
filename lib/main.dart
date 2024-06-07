import 'package:flutter/material.dart';
import 'home.dart'; // Importez le fichier home.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mon Application des animaux',
      home: HomeScreen(), // Utilisez HomeScreen comme page d'accueil
    );
  }
}