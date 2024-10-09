import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:account/models/transactions.dart'; // เปลี่ยนชื่อ transactions.dart เป็นชื่อที่ถูกต้อง

class TransactionDB {
  String dbName;

  TransactionDB({required this.dbName});

  Future<Database> openDatabase() async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String dbLocation = join(appDirectory.path, dbName);

    DatabaseFactory dbFactory = databaseFactoryIo;
    Database db = await dbFactory.openDatabase(dbLocation);
    return db;
  }

  Future<int> insertDatabase(Team team) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('teams');

    var keyID = await store.add(db, {
      "teamName": team.teamName,
      "teamImage": team.teamImage,
      "players": team.players,
      "wins": team.wins,
      "losses": team.losses,
    });
    db.close();
    return keyID;
  }

  Future<List<Team>> loadAllData() async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('teams');
    var snapshot = await store.find(db);

    List<Team> teams = [];
    for (var record in snapshot) {
      teams.add(Team(
        keyID: record.key,
        teamName: record['teamName'] as String,
        teamImage: record['teamImage'] as String?,
        players: List<String>.from(record['players'] as List),
        wins: record['wins'] as int,
        losses: record['losses'] as int,
      ));
    }
    db.close();
    return teams;
  }

  Future<void> deleteDatabase(int index) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('teams');
    await store.delete(db, finder: Finder(filter: Filter.equals(Field.key, index)));
    db.close();
  }

  Future<void> updateDatabase(Team team) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('teams');
    var filter = Filter.equals(Field.key, team.keyID);
    await store.update(db, {
      "teamName": team.teamName,
      "teamImage": team.teamImage,
      "players": team.players,
      "wins": team.wins,
      "losses": team.losses,
    }, finder: Finder(filter: filter));
    db.close();
  }
}