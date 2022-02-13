// TODO Implement this library.
class ProfileModel {
  ProfileModel({
    required this.username,
    required this.name,
    required this.profession,
    required this.DOB,
    required this.titleline,
    required this.about,
    required this.img,
  });

  late final String username;
  late final String name;
  late final String profession;
  late final String DOB;
  late final String titleline;
  late final String about;
  late final String img;

  ProfileModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    name = json['name'];
    profession = json['profession'];
    DOB = json['DOB'];
    titleline = json['titleline'];
    about = json['about'];
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['username'] = username;
    _data['name'] = name;
    _data['profession'] = profession;
    _data['DOB'] = DOB;
    _data['titleline'] = titleline;
    _data['about'] = about;
    _data['img'] = img;
    return _data;
  }
}
