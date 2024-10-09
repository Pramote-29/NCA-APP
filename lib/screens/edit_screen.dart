import 'package:account/main.dart';
import 'package:account/models/transactions.dart';
import 'package:account/provider/transaction_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';

class EditScreen extends StatefulWidget {
  Transactions statement;

  EditScreen({super.key, required this.statement});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final formKey = GlobalKey<FormState>();
  final teamnameController = TextEditingController();
  final playernameController = TextEditingController();
  final perforController = TextEditingController();

  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with the existing data
    teamnameController.text = widget.statement.teamname;
    playernameController.text = widget.statement.playername;
    perforController.text = widget.statement.performance;

    // Load existing image path
    if (widget.statement.imagePath != null) {
      _image = File(widget.statement.imagePath!);
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "EDIT",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 9, 37, 128),
              ),
            ),
            Text(
              "FORM",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const Text(
                "Teamname",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  decoration: const InputDecoration(border: InputBorder.none),
                  autofocus: false,
                  controller: teamnameController,
                  validator: (String? str) {
                    if (str!.isEmpty) {
                      return 'Please enter Teamname';
                    }
                    return null;
                  },
                ),
              ),
              const Text(
                "Playername",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  decoration: const InputDecoration(border: InputBorder.none),
                  autofocus: false,
                  controller: playernameController,
                  validator: (String? str) {
                    if (str!.isEmpty) {
                      return 'Please enter Playername';
                    }
                    return null;
                  },
                ),
              ),
              const Text(
                "Performance",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  decoration: const InputDecoration(border: InputBorder.none),
                  autofocus: false,
                  controller: perforController,
                  validator: (String? str) {
                    if (str!.isEmpty) {
                      return 'Please enter performance';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              if (_image != null)
                Container(
                  height: 200,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: FileImage(_image!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ElevatedButton.icon(
                icon: const Icon(Icons.photo),
                label: const Text('เลือกรูปภาพ'),
                onPressed: _pickImage,
              ),
              TextButton(
                child: const Text(
                  'แก้ไขข้อมูล',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // create transaction data object
                    var statement = Transactions(
                      keyID: widget.statement.keyID,
                      teamname: teamnameController.text,
                      playername: playernameController.text,
                      performance: perforController.text,
                      imagePath: _image?.path ?? widget.statement.imagePath, // ใช้ภาพใหม่ถ้ามี หรือใช้ภาพเดิม
                    );

                    // update transaction data object to provider
                    var provider = Provider.of<TransactionProvider>(context, listen: false);
                    provider.updateTransaction(statement);

                    Navigator.push(context, MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) {
                        return const MyHomePage();
                      },
                    ));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}