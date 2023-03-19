class HomeModel {
  late bool status;
  late HomeDataModel data;

  HomeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = HomeDataModel.fromJson(json['data']);
  }
}

class HomeDataModel {
  List<BannerModel> banners = [];
  List<ProductModel> products = [];


  HomeDataModel.fromJson(Map<String, dynamic> json) {
    json['banners'].forEach((element) {
      banners.add(BannerModel.fromJson(element));
    });
    json['products'].forEach((element) {
      products.add(ProductModel.fromJson(element));
    });
  }
}
class BannerModel{
  late int id;
 late String image;
  BannerModel.fromJson(Map<String,dynamic> json){
    id = json['id'];
    image = json['image'];
  }
}
class ProductModel{
 late int id;
  late String image;
  late String name;
  dynamic price;
  dynamic oldPrice;
  dynamic discount;
  late bool inFavorites;
  late bool inCart;
  ProductModel.fromJson(Map<String,dynamic> json){
    id = json['id'];
    image = json['image'];
    name = json['name'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    inFavorites = json['in_favorites'];
    inCart = json['in_cart'];

  }
}