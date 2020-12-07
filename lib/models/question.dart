class Question {
  Question({
    this.id,
    this.content,
    this.items,
  });

  String id;
  String content;
  List<VoteItem> items;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        content: json["content"],
        items: json["items"] == null
            ? null
            : List<VoteItem>.from(
               json["items"].map((x) => VoteItem.fromJson(Map<String, dynamic>.from(x)))),
      );

  Map<String, dynamic> toJson() => {
        "content": content,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class VoteItem {
  VoteItem({
    this.id,
    this.name,
    this.voteCount,
    this.voters,
  });

  String id;
  String name;
  int voteCount;
  List<String> voters;

  factory VoteItem.fromJson(Map<String, dynamic> json) => VoteItem(
        name: json["name"],
        voteCount: json["voteCount"],
        voters: List<String>.from(json["voters"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "voteCount": voteCount,
        "voters": List<dynamic>.from(voters.map((x) => x)),
      };
}
