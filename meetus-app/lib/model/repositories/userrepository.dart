import 'package:gsc/const.dart';
import 'package:gsc/model/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserRepository {
  Future<UserModel> getUser(String token) async {
    final request = await http.get(
      Uri.parse(serverlink + "/api/user/profile"),
      headers: {'Authorization': 'Bearer ' + token},
    );
    if (request.statusCode != 200)
      throw Exception();
    else
      print('Success');
    print(request.body);
    return parsedJson(request.body);
  }

  UserModel parsedJson(final response) {
    final jsonDecoded = json.decode(response);
    return UserModel.fromJson(jsonDecoded);
  }
}
