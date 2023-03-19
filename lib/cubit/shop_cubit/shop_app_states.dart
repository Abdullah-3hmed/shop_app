import 'package:shop_app/models/change_favorites_model/change_favorites_model.dart';
import 'package:shop_app/models/login_model/shop_login_model.dart';

abstract class ShopAppStates {}

class ShopAppInitialState extends ShopAppStates {}

class ShopAppChangeBottomNavState extends ShopAppStates {}

class ShopAppHomeDataLoadingState extends ShopAppStates {}

class ShopAppHomeDataSuccessState extends ShopAppStates {}

class ShopAppHomeDataErrorState extends ShopAppStates {}

class ShopAppGetCategoriesLoadingState extends ShopAppStates {}

class ShopAppGetCategoriesSuccessState extends ShopAppStates {}

class ShopAppGetCategoriesErrorState extends ShopAppStates {}

class ShopAppChangeFavoritesSuccessState extends ShopAppStates {
  final ChangeFavoritesModel changeFavoritesModel;

  ShopAppChangeFavoritesSuccessState(this.changeFavoritesModel);
}

class ShopAppChangeFavoritesErrorState extends ShopAppStates {}

class ShopAppChangeFavoritesState extends ShopAppStates {}

class ShopAppGetFavoritesDataErrorState extends ShopAppStates {}

class ShopAppGetFavoritesDataLoadingState extends ShopAppStates {}

class ShopAppGetFavoritesDataSuccessState extends ShopAppStates {}

class ShopAppGetUserDataErrorState extends ShopAppStates {}

class ShopAppGetUserDataLoadingState extends ShopAppStates {}

class ShopAppGetUserDataSuccessState extends ShopAppStates {
  final ShopLoginModel userModel;

  ShopAppGetUserDataSuccessState(this.userModel);
}

class ShopAppUpdateUserDataErrorState extends ShopAppStates {}

class ShopAppUpdateUserDataLoadingState extends ShopAppStates {}

class ShopAppUpdateUserDataSuccessState extends ShopAppStates {
  final ShopLoginModel userModel;

  ShopAppUpdateUserDataSuccessState(this.userModel);
}
