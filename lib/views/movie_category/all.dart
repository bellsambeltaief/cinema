import 'package:flutter/material.dart';

class AllTest extends StatefulWidget {
  AllTest({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _AllTestState createState() => _AllTestState();
}

class _AllTestState extends State<AllTest> {
  String _contenuAffiche = '';

  void _afficherContenu(String contenu) {
    setState(() {
      _contenuAffiche = contenu;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _afficherContenu('Contenu du bouton 1'),
              child: Text('Bouton 1'),
            ),
            ElevatedButton(
              onPressed: () => _afficherContenu('Contenu du bouton 2'),
              child: Text('Bouton 2'),
            ),
            ElevatedButton(
              onPressed: () => _afficherContenu('Contenu du bouton 3'),
              child: Text('Bouton 3'),
            ),
            SizedBox(height: 20),
            Text(
              'Contenu affiché : $_contenuAffiche',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
