class PostModel {
  final String uId;
  final String image;
  final String postImage;
  final String text;
  final String dateTime;
  final String name;

  PostModel(
      {this.uId,
      this.image,
      this.postImage,
      this.text,
      this.dateTime,
      this.name});

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return new PostModel(
      uId: map['uId'] as String,
      image: map['image'] as String,
      postImage: map['postImage'] as String,
      text: map['text'] as String,
      dateTime: map['dateTime'] as String,
      name: map['name'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'uId': this.uId,
      'image': this.image,
      'postImage': this.postImage,
      'text': this.text,
      'dateTime': this.dateTime,
      'name': this.name,
    } as Map<String, dynamic>;
  }
}
