import 'package:flutter/cupertino.dart';

class ApiModel {
  final String confirmed;
  final String newDeath;
  final String newRecovered;
  final String totalConfirmed;
  final String totalDeath;
  final String totalRecovered;

  ApiModel(
      {@required this.confirmed,
      @required this.newDeath,
      @required this.newRecovered,
      this.totalConfirmed,
      this.totalDeath,
      this.totalRecovered});
}
