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
