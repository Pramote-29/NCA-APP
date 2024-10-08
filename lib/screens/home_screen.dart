import 'package:account/provider/transaction_provider.dart';
import 'package:account/screens/edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color.fromARGB(255, 147, 145, 145),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          title: RichText(
          text: TextSpan(
            children: [
              TextSpan(text: 'N', style: TextStyle(fontSize: 25,
              fontWeight: FontWeight.bold,color: const Color.fromARGB(255, 9, 37, 128))),
              TextSpan(text: 'B', style: TextStyle(fontSize: 25,
              fontWeight: FontWeight.bold,color: Colors.white)),
              TextSpan(text: 'A', style: TextStyle(fontSize: 25,
              fontWeight: FontWeight.bold,color: Colors.red)),
              TextSpan(text: ' CRUD APP', style: TextStyle(fontSize: 25,
              fontWeight: FontWeight.bold,color: Colors.red)),
            ],
          ),
        ),
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                SystemNavigator.pop();
              },
            ),
          ],
        ),
        body: Consumer(
          builder: (context, TransactionProvider provider, Widget? child) {
            if (provider.transactions.isEmpty) {
              return const Center(
                 child: Text('ไม่มีรายการที่เพิ่มเข้ามา', style: TextStyle(fontSize: 18)),
            );
            } else {
              return ListView.builder(
                itemCount: provider.transactions.length,
                itemBuilder: (context, index) {
                  var statement = provider.transactions[index];
                  return Card(
                    elevation: 5,
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    child: ListTile(
                      title: Text(statement.title),
                      subtitle: Text(DateFormat('dd MMM yyyy hh:mm:ss')
                          .format(statement.date)),
                      leading: CircleAvatar(
                        radius: 30,
                        child: FittedBox(
                          child: Text('${statement.amount}'),
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          provider.deleteTransaction(statement.keyID);
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return EditScreen(statement: statement);
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
        )
        
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
