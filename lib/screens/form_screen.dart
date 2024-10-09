import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:account/models/transactions.dart';
import 'package:account/main.dart';
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
  
  File? _image;
  final ImagePicker _picker = ImagePicker();

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
              "NCA",
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
                  'บันทึก',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // create transaction data object
                    var statement = Transactions(
                      keyID: null,
                      teamname: teamnameController.text,
                      playername: playernameController.text,
                      performance: perforController.text,
                      imagePath: _image?.path, // บันทึก path ของภาพใน object
                    );

                    // add transaction data object to provider
                    var provider = Provider.of<TransactionProvider>(context, listen: false);
                    provider.addTransaction(statement);

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