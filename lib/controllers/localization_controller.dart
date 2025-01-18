// import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navy/core/helpers/log_helper.dart';
import 'package:navy/models/language_model.dart';
import 'package:navy/services/dio_client.dart';
import 'package:navy/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationController extends GetxController implements GetxService {
  late SharedPreferences sharedPreferences;
  late DioClient dioClient;

  LocalizationController(
      {required this.sharedPreferences, required this.dioClient}) {
    loadCurrentLanguage();
  }

  Locale _locale = Locale(AppConstants.languages[0].languageCode!,
      AppConstants.languages[0].countryCode);
  bool _isLtr = true;
  List<LanguageModel> _languages = [];

  Locale get locale => _locale;
  bool get isLtr => _isLtr;
  List<LanguageModel> get languages => _languages;

  void setLanguage(Locale locale, {bool isInitial = false}) {
    Get.updateLocale(locale);
    _locale = locale;
    if (_locale.languageCode == 'ar') {
      _isLtr = false;
    } else {
      _isLtr = true;
    }
    //AddressModel? addressModel;
    try {
      //addressModel = AddressModel.fromJson(jsonDecode(sharedPreferences.getString(AppConstants.userAddress)!));
    } catch (e) {
      printLog(e);
    }

    ///pick zone id to update header
    // apiClient.updateHeader(
    //   sharedPreferences.getString(AppConstants.token), addressModel?.zoneId,
    //   locale.languageCode, Get.find<SplashController>().getGuestId(),
    // );
    saveLanguage(_locale);
    // if(Get.find<LocationController>().getUserAddress() != null) {
    //   Get.find<ServiceAreaController>().getZoneList();
    // }
    // Get.find<SplashController>().updateLanguage(isInitial);
    update();
  }

  void loadCurrentLanguage() async {
    _locale = Locale(
        sharedPreferences.getString(AppConstants.languageCode) ??
            AppConstants.languages[0].languageCode!,
        sharedPreferences.getString(AppConstants.countryCode) ??
            AppConstants.languages[0].countryCode);
    _isLtr = _locale.languageCode != 'ar';
    for (int index = 0; index < AppConstants.languages.length; index++) {
      if (AppConstants.languages[index].languageCode == _locale.languageCode) {
        _selectedIndex = index;
        break;
      }
    }
    _languages = [];
    _languages.addAll(AppConstants.languages);
    update();
  }

  void saveLanguage(Locale locale) async {
    sharedPreferences.setString(AppConstants.languageCode, locale.languageCode);
    sharedPreferences.setString(AppConstants.countryCode, locale.countryCode!);
    update();
  }

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  void setSelectIndex(int index, {bool shouldUpdate = true}) {
    _selectedIndex = index;
    if (shouldUpdate) {
      update();
    }
  }
}
