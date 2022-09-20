import 'package:shop_app/models/shop_login_model.dart';

abstract class ShopLoginStates {
  get loginModel => null;
}

class ShopLoginInitialState extends ShopLoginStates {}

class ShopLoginSuccessState extends ShopLoginStates {
  @override
  final ShopLoginModel loginModel;

  ShopLoginSuccessState(this.loginModel);
}

class ShopLoginLoadingState extends ShopLoginStates {}

class ShopLoginErrorState extends ShopLoginStates {}
class ShopChanePasswordVisibilityState extends ShopLoginStates {}
