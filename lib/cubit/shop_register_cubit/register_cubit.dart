import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubit/shop_register_cubit/register_states.dart';
import 'package:shop_app/models/login_model/shop_login_model.dart';
import 'package:shop_app/network/remote/dio_helper.dart';

import '../../network/endPoints/endpoints.dart';

class ShopRegisterCubit extends Cubit<ShopRegisterStates> {
  ShopRegisterCubit() : super(ShopRegisterInitialState());

  static ShopRegisterCubit get(context) => BlocProvider.of(context);
  ShopLoginModel? loginModel;

  void userRegister({
    required String email,
    required String password,
    required String phone,
    required String name,
  }) {
    emit(ShopRegisterLoadingState());
    DioHelper.postData(
      url: register,
      data: {
        'email': email,
        'name': name,
        'password': password,
        'phone': phone,
      },
    ).then((value) {
      if (kDebugMode) {
        print(value!.data);
      }
      loginModel = ShopLoginModel.fromJson(value!.data);
      emit(ShopRegisterSuccessState(loginModel!));
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopRegisterErrorState());
    });
  }

  bool isPassword = true;
  IconData suffix = Icons.visibility;

  changePasswordVisibility() {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility : Icons.visibility_off;
    emit(ShopRegisterChanePasswordVisibilityState());
  }
}
