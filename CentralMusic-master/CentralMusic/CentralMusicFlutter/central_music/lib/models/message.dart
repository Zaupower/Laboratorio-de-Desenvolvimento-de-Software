class Message{
  final int id;
  final int chatId;
  final String messageSend;
  final int senderId;
  final DateTime time;

  Message({this.id, this.chatId, this.messageSend, this.senderId, this.time});

  factory Message.fromJson(Map<String, dynamic> json){
    return Message(
      id: json['id'] as int,
      chatId: json['chatId'] as int,
      messageSend: json['messageSend'] as String,
      senderId: json['senderId'] as int,
      time: DateTime.parse(json['time']),
    );
  }
}