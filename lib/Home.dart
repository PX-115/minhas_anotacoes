import 'package:flutter/material.dart';
import 'package:minhas_anotacoes/helper/AnotacaoHelper.dart';
import 'package:minhas_anotacoes/model/Anotacao.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _controllerTitulo = TextEditingController();
  TextEditingController _controllerDesc = TextEditingController();
  var _db = AnotacaoHelper();
  List<Anotacao> _anotacoes = List<Anotacao>();

  _recuperarAnotacoes() async {

    List anotacoesRecuperadas = await _db.recuperarAnotacoes();

    List<Anotacao> listaTemporaria = List<Anotacao>();
    for( var item in anotacoesRecuperadas ){

      Anotacao anotacao = Anotacao.fromMap( item );
      listaTemporaria.add( anotacao );

    }

    setState(() {
      _anotacoes = listaTemporaria;
    });

    listaTemporaria = null;
  }

  _salvarAnotacao() async {
    String titulo = _controllerTitulo.text;
    String descricao = _controllerDesc.text;

    Anotacao anotacao = Anotacao(titulo, descricao, DateTime.now().toString() );
    int resultado = await _db.salvarAnotacao( anotacao );
    print("Salvar anotação: " + resultado.toString() );

    _controllerTitulo.clear();
    _controllerDesc.clear();

    _recuperarAnotacoes();
  } 

  _exibirTelaCadastro(){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Adicionar anotação"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _controllerTitulo,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: "Título",
                  hintText: "Dê um título à sua anotação..."
                ),
              ),

              TextField(
                controller: _controllerDesc,
                decoration: InputDecoration(
                    labelText: "Descrição",
                    hintText: "Dê um descrição à sua anotação..."
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar")
            ),

            TextButton(
              onPressed: (){
                _salvarAnotacao();

                Navigator.pop(context);
              },
              child: Text("Salvar")
            ),
          ],
        );
      }
    );
  }

  _formatarData(String data){
    initializeDateFormatting("pt_BR");
    var formatador = DateFormat("d/MM/y"); 

    DateTime dataConvertida = DateTime.parse(data);
    String dataFormatada = formatador.format(dataConvertida);

    return dataFormatada;
  }

  @override
  void initState() {
    super.initState();
    _recuperarAnotacoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas Anotações"),
        backgroundColor: Colors.blue[900],
      ),

      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _anotacoes.length,
              itemBuilder: (context, index){
                    
                final anotacao = _anotacoes[index];
                    
                return Card(
                  child: ListTile(
                    title: Text( anotacao.titulo ),
                    subtitle: Text("${_formatarData(anotacao.data)} - Descrição: ${anotacao.descricao}") ,
                  ),
                );
              }
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, size: 30),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue[900],
        onPressed: _exibirTelaCadastro,
      ),    
    );
  }
}
