import 'package:flutter/material.dart';
import 'package:minhas_anotacoes/helper/NoteHelper.dart';
import 'dart:async';
import 'dart:io';
import 'package:minhas_anotacoes/model/Notes.dart';

class Home extends StatefulWidget {
  const Home({ Key key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _controllerAddNoteTitle = TextEditingController();
  TextEditingController _controllerAddNoteDesc = TextEditingController();
  var _db = NoteHelper();

  _saveNote() async {

    String title = _controllerAddNoteTitle.text;
    String description = _controllerAddNoteDesc.text;

    Notes notes = Notes(title, description, DateTime.now().toString());
    int result = await _db.saveNote(notes);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text("Anotações"),
      ),

      body: Column(
        children: <Widget>[

        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
        elevation: 0,
        child: Icon(Icons.add, size: 30),
        onPressed: (){
          showDialog(
            context: context, 
            builder: (context){
              return AlertDialog(
                title: Text("Adicionar anotação"),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _controllerAddNoteTitle,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: "Título",
                        hintText: "Título da sua anotação..."
                      ),
                      onChanged: (addNoteTitleTextField){},
                    ),

                    TextField(
                      controller: _controllerAddNoteDesc,
                      decoration: InputDecoration(
                        labelText: "Descrição",
                        hintText: "Descrição da sua anotação..."
                      ),
                      onChanged: (addNoteDescriptionTextField){},
                    ),
                  ],
                ),

                actions: <Widget>[
                  TextButton(
                    child: Text("Cancelar"),
                    onPressed: () => Navigator.pop(context),
                  ),

                  TextButton(
                    child: Text("Salvar"),
                    onPressed: (){}
                  ),
                ],
              );
            }
          );
        },
      ),

    );
  }
}