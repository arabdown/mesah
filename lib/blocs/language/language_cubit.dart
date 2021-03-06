import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:listar_flutter_pro/configs/config.dart';
import 'package:listar_flutter_pro/utils/utils.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit() : super(AppLanguage.defaultLanguage);

  ///On Change Language
  void onUpdate(Locale locale) {
    emit(locale);

    ///Preference save
    UtilPreferences.setString(
      Preferences.language,
      locale.languageCode,
    );
  }
}
