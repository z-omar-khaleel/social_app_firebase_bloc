class CreateUser {
  String email;
  String name;
  String id;
  String phone;
  String cover;
  String bio;
  String image;

  CreateUser(
      {this.email,
      this.name,
      this.id,
      this.phone,
      this.cover,
      this.image,
      this.bio});

  factory CreateUser.fromJson(Map<String, dynamic> json) {
    return CreateUser(
        email: json['email'],
        name: json['name'],
        id: json['id'],
        phone: json['phone'],
        image: json['image'],
        bio: json['bio'],
        cover: json['cover']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['name'] = this.name;
    data['id'] = this.id;
    data['phone'] = this.phone;
    data['image'] = this.image;
    data['cover'] = this.cover;
    data['bio'] = this.bio;
    return data;
  }
}
