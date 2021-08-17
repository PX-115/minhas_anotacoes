import 'package:minhas_anotacoes/helper/AnotacaoHelper.dart';

class Anotacao{

  int id;
  String titulo;
  String descricao;
  String data;

  Anotacao(this.titulo, this.descricao, this.data);

  Anotacao.fromMap(Map map){
    this.id = map[AnotacaoHelper.colunaId];
    this.titulo = map[AnotacaoHelper.colunaTitulo];
    this.descricao = map[AnotacaoHelper.colunaDesc];
    this.data = map[AnotacaoHelper.colunaData];
  }

  Map toMap(){
    Map<String, dynamic> map = {
      AnotacaoHelper.colunaTitulo : this.titulo,
      AnotacaoHelper.colunaDesc : this.descricao,
      AnotacaoHelper.colunaData : this.data,
    };

    if( this.id != null ){
      map[AnotacaoHelper.colunaId] = this.id;
    }

    return map;
  }
}