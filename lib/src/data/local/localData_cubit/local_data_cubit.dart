import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'local_data_state.dart';

class LocalDataCubit extends Cubit<LocalDataState> {
  LocalDataCubit() : super(LocalDataInitial());

  static LocalDataCubit get(context) => BlocProvider.of(context);

  ///LOCAL DATA

  Future<void> saveSharedMap(String mapName, Map mapData) async {
    emit(UpdatingLocalData());
    String jsonString = jsonEncode(mapData);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(mapData['strMeal'].toString(), jsonString);
      await saveDataToList(mapName, mapData['strMeal'].toString());
      emit(LocalDataSuccessful());
    } catch (e) {
      emit(LocalDataFailed());
    }
  }

  Future<Map<String, dynamic>> getSharedMap(String mapName) async {
    emit(GettingLocalData());
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? jsonString = prefs.getString(mapName);
      Map<String, dynamic> savedData = jsonDecode(jsonString!);
      emit(LocalDataSuccessful());
      return savedData;
    } catch (e) {
      emit(LocalDataFailed());
      return Future.error("LocalDataFailed");
    }
  }

  Future<List<String>> getSharedDataList(String dataName) async {
    emit(UpdatingLocalData());
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var jsonString = prefs.getStringList(dataName);
      if (jsonString == null) {
        return [];
      }
      emit(LocalDataSuccessful());
      return jsonString;
    } catch (e) {
      emit(LocalDataFailed());
      return ["error"];
    }
  }

  Future<void> clearSharedAll() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  Future<void> saveDataToList(String dataListName, String newDataName) async {
    emit(UpdatingLocalData());

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> dataList =
          prefs.getStringList(dataListName.toString()) ?? [];
      if (!dataList.contains(newDataName)) {
        dataList.add(newDataName);
        await prefs.setStringList(dataListName, dataList);
      }
      emit(LocalDataSuccessful());
    } catch (e) {
      print(e);
      emit(LocalDataFailed());
    }
  }

  Future<void> deleteSharedItem(
      String dataListName, String deleteDataNamed) async {
    emit(UpdatingLocalData());

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> dataList =
          prefs.getStringList(dataListName.toString()) ?? [];
      dataList.remove(deleteDataNamed);
      await prefs.setStringList(dataListName, dataList);
      await prefs.remove(deleteDataNamed);
      emit(LocalDataSuccessful());
    } catch (e) {
      emit(LocalDataFailed());
      print(e);
    }
  }
}
