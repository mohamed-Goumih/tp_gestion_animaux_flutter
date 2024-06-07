import 'package:flutter/material.dart';
import 'sqlDataBase.dart';

class UpdateAnimauxScreen extends StatefulWidget {
  final int animalId;

  const UpdateAnimauxScreen({required this.animalId}); // Modifiez également ici

  @override
  _UpdateAnimauxScreenState createState() => _UpdateAnimauxScreenState();
}

class _UpdateAnimauxScreenState extends State<UpdateAnimauxScreen> {
  TextEditingController nomController = TextEditingController();
  TextEditingController especeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Remplissez les contrôleurs avec les données de l'animal actuel
    getAnimalData();
  }

  Future<void> getAnimalData() async {
    final db = SqlDb();
    final animal = await db.getTypeAnimalById(widget.animalId);

    if (animal != null) {
      nomController.text = animal.nom;
      especeController.text = animal.espece;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier l\'Animal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: nomController,
              decoration: InputDecoration(labelText: 'Nom de l\'animal'),
            ),
            TextField(
              controller: especeController,
              decoration: InputDecoration(labelText: 'Espèce de l\'animal'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                final nom = nomController.text;
                final espece = especeController.text;

                if (nom.isNotEmpty && espece.isNotEmpty) {
                  final db = SqlDb();
                  final sql =
                      "UPDATE type_animaux SET nom = '$nom', espece = '$espece' WHERE id = ${widget.animalId}";
                  final updatedRows = await db.updateData(sql);

                  if (updatedRows > 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Animal mis à jour avec succès.'),
                      ),
                    );
                    // Revenir à la liste des animaux
                    Navigator.pop(context, true);
                    
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Erreur lors de la mise à jour de l\'animal.'),
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
              child: const Text('Mettre à jour l\'Animal'),
            ),
          ],
        ),
      ),
    );
  }
}