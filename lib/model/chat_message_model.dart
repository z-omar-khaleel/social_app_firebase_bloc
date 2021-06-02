class MessageChatModel {
  final String senderId;
  final String reciverId;
  final String dateTime;
  final String message;

  MessageChatModel(
      {this.senderId, this.reciverId, this.dateTime, this.message});

  factory MessageChatModel.fromMap(Map<String, dynamic> map) {
    return new MessageChatModel(
      senderId: map['senderId'] as String,
      reciverId: map['reciverId'] as String,
      dateTime: map['dateTime'] as String,
      message: map['message'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'senderId': this.senderId,
      'reciverId': this.reciverId,
      'dateTime': this.dateTime,
      'message': this.message,
    } as Map<String, dynamic>;
  }
}
