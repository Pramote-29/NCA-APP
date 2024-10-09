import 'package:account/databases/transaction_db.dart';
import 'package:flutter/foundation.dart';
import 'package:account/models/transactios.dart'; // เปลี่ยนชื่อจาก transactions.dart เป็น team.dart

class TeamProvider with ChangeNotifier {
  List<Team> teams = [];

  List<Team> getTeams() {
    return teams;
  }

  void initData() async {
    var db = TransactionDB(dbName: 'teams.db'); // เปลี่ยนชื่อฐานข้อมูลให้เหมาะสมกับข้อมูลทีม
    teams = await db.loadAllData();
    print(teams);
    notifyListeners();
  }

  void addTeam(Team team) async {
    var db = TransactionDB(dbName: 'teams.db');
    var keyID = await db.insertDatabase(team);
    teams = await db.loadAllData();
    print(teams);
    notifyListeners();
  }

  void deleteTeam(int? index) async {
    print('delete index: $index');
    var db = TransactionDB(dbName: 'teams.db');
    await db.deleteDatabase(index);
    teams = await db.loadAllData();
    notifyListeners();
  }

  void updateTeam(Team team) async {
    var db = TransactionDB(dbName: 'teams.db');
    await db.updateDatabase(team);
    teams = await db.loadAllData();
    notifyListeners();
  }
}