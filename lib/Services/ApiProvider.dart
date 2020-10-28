import 'dart:math';

import 'package:design1/Home.dart';
import 'package:design1/Services/ApiModel.dart';
import 'package:design1/Services/CountriesApiModel.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart ' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiSerrvices with ChangeNotifier {
  final List<ApiModel> apiModel = [];

  final List<String> countryNames = [];
  Future<void> displayFlags() async {
    // final url = "https://restcountries.eu/rest/v2";
    // var response = await http.get(url);

    countryNames.clear();
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var covid = await http.get("https://api.covid19api.com/summary");
      // if (response.statusCode == 200 && covid.statusCode == 200) {
      //   await json.decode(response.body).forEach((item) async {
      //     await json.decode(covid.body)['Countries'].forEach((e) {
      //       if (e["Country"] == item['name']) {
      //         countryModel.add(CountriesModel(
      //             countryFlag: item["flag"], countryName: item["name"]));
      //       }
      //     });
      //   });

      // }
      if (sharedPreferences.getStringList("sharedCountry").length == 0) {
        if (covid.statusCode == 200) {
          await json.decode(covid.body)['Countries'].forEach((country) {
            countryNames.add(country["Country"]);
          });
        }

        sharedPreferences
            .setStringList("sharedCountry", countryNames)
            .then((value) => print("value saved"))
            .catchError(((e) {
          print(e);
        }));
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> displatData(String countryName) async {
    final url = "https://api.covid19api.com/summary";
    var response = await http.get(url);

    await json.decode(response.body)['Countries'].forEach((e) {
      if (e["Country"] == countryName) {
        apiModel.clear();
        apiModel.add(ApiModel(
            confirmed: e["NewConfirmed"].toString(),
            newDeath: e["NewDeaths"].toString(),
            newRecovered: e["NewRecovered"].toString(),
            totalConfirmed: e["TotalConfirmed"].toString(),
            totalDeath: e["TotalDeaths"].toString(),
            totalRecovered: e["TotalRecovered"].toString()));
        notifyListeners();
        return 0;
      }
    });
  }
}
