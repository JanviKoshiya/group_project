import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper{

  //singleton
  DBHelper._();

  static final DBHelper getInstance = DBHelper._();

  static final String TABLE_SCORECARD = "Scorecard";
  static final String COLUMN_SNO = "s_no";
  static final String COLUMN_NAME = "name";
  static final String COLUMN_RUN = "run";
  static final String COLUMN_BALL = "ball";
  static final String COLUMN_FOURS = "fours";
  static final String COLUMN_SIXS = "sixs";
  static final String COLUMN_STRICKRATE = "sr";

  Database? myDB;

  // db open

  Future<Database> getDB() async{

    myDB ??= await openDB();
    return myDB!;

    /*if(mydb != null){
      return mydb;
    }
    else{
      mydb = openDB() as Database?;
      return mydb!;
    }*/

  }

  Future<Database> openDB() async{

    Directory appPath = await getApplicationDocumentsDirectory();

    String dbPath = join(appPath.path , "ScoreCard.db");
    print("Database Path: $dbPath");

    return await openDatabase(dbPath, onCreate: (db,version){

      // CREATE TABLE

      db.execute("create table $TABLE_SCORECARD ( $COLUMN_SNO integer primary key autoincrement , "
          "$COLUMN_NAME text , $COLUMN_RUN integer , $COLUMN_BALL integer , $COLUMN_FOURS integer ,"
          "$COLUMN_SIXS integer ,$COLUMN_STRICKRATE double)");

    },version: 1);
  }
  // ALL QUERIES

  // insertion

  Future<bool> addPlayers({required String Name , required int Run , required int Ball , required int Four , required int Six , required double SR}) async{

    var db = await getDB();

     int rowsEffected = await db.insert(TABLE_SCORECARD, {
      COLUMN_NAME : Name,
      COLUMN_RUN : Run,
      COLUMN_BALL : Ball,
      COLUMN_FOURS : Four,
      COLUMN_SIXS : Six,
      COLUMN_STRICKRATE : SR
    });

     return rowsEffected > 0;
  }

  //Read all Data
  Future<List<Map<String,dynamic>>> getFullScorecard() async {

    var db = await getDB();
    // select Query
    List<Map<String,dynamic>> mData = await db.query(TABLE_SCORECARD);
    return mData;
  }
}