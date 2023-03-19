import '../../models/login_model/shop_login_model.dart';

abstract class ShopRegisterStates {
  get loginModel => null;
}

class ShopRegisterInitialState extends ShopRegisterStates {}

class ShopRegisterSuccessState extends ShopRegisterStates {
  @override
  final ShopLoginModel loginModel;

  ShopRegisterSuccessState(this.loginModel);
}

class ShopRegisterLoadingState extends ShopRegisterStates {}

class ShopRegisterErrorState extends ShopRegisterStates {}

class ShopRegisterChanePasswordVisibilityState extends ShopRegisterStates {}
