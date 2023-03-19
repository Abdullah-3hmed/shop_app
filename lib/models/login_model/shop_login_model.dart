class ShopLoginModel {
  late bool status;
   String? message;
  UserData? data;

  ShopLoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? UserData.fromJson(json: json['data']) : null;
  }
}

class UserData {
  int? id;
  String? phone;
  String? email;

  String? image;

  String? name;
  int? points;

  int? credit;

  String? token;

  UserData.fromJson({required Map<String, dynamic> json}) {
    id = json['id'];
    email = json['email'];
    phone = json['phone'];
    points = json['points'];
    credit = json['credit'];
    image = json['image'];
    name = json['name'];
    token = json['token'];
  }
}
