class Player {
  Player({this.uuid});
  final String? uuid;

  Map<String, dynamic> toJson() => {'uuid': uuid};
}
