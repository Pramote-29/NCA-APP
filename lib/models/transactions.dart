class Transactions {
  final int? keyID;
  final String teamname;
  final String playername;
  final String performance;
  final String? imagePath; // เพิ่มฟิลด์สำหรับเก็บ path ของภาพ

  Transactions({
    this.keyID,
    required this.teamname,
    required this.playername,
    required this.performance,
    this.imagePath,
  });
}