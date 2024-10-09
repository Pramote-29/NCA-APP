class Team {
  int? keyID;
  final String teamName;
  final String? teamImage;
  final List<String> players;
  final int wins;
  final int losses; 

  Team({
    this.keyID,
    required this.teamName,
    this.teamImage,
    required this.players,
    required this.wins,
    required this.losses,
  });
}