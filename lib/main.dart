import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubit/shop_cubit/shop_app_cubit.dart';
import 'package:shop_app/layout/shop_layout/shop_layout_screen.dart';
import 'package:shop_app/modules/login/shop_login_screen.dart';
import 'package:shop_app/network/local/cache_helper.dart';
import 'package:shop_app/network/remote/dio_helper.dart';
import 'package:shop_app/shared/bloc_observer/bloc_observer.dart';
import 'package:shop_app/styles/themes.dart';

import 'modules/on_boarding/on_boarding_screen.dart';
import 'shared/components/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  await CacheHelper.init();
  Bloc.observer = MyBlocObserver();
  Widget widget;
  bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
  token = CacheHelper.getData(key: 'token');
  if (kDebugMode) {
    print(token);
  }
  if (onBoarding != null) {
    if (token != null) {
      widget = const ShopLayoutScreen();
    } else {
      widget = const ShopLoginScreen();
    }
  } else {
    widget = const OnBoardingScreen();
  }

  runApp(
    ShopApp(
      startWidget: widget,
    ),
  );
}

class ShopApp extends StatelessWidget {
  const ShopApp({Key? key, required this.startWidget}) : super(key: key);
  final Widget startWidget;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShopAppCubit()
        ..getHomeData()
        ..getCategoriesData()
        ..getFavoritesData()
        ..getUserData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.light,
        home: startWidget,
      ),
    );
  }
}
