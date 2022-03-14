class Survey {

  String id;
  String teamID;
  String title;
  String question;
  List<String> options;
  int numVotes;

  Survey({
    this.id = "",
    this.teamID = "",
    required this.title,
    required this.question,
    this.options = const [],
    required this.numVotes
  });

}