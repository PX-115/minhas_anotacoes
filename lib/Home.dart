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

  _salvarAtualizarAnotacao( {Anotacao anotacaoSelecionada} ) async {
    String titulo = _controllerTitulo.text;
    String descricao = _controllerDesc.text;

    if(anotacaoSelecionada == null){
      Anotacao anotacao = Anotacao(titulo, descricao, DateTime.now().toString() );
      int resultado = await _db.salvarAnotacao( anotacao );
    } else {
      anotacaoSelecionada.titulo = titulo;
      anotacaoSelecionada.descricao = descricao;

      int resultado = await _db.atualizarAnotacao( anotacaoSelecionada );
    }

    _controllerTitulo.clear();
    _controllerDesc.clear();

    _recuperarAnotacoes();
  }

  _removerAnotacao(int id) async {
    await _db.removerAnotacao(id);

    _recuperarAnotacoes();
  }

  _exibirTelaCadastro( {Anotacao anotacao} ){
    String textoSalvarAtualizar = "";

    if (anotacao == null) {
      _controllerTitulo.text = "";
      _controllerDesc.text = "";

      textoSalvarAtualizar = "Salvar";
    } else {
      _controllerTitulo.text = anotacao.titulo;
      _controllerDesc.text = anotacao.descricao;

      textoSalvarAtualizar = "Atualizar";
    }

    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("$textoSalvarAtualizar anotação"),
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
                _salvarAtualizarAnotacao(anotacaoSelecionada: anotacao);

                Navigator.pop(context);
              },
              child: Text(textoSalvarAtualizar)
            ),
          ],
        );
      }
    );
  }

  _confirmarExclusao(Anotacao anotacao){
    showDialog(
      context: context, 
      builder: (context){
        return AlertDialog(
          title: Text("Alerta de exclusão"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Deseja realmente excluir este item permanentemente?"),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    onPressed: (){
                      _removerAnotacao(anotacao.id);

                      Navigator.pop(context);
                    }, 
                    child: Text(
                      "Excluir",
                      style: TextStyle(fontSize: 17)
                    )
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: TextButton(
                      onPressed: () => Navigator.pop(context), 
                      child: Text(
                        "Cancelar",
                        style: TextStyle(fontSize: 17),
                      )
                    )
                  )
                ]
              )
            ],
          ),
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
                    subtitle: Text("${_formatarData(anotacao.data)} - Descrição: ${anotacao.descricao}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        GestureDetector(
                          child: Padding(
                            padding: EdgeInsets.only(right: 16),
                            child: Icon(Icons.edit, color: Colors.green),           
                          ),
                          onTap: (){
                            _exibirTelaCadastro(anotacao: anotacao);
                          },
                        ),

                        GestureDetector(
                          child: Icon(Icons.delete, color: Colors.red),
                          onTap: (){
                            _confirmarExclusao(anotacao);
                          },
                        ),
                      ],
                    ),
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
