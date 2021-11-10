class SocialUserModel
{
  String name;
  String email;
  String image;
  String cover;
  String phone;
  String bio;
  String uId;
  bool isEmailVerified;


  SocialUserModel(
  {
    this.name,
    this.email,
    this.phone,
    this.bio,
    this.image,
    this.cover,
    this.uId,
    this.isEmailVerified,
});

  SocialUserModel.fromJson(Map<String, dynamic>json)
  {
    email = json['email'];
    name = json['name'];
    image = json['image'];
    cover = json['cover'];
    bio = json['bio'];
    phone = json['phone'];
    uId = json['uId'];
    isEmailVerified = json['isEmailVerified'];
  }

  Map<String, dynamic> toMap()
  {
    return
      {
        'name': name,
        'email': email,
        'uId': uId,
        'image': image,
        'cover': cover,
        'phone': phone,
        'bio': bio,
        'isEmailVerified': isEmailVerified,

      };
  }

}