import 'package:account/main.dart';
import 'package:account/models/transactions.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:account/provider/transaction_provider.dart';

class FormScreen extends StatefulWidget {


  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final formKey = GlobalKey<FormState>();

  final teamnameController = TextEditingController();
  final playernameController = TextEditingController();
  final perforController = TextEditingController();

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
        appBar: AppBar(
          title: const Text('แบบฟอร์มเพิ่มข้อมูล'),
        ),
        body: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Teamname',
                  ),
                  autofocus: false,
                  controller: teamnameController,
                  validator: (String? str) {
                    if (str!.isEmpty) {
                      return 'Please enter teamname';
                    }
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Playername',
                  ),
                  autofocus: false,
                  controller: playernameController,
                  validator: (String? str) {
                    if (str!.isEmpty) {
                      return 'Please enter Playername';
                    }
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Performance',
                  ),
                  autofocus: false,
                  controller: perforController,
                  validator: (String? str) {
                    if (str!.isEmpty) {
                      return 'Please enter performance';
                    }
                  },
                ),
                TextButton(
                    child: const Text('บันทึก'),
                    onPressed: () {
                          if (formKey.currentState!.validate())
                            {
                              // create transaction data object
                              var statement = Transactions(
                                  keyID: null,
                                  teamname: teamnameController.text,
                                  playername: playernameController.text,
                                  performance: perforController.text 

                                  );
                            
                              // add transaction data object to provider
                              var provider = Provider.of<TransactionProvider>(context, listen: false);
                              
                              provider.addTransaction(statement);

                              Navigator.push(context, MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (context){
                                  return MyHomePage();
                                }
                              ));
                            }
                        })
              ],
            )));
  }
}
