import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDoVzmzbtzrlWO3ZKqcYLdEXW0FCwazyCo",
      appId: "1:1008143527601:android:d4bba7f297b6b445737c90",
      messagingSenderId: "1008143527601",
      projectId: "flutter-c024f",
      databaseURL: "https://fluterbiopark-default-rtdb.firebaseio.com/",
    ),
  );
  runApp(MyApp()); }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _codeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _valueController = TextEditingController();
  final _databaseRef = FirebaseDatabase.instance.ref('items');

  void _saveData() {
    final code = _codeController.text;
    final description = _descriptionController.text;
    final value = _valueController.text;

    if (code.isNotEmpty && description.isNotEmpty && value.isNotEmpty) {
      _databaseRef
          .push()
          .set({'code': code, 'description': description, 'value': value})
          .then((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Dados enviados com sucesso!')),
            );
            _codeController.clear();
            _descriptionController.clear();
            _valueController.clear();
          })
          .catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erro ao enviar dados: $error')),
            );
          });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro de Itens')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _codeController,
              decoration: InputDecoration(labelText: 'Código'),
              keyboardType: TextInputType.text,
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Descrição'),
              keyboardType: TextInputType.text,
            ),
            TextField(
              controller: _valueController,
              decoration: InputDecoration(labelText: 'Valor'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _saveData, child: Text('Salvar')),
          ],
        ),
      ),
    );
  }
}
