import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubit/shop_login_cubit/login_states.dart';
import 'package:shop_app/models/login_model/shop_login_model.dart';

import 'package:shop_app/network/remote/dio_helper.dart';
import 'package:shop_app/shared/components/constants.dart';

import '../../network/endPoints/endpoints.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates> {
  ShopLoginCubit() : super(ShopLoginInitialState());

  static ShopLoginCubit get(context) => BlocProvider.of(context);
  ShopLoginModel? loginModel;

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(ShopLoginLoadingState());
    DioHelper.postData(
      url: login,
      data: {
        'email': email,
        'password': password,
      },
    ).then((value) {
      loginModel = ShopLoginModel.fromJson(value!.data);
      token = loginModel!.data!.token;
      emit(ShopLoginSuccessState(loginModel!));
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopLoginErrorState());
    });
  }

  bool isPassword = true;
  IconData suffix = Icons.visibility;

  changePasswordVisibility() {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility : Icons.visibility_off;
    emit(ShopChanePasswordVisibilityState());
  }
}
