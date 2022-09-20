import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/change_favorites_model.dart';
import 'package:shop_app/models/favorites_model.dart';
import 'package:shop_app/models/shop_home_model.dart';
import 'package:shop_app/models/shop_login_model.dart';
import 'package:shop_app/modules/shop_screens/categories_screen.dart';
import 'package:shop_app/modules/shop_screens/products_screen.dart';
import 'package:shop_app/modules/shop_screens/setting_screen.dart';
import 'package:shop_app/network/remote/dio_helper.dart';
import 'package:shop_app/shop_cubit/shop_app_states.dart';

import '../modules/shop_screens/favorites_screen.dart';
import '../network/endpoints.dart';
import '../shared/components/constants.dart';

class ShopAppCubit extends Cubit<ShopAppStates> {
  ShopAppCubit() : super(ShopAppInitialState());

  static ShopAppCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Widget> bottomScreens = [
    const ProductsScreen(),
    const CategoriesScreen(),
    const FavoritesScreen(),
    const SettingScreen(),
  ];

  void changeBottom(int index) {
    currentIndex = index;
    emit(ShopAppChangeBottomNavState());
  }

  HomeModel? homeModel;
  Map<int, bool> favorites = {};

  void getHomeData() {
    emit(ShopAppLoadingHomeDataState());
    DioHelper.getData(
      url: home,
      token: token,
    ).then((value) {
      homeModel = HomeModel.fromJson(value!.data);
      if (kDebugMode) {
        print(homeModel?.data?.banners[0]['id']);
        print(homeModel?.status);
        print(homeModel?.data?.products[0]['price']);
      }
      for (var element in homeModel!.data!.products) {
        favorites.addAll({element['id']: element['in_favorites']});
      }
      emit(ShopAppSuccessHomeDataState());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopAppErrorHomeDataState());
    });
  }

  CategoriesModel? categoriesModel;

  void getCategoriesData() {
    DioHelper.getData(
      url: getCategories,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value!.data);
      if (kDebugMode) {
        print(categoriesModel!.data!.currentPage);
      }
      emit(ShopAppSuccessGetCategoriesState());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopAppErrorGetCategoriesState());
    });
  }

  ChangeFavoritesModel? changeFavoritesModel;

  void changeFavorites(int productId) {
    favorites[productId] = !favorites[productId]!;
    emit(ShopAppChangeFavoritesState());
    DioHelper.postData(
      url: getFavorites,
      data: {
        'product_id': productId,
      },
      token: token,
    ).then((value) {
      if (changeFavoritesModel!.status == false) {
        favorites[productId] = !favorites[productId]!;
      } else {
        getFavoritesData();
      }
      emit(ShopAppChangeFavoritesSuccessState(changeFavoritesModel));
    }).catchError((error) {
      favorites[productId] = !favorites[productId]!;
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopAppChangeFavoritesErrorState());
    });
  }

  FavoritesModel? favoritesModel;

  void getFavoritesData() {
    emit(ShopAppGetFavoritesDataLoadingState());
    DioHelper.getData(
      url: getFavorites,
      token: token,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value!.data);
      if (kDebugMode) {
        print(value.data.toString());
      }
      emit(ShopAppGetFavoritesDataSuccessState());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopAppGetFavoritesDataErrorState());
    });
  }

  ShopLoginModel? userModel;

  void getUserData() {
    DioHelper.getData(
      url: profile,
      token: token,
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value!.data);
      if (kDebugMode) {
        print(userModel!.data!.name);
      }
      emit(ShopAppGetUserDataSuccessState(userModel!));
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopAppGetUserDataErrorState());
    });
  }

  void updateUserData({
    required String name,
    required String phone,
    required String email,
  }) {
    emit(ShopAppUpdateUserDataLoadingState());
    DioHelper.putData(
      url: updateProfile,
      token: token,
      data: {
        'name': name,
        'phone': phone,
        'email': email,
      },
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value!.data);
      if (kDebugMode) {
        print(userModel!.data!.name);
      }
      emit(ShopAppUpdateUserDataSuccessState(userModel!));
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopAppUpdateUserDataErrorState());
    });
  }
}
