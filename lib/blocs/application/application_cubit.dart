import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:listar_flutter_pro/blocs/bloc.dart';
import 'package:listar_flutter_pro/configs/config.dart';
import 'package:listar_flutter_pro/models/model.dart';
import 'package:listar_flutter_pro/repository/repository.dart';
import 'package:listar_flutter_pro/utils/utils.dart';

class ApplicationCubit extends Cubit<ApplicationState> {
  ApplicationCubit() : super(ApplicationState.loading);

  ///On Setup Application
  void onSetup() async {
    ///Notify loading
    emit(ApplicationState.loading);

    ///Firebase init
    await Firebase.initializeApp();

    ///Setup SharedPreferences
    await Preferences.setPreferences();

    ///Read/Save Device Information
    await Application.setDevice();

    ///Get old Theme & Font & Language
    final oldTheme = UtilPreferences.getString(Preferences.theme);
    final oldFont = UtilPreferences.getString(Preferences.font);
    final oldLanguage = UtilPreferences.getString(Preferences.language);
    final oldDarkOption = UtilPreferences.getString(Preferences.darkOption);

    DarkOption? darkOption;
    String? font;
    ThemeModel? theme;

    ///Setup Language
    if (oldLanguage != null) {
      AppBloc.languageCubit.onUpdate(Locale(oldLanguage));
    }

    ///Find font support available [Dart null safety issue]
    try {
      font = AppTheme.fontSupport.firstWhere((item) {
        return item == oldFont;
      });
    } catch (e) {
      UtilLogger.log("ERROR", e);
    }

    if (oldTheme != null) {
      try {
        theme = ThemeModel.fromJson(jsonDecode(oldTheme));
      } catch (e) {
        UtilLogger.log("ERROR", e);
      }
    }

    ///check old dark option
    if (oldDarkOption != null) {
      switch (oldDarkOption) {
        case 'off':
          darkOption = DarkOption.alwaysOff;
          break;
        case 'on':
          darkOption = DarkOption.alwaysOn;
          break;
        default:
          darkOption = DarkOption.dynamic;
      }
    }

    ///Setup Theme & Font with dark Option
    AppBloc.themeCubit.onChangeTheme(
      theme: theme,
      font: font,
      darkOption: darkOption,
    );

    ///Load Filter config non blocking
    await ListRepository.loadSetting();

    ///Authentication begin check
    await AppBloc.authenticateCubit.onCheck();

    ///First or After upgrade version show intro preview app
    final hasReview = UtilPreferences.containsKey(
      '${Preferences.reviewIntro}.${Application.version}',
    );
    if (hasReview) {
      ///Notify
      emit(ApplicationState.completed);
    } else {
      ///Notify
      emit(ApplicationState.intro);
    }
  }

  ///On Complete Intro
  void onCompletedIntro() async {
    await UtilPreferences.setBool(
      '${Preferences.reviewIntro}.${Application.version}',
      true,
    );

    ///Notify
    emit(ApplicationState.completed);
  }
}
