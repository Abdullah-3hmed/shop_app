import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubit/shop_cubit/shop_app_states.dart';
import 'package:shop_app/models/categories_model/categories_model.dart';
import 'package:shop_app/models/change_favorites_model/change_favorites_model.dart';
import 'package:shop_app/models/favorites_model/favorites_model.dart';
import 'package:shop_app/models/home_model/shop_home_model.dart';
import 'package:shop_app/models/login_model/shop_login_model.dart';
import 'package:shop_app/modules/shop_screens/categories/categories_screen.dart';
import 'package:shop_app/modules/shop_screens/products/products_screen.dart';
import 'package:shop_app/modules/shop_screens/settings/setting_screen.dart';
import 'package:shop_app/network/remote/dio_helper.dart';

import '../../modules/shop_screens/favorites/favorites_screen.dart';
import '../../network/endPoints/endpoints.dart';
import '../../shared/components/constants.dart';

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

  Future<void> getHomeData() async {
    emit(ShopAppHomeDataLoadingState());
    await DioHelper.getData(
      url: home,
      token: token,
    ).then((value) {
      homeModel = HomeModel.fromJson(value!.data);
      debugPrint(homeModel!.data.banners[0].image);
      for (var element in homeModel!.data.products) {
        favorites.addAll(
          {
            element.id: element.inFavorites,
          },
        );
      }
      emit(ShopAppHomeDataSuccessState());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopAppHomeDataErrorState());
    });
  }

   CategoriesModel? categoriesModel;

  Future<void> getCategoriesData() async {
    emit(ShopAppGetCategoriesLoadingState());
    await DioHelper.getData(
      url: getCategories,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value!.data);
      emit(ShopAppGetCategoriesSuccessState());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopAppGetCategoriesErrorState());
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
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value!.data);
      getFavoritesData();
      emit(ShopAppChangeFavoritesSuccessState(changeFavoritesModel!));
    }).catchError((error) {
      favorites[productId] = !favorites[productId]!;
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopAppChangeFavoritesErrorState());
    });
  }

  FavoritesModel? favoritesModel;

  Future<void> getFavoritesData() async {
    emit(ShopAppGetFavoritesDataLoadingState());
    DioHelper.getData(
      url: getFavorites,
      token: token,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value!.data);
      emit(ShopAppGetFavoritesDataSuccessState());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopAppGetFavoritesDataErrorState());
    });
  }

  ShopLoginModel? userModel;

  Future<void> getUserData() async {
    await DioHelper.getData(
      url: profile,
      token: token,
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value!.data);
      debugPrint(userModel!.status.toString());
      emit(ShopAppGetUserDataSuccessState(userModel!));
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopAppGetUserDataErrorState());
    });
    // try {
    //   var value = await DioHelper.getData(
    //     url: profile,
    //     token: token,
    //   );
    //   userModel = ShopLoginModel.fromJson(value!.data);
    //   emit(ShopAppGetUserDataSuccessState(userModel!));
    // } catch (error) {
    //   if (kDebugMode) {
    //     print(error.toString());
    //   }
    //   emit(ShopAppGetUserDataErrorState());
    // }
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
      emit(ShopAppUpdateUserDataSuccessState(userModel!));
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopAppUpdateUserDataErrorState());
    });
  }
}
