import 'package:account/main.dart';
import 'package:account/models/transactions.dart';
import 'package:account/provider/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class EditScreen extends StatefulWidget {
  Team team;

  EditScreen({super.key, required this.team});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final playerController = TextEditingController();
  final performanceController = TextEditingController();

  File? _teamImage;
  List<String> players = [];

  @override
  void initState() {
    super.initState();
    titleController.text = widget.team.teamName;
    performanceController.text = 'Wins: ${widget.team.wins}, Losses: ${widget.team.losses}';
    players = List.from(widget.team.players);
    if (widget.team.teamImage != null) {
      _teamImage = File(widget.team.teamImage!);
    }
  }

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
        playerController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แบบฟอร์มแก้ไขข้อมูล'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
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
              _teamImage == null
                  ? const Text('ยังไม่ได้เลือกรูปภาพ')
                  : Image.file(_teamImage!, height: 100),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('เลือกรูปภาพทีม'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'ผลงานของทีม',
                  hintText: 'เช่น Wins: 10, Losses: 2',
                ),
                controller: performanceController,
              ),
              const SizedBox(height: 20),
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
              TextButton(
                child: const Text('แก้ไขข้อมูล'),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // แยกข้อมูล wins และ losses จาก performanceController
                    int wins = 0;
                    int losses = 0;
                    final performanceParts = performanceController.text.split(',');
                    for (var part in performanceParts) {
                      if (part.trim().startsWith('Wins:')) {
                        wins = int.parse(part.trim().substring(5));
                      } else if (part.trim().startsWith('Losses:')) {
                        losses = int.parse(part.trim().substring(7));
                      }
                    }

                    // สร้างออบเจกต์ Team ใหม่สำหรับการอัปเดต
                    var updatedTeam = Team(
                      keyID: widget.team.keyID,
                      teamName: titleController.text,
                      teamImage: _teamImage?.path,
                      players: players,
                      wins: wins,
                      losses: losses,
                    );

                    // อัปเดตข้อมูลผ่าน provider
                    var provider = Provider.of<TransactionProvider>(context, listen: false);
                    provider.updateTeam(updatedTeam);

                    Navigator.push(context, MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) {
                        return const MyHomePage();
                      },
                    ));
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}