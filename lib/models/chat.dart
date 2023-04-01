class Chatmodel {
  final String msg;
  final int chat;
  Chatmodel({
    required this.msg,
    required this.chat,
  });

  factory Chatmodel.fromJson(Map<String, dynamic> json) => Chatmodel(
        chat: json['chat'],
        msg: json['msg'],
      );
}
