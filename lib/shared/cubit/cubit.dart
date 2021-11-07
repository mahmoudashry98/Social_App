

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scoial_app/shared/cubit/states.dart';
import 'package:scoial_app/shared/network/local/cache_helper.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;


  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }


  bool isBottomSheetShow = false;

  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
    @required bool isShow,
    @required IconData icon,
  }) {
    isBottomSheetShow = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  bool isDark = false;

  ThemeMode appMode = ThemeMode.dark;

  void changeAppMode({bool fromShared})
  {
    if(fromShared != null)
      isDark = fromShared;
      else
    isDark = !isDark;
    CacheHelper.putBoolean(key:  'isDark', value: isDark).then((value){

      emit(AppChangeModeState());

    });

  }
}
