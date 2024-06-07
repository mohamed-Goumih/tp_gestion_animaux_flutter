import 'package:flutter/material.dart';
import 'sqlDataBase.dart';
import 'updateAnimaux.dart';

class TypeAnimal {
  final int id;
  final String nom;
  final String espece;

  TypeAnimal({
    required this.id,
    required this.nom,
    required this.espece,
});

  factory TypeAnimal.fromMap(Map<String, dynamic> map) {
    return TypeAnimal(
      id: map['id'],
      nom: map['nom'],
      espece: map['espece'],
    );
  }
}


class ListeAnimauxScreen extends StatefulWidget {
  const ListeAnimauxScreen({Key? key}) : super(key: key);

  @override
  _ListeAnimauxScreenState createState() => _ListeAnimauxScreenState();
}

class _ListeAnimauxScreenState extends State<ListeAnimauxScreen> {
  List<TypeAnimal> typeAnimauxList = [];

  @override
  void initState() {
    super.initState();
    _loadTypeAnimaux();
  }

  Future<void> _loadTypeAnimaux() async {
    final db = SqlDb();
    final typeAnimaux = await db.getTypeAnimaux();
    setState(() {
      typeAnimauxList = typeAnimaux;
    });
  }

  Future<void> _deleteTypeAnimal(int id) async {
    final db = SqlDb();
    final sql = 'DELETE FROM type_animaux WHERE id = $id';
    final response = await db.deleteData(sql);
    if (response > 0) {
      _loadTypeAnimaux();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Animaux'),
      ),
      body: ListView.builder(
  itemCount: typeAnimauxList.length,
  itemBuilder: (context, index) {
    final typeAnimal = typeAnimauxList[index];
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(typeAnimal.nom),
          subtitle: Text(typeAnimal.espece),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                color: Colors.green,
                onPressed: () {
                  // Naviguez vers la page de modification avec l'ID de l'animal
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateAnimauxScreen(animalId: typeAnimal.id),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                color: Colors.red,
                onPressed: () {
                  // Supprimez l'animal
                  _deleteTypeAnimal(typeAnimal.id);
                },
              ),
            ],
          ),
        ),
        const Divider(
          color: Colors.grey, // Couleur du trait
          height: 0, // Épaisseur du trait
        ),
      ],
    );
  },
),

    );
  }
}
