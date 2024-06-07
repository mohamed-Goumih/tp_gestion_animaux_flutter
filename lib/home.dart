import 'package:flutter/material.dart';
import 'sqlDataBase.dart';
import 'liste_animaux.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController nomController = TextEditingController();
  TextEditingController especeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un Animal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: nomController,
              decoration: const InputDecoration(labelText: 'Nom de l\'animal'),
            ),
            TextField(
              controller: especeController,
              decoration: const InputDecoration(labelText: 'Espèce de l\'animal'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                final nom = nomController.text;
                final espece = especeController.text;

                if (nom.isNotEmpty && espece.isNotEmpty) {
                  final db = SqlDb();
                  final id = await db.insertTypeAnimal(nom, espece);

                  if (id != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Animal ajouté avec succès (ID: $id)'),
                      ),
                    );
                    nomController.clear();
                    especeController.clear();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Erreur lors de l\'ajout de l\'animal.'),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Veuillez remplir tous les champs.'),
                    ),
                  );
                }
              },
              child: const Text('Ajouter un Animal'),
            ),
             const SizedBox(height: 20.0),
             ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListeAnimauxScreen()),
                );
              },
              child: const Text('Voir la liste des animaux'),
            )

          ],
        ),
      ),
    );
  }
}
