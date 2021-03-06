class SuperModel {
  SuperModel({
    required this.data,
  });
  late final List<Data> data;

  SuperModel.fromJson(Map<String, dynamic> json) {
    data = List.from(json['data']).map((e) => Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.id,
    required this.username,
    required this.title,
    required this.body,
    required this.coverImage,
    required this.like,
    required this.share,
    required this.comment,
  });
  late final String id;
  late final String username;
  late final String title;
  late final String body;
  late final String coverImage;
  late final int like;
  late final int share;
  late final int comment;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    username = json['username'];
    title = json['title'];
    body = json['body'];
    coverImage = json['coverImage'];
    like = json['like'];
    share = json['share'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['username'] = username;
    _data['title'] = title;
    _data['body'] = body;
    _data['coverImage'] = coverImage;
    _data['like'] = like;
    _data['share'] = share;
    _data['comment'] = comment;
    return _data;
  }
}
