class Fine {

  String id;
  String reason;
  int euro;
  int cents;
  String date;
  String playerID;

  Fine({
    this.id = "",
    required this.reason,
    required this.euro,
    required this.cents,
    required this.date,
    this.playerID = "",
  });

}