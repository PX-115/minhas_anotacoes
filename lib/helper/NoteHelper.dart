import 'package:minhas_anotacoes/model/Notes.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NoteHelper {

  static final String tableName = "notes";
  static final NoteHelper _noteHelper = NoteHelper._internal();

  Database _db;

  factory NoteHelper(){
    return _noteHelper;
  }

  NoteHelper._internal(){

  }

  get db async{

    if(db != null){
      return _db;
    } else {
      _db = await startDB();
      return _db;
    }

  }

  _onCreate(Database db, int version) async {
    String sql = "CREATE TABLE $tableName ("
    "id INTEGER PRIMARY KEY AUTOINCREMENT, "
    "title VARCHAR, " 
    "description TEXT, " 
    "date DATETIME)";
    await db.execute(sql);
  }

  startDB() async {
    final databasePath = await getDatabasesPath();
    final databaseLocation = join(databasePath, 'db_minhas_anotacoes.db');

    var db = await openDatabase(databaseLocation, version: 1, onCreate: _onCreate);
    return db;
  }

  Future<int> saveNote(Notes notes) async {
    var dataBase = await db;
    int result = db.insert(tableName, notes.toMap());
    return result;
  }

}