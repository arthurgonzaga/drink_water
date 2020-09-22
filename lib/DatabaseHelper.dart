import 'package:sqflite/sqflite.dart';

///  This are the columns for the table [tableWater]

final String tableWater = 'water_table';
final String columnDayOfTheWeek = 'dayOfTheWeek';
final String columnDrank = 'drank';
final String columnPercentage = 'percentage';
final String columnNeedToDrink = 'needToDrink';
final String columnReachedGoal = 'needToDrink';

/// This are the variables for the table [tableUser]

final String tableUser = 'user_table';
final String columnId = '_id';
final String columnName = 'name';
final String columnHeight = 'height';
final String columnWeight = 'weight';
final String columnBmi = 'bmi';
final String columnGoal = 'goal';


class WaterProcess{

  int dayOfTheWeek;
  double drank;
  double percentage;
  double needToDrink;
  bool reachedGoal;

  WaterProcess();

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      columnDrank: drank,
      columnPercentage: percentage,
      columnNeedToDrink: needToDrink,
      columnReachedGoal: reachedGoal
    };
    if(dayOfTheWeek != null){
      map[columnDayOfTheWeek] = dayOfTheWeek;
    }
    return map;
  }

  WaterProcess.fromMap(Map<String,dynamic> map){
    dayOfTheWeek = map[columnDayOfTheWeek];
    drank = map[columnDrank];
    percentage = map[columnPercentage];
    needToDrink = map[columnNeedToDrink];
    reachedGoal = map[columnReachedGoal];
  }

}

class User{

  int id;
  String name, height, weight, bmi, goal;

  User();

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      columnName: name,
      columnHeight: height,
      columnWeight: weight,
      columnBmi: bmi,
      columnGoal: goal
    };
    if(id != null){
      map[columnId] = id;
    }
    return map;
  }

  User.fromMap(Map<String,dynamic> map){
    id = map[columnId];
    name = map[columnName];
    height= map[columnHeight];
    weight= map[columnWeight];
    bmi= map[columnBmi];
    goal= map[columnGoal];
  }

}

class WaterProcessProvider{

  Database db;

  Future open(String path) async{

    db = await openDatabase(
        path, version: 1,
      onCreate: (Database db, int version) async {
        '''
        create table $tableWater ( 
          $columnDayOfTheWeek integer primary key autoincrement, 
          $columnDrank double not null,
          $columnPercentage double not null,
          $columnNeedToDrink double not null
          $columnReachedGoal bool not null
          )
        ''';
      });
  }

  Future<WaterProcess> insert(WaterProcess waterProcess) async {
    waterProcess.dayOfTheWeek = await db.insert(tableWater, waterProcess.toMap());
    return waterProcess;
  }

  Future<WaterProcess> getTodo(int day) async {
    List<Map> maps = await db.query(tableWater,
        columns: [
          columnDayOfTheWeek,
          columnDrank,
          columnPercentage,
          columnNeedToDrink,
          columnReachedGoal
        ],
        where: '$columnDayOfTheWeek = ?',
        whereArgs: [day]);
    if (maps.length > 0) {
      return WaterProcess.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int day) async {
    return await db.delete(tableWater, where: '$columnDayOfTheWeek = ?', whereArgs: [day]);
  }

  Future<int> update(WaterProcess waterProcess) async {
    return await db.update(tableWater, waterProcess.toMap(),
        where: '$columnDayOfTheWeek = ?', whereArgs: [waterProcess.dayOfTheWeek]);
  }

  Future close() async => db.close();
}