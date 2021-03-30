import 'package:gsc/const.dart';
import 'package:gsc/model/event.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EventRepository {
  Future<List<EventModel>> getAllEvent(String token) async {
    final request = await http.get(
      Uri.parse(serverlink + "/api/event/all"),
      headers: {'Authorization': 'Bearer ' + token},
    );
    if (request.statusCode != 200) throw Exception();
    print(request.statusCode);
    return parsedJson(request.body);
  }

  List<EventModel> parsedJson(final response) {
    final jsonDecoded = json.decode(response);
    return List<EventModel>.from(
        jsonDecoded.map((model) => EventModel.fromJson(model)));
  }
}
