import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:io';

class Home extends StatefulWidget {
  const Home({ Key key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _controllerAddNoteTitle = TextEditingController();
  TextEditingController _controllerAddNoteDesc = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Anotações'),
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
                title: Text('Adicionar anotação'),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _controllerAddNoteTitle,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: 'Título',
                        hintText: 'Título da sua anotação...'
                      ),
                      onChanged: (addNoteTitleTextField){},
                    ),

                    TextField(
                      controller: _controllerAddNoteDesc,
                      decoration: InputDecoration(
                        labelText: 'Descrição',
                        hintText: 'Descrição da sua anotação...'
                      ),
                      onChanged: (addNoteDescriptionTextField){},
                    ),
                  ],
                ),

                actions: <Widget>[
                  TextButton(
                    child: Text('Cancelar'),
                    onPressed: () => Navigator.pop(context),
                  ),

                  TextButton(
                    child: Text('Salvar'),
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