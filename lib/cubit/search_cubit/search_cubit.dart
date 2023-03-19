import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubit/search_cubit/search_states.dart';
import 'package:shop_app/network/remote/dio_helper.dart';
import 'package:shop_app/shared/components/constants.dart';

import '../../models/search_model/search_model.dart';
import '../../network/endPoints/endpoints.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context) => BlocProvider.of(context);
  SearchModel? searchModel;

  void searchProduct({
    required String text,
  }) {
    emit(SearchLoadingState());
    DioHelper.postData(
      url: search,
      token: token,
      data: {
        'text': text,
      },
    ).then((value) {
      searchModel = SearchModel.fromJson(value!.data);
      if (kDebugMode) {
        print(searchModel!.data!.data!.length);
      }
      emit(SearchSuccessState());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(SearchErrorState());
    });
  }
}
