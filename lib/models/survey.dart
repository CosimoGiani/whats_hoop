class Survey {

  String id;
  String teamID;
  String title;
  String question;
  List<String> options;

  Survey({
    this.id = "",
    this.teamID = "",
    required this.title,
    required this.question,
    this.options = const [],
  });

}