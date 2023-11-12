import 'package:http/http.dart' as http;

import '../../domain/models/FoodModel.dart';

class HttpRequestPage {
  Future<FoodModel?> getFoodData() async {
    var client = http.Client();
    var url = Uri.parse("https://www.themealdb.com/api/json/v1/1/random.php");
    var response = await client.get(url);
    if (response.statusCode == 200) {
      var json = response.body;
      return foodModelFromJson(json);
    }
    return null;
  }

  Future<FoodModel?> searchFoodData(foodname) async {
    var client = http.Client();
    var url =
        Uri.parse("www.themealdb.com/api/json/v1/1/search.php?s=$foodname");
    var response = await client.get(url);
    if (response.statusCode == 200) {
      var json = response.body;
      return foodModelFromJson(json);
    }
    return null;
  }
}
