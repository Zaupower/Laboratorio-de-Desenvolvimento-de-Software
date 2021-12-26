class Chat {
  final int chatId;
  final int userId;
  final String publicationName;
  final int publicationId;

  Chat({this.chatId, this.userId, this.publicationId, this.publicationName});

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      chatId: json['chatId'] as int,
      userId: json['userId'] as int,
      publicationId: json['publicationId'] as int,
      publicationName: json['publicationName'] as String

    );
  }
}