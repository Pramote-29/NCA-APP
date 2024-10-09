import 'package:account/main.dart';
import 'package:account/models/transactions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:account/provider/transaction_provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController(); // ใช้สำหรับกรอกชื่อทีม
  final playerController = TextEditingController(); // ใช้สำหรับกรอกชื่อนักบาส
  final performanceController = TextEditingController(); // ใช้สำหรับกรอกผลงานของทีม
  File? _teamImage;
  List<String> players = []; // ลิสต์สำหรับเก็บชื่อนักบาส

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _teamImage = File(pickedFile.path);
      });
    }
  }

  void _addPlayer() {
    if (playerController.text.isNotEmpty) {
      setState(() {
        players.add(playerController.text);
        playerController.clear(); // ล้างฟิลด์หลังจากเพิ่มชื่อ
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 152, 151, 151),
      appBar: AppBar(
        title: const Text(
          'แบบฟอร์มเพิ่มข้อมูล',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Color.fromRGBO(250, 250, 250, 1),
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // ช่องกรอกชื่อทีม
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'ชื่อทีม',
                  ),
                  controller: titleController,
                  validator: (String? str) {
                    if (str!.isEmpty) {
                      return 'กรุณากรอกชื่อทีม';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // แสดงรูปภาพที่เลือกหรือข้อความหากยังไม่ได้เลือก
                _teamImage == null
                    ? const Text('ยังไม่ได้เลือกรูปภาพ')
                    : Image.file(_teamImage!, height: 100),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('เลือกรูปภาพทีม'),
                ),
                const SizedBox(height: 20),
                // ช่องกรอกชื่อนักบาส
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'ชื่อนักบาส',
                  ),
                  controller: playerController,
                ),
                ElevatedButton(
                  onPressed: _addPlayer,
                  child: const Text('เพิ่มนักบาส'),
                ),
                const SizedBox(height: 20),
                // แสดงรายชื่อนักบาสที่เพิ่มเข้ามา
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: players.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(players[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            players.removeAt(index);
                          });
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                // ช่องกรอกผลงานของทีม
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'ผลงานของทีม',
                    hintText: 'เช่น Season 2024: ชนะ 30 แพ้ 20',
                  ),
                  controller: performanceController,
                  validator: (String? str) {
                    if (str!.isEmpty) {
                      return 'กรุณากรอกผลงานของทีม';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // ปุ่มบันทึกข้อมูล
                TextButton(
                  child: const Text('บันทึก'),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // สร้างข้อมูลทีมใหม่
                      var team = Team(
                        keyID: null,
                        teamName: titleController.text,
                        teamImage: _teamImage?.path,
                        players: players,
                        wins: 0, // ไม่ใช้งานในฟอร์มนี้ แต่จำเป็นสำหรับโมเดล
                        losses: 0, // ไม่ใช้งานในฟอร์มนี้ แต่จำเป็นสำหรับโมเดล
                      );

                      // เพิ่มข้อมูลทีมไปยัง provider
                      var provider = Provider.of<TransactionProvider>(context, listen: false);
                      provider.addTeam(team);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) {
                            return const MyHomePage();
                          },
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Center(
            child: RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'N',
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: 'B',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: 'A ',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: 'CRUD APP',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ],
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),
      ),
    );
  }
}