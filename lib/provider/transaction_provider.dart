import 'package:account/databases/transaction_db.dart';
import 'package:flutter/foundation.dart';
import 'package:account/models/transactions.dart';

class TeamProvider with ChangeNotifier {
  List<Team> _teams = [];

  List<Team> get teams => _teams;

  void initData() async {
    var db = TransactionDB(dbName: 'teams.db');
    _teams = await db.loadAllData();
    notifyListeners();
  }

  void addTeam(Team team) async {
    var db = TransactionDB(dbName: 'teams.db');
    await db.insertDatabase(team);
    _teams = await db.loadAllData();
    notifyListeners();
  }

  void deleteTeam(int? keyID) async {
    var db = TransactionDB(dbName: 'teams.db');
    await db.deleteDatabase(keyID!);
    _teams = await db.loadAllData();
    notifyListeners();
  }

  void updateTeam(Team team) async {
    var db = TransactionDB(dbName: 'teams.db');
    await db.updateDatabase(team);
    _teams = await db.loadAllData();
    notifyListeners();
  }
}