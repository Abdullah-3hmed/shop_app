class CategoriesModel{
  bool? status;
  CategoriesDataModel? data;
  CategoriesModel.fromJson(Map<String,dynamic>json){
    status = json['status'];
    data = CategoriesDataModel.fromJson(json['data']);
  }

}
class CategoriesDataModel{
  int? currentPage ;
  List<Map<String,dynamic>> data = [];
  CategoriesDataModel.fromJson(Map<String,dynamic> json){
    currentPage = json['current_page'];
    json['data'].forEach((element)
    {
      data.add(element);
    });

  }

}