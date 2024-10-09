import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:account/models/transactions.dart';

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

  Future<int> insertDatabase(Transactions statement) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('expense');

    var keyID = await store.add(db, {
      "teamname": statement.teamname,
      "playername": statement.playername,
      "performance": statement.performance,
      "imagePath": statement.imagePath // บันทึก path ของรูปภาพ
    });
    db.close();
    return keyID;
  }

  Future<List<Transactions>> loadAllData() async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('expense');
    var snapshot = await store.find(
      db,
      finder: Finder(sortOrders: [SortOrder(Field.key, false)]),
    );
    List<Transactions> transactions = [];
    for (var record in snapshot) {
      transactions.add(Transactions(
        keyID: record.key,
        teamname: record['teamname'].toString(),
        playername: record['playername'].toString(),
        performance: record['performance'].toString(),
        imagePath: record['imagePath']?.toString(), // อ่านค่า path ของรูปภาพ
      ));
    }
    db.close();
    return transactions;
  }

  Future<void> deleteDatabase(int? index) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('expense');
    await store.delete(
      db,
      finder: Finder(filter: Filter.equals(Field.key, index)),
    );
    db.close();
  }

  Future<void> updateDatabase(Transactions statement) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('expense');
    var filter = Finder(filter: Filter.equals(Field.key, statement.keyID));
    var result = await store.update(db, {
      "teamname": statement.teamname,
      "playername": statement.playername,
      "performance": statement.performance,
      "imagePath": statement.imagePath // อัปเดต path ของรูปภาพ
    }, finder: filter);
    db.close();
    print('update result: $result');
  }
}