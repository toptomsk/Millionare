import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quiz/Helper/Model.dart';

class APIRequest {

  static final APIRequest _singleton = APIRequest._internal();

  factory APIRequest() {
    return _singleton;
  }

  APIRequest._internal();

  Future<RootData> fetchData() async {
    final response = await http
        .get(Uri.parse('https://mocki.io/v1/c63890d6-10a3-445a-b0e6-e3d5478064ee'));

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return RootData.fromJson(json);
    } else {
      throw Exception('Failed to load album');
    }
  }
}