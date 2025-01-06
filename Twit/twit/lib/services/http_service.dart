import 'dart:convert';

import 'package:http/http.dart';
import '../models/location_details.dart';

class HTTPService {
  String url =
      "https://nominatim.openstreetmap.org/search?format=json&country=India&";
  late Uri uri;
  late final Client client;
  late Response response;

  HTTPService() {
    client = Client();
  }

  Future<Object?> searchLocation(String location) async {
    uri = Uri.parse("${url}city=$location");
    try {
      response = await client.get(uri);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        List<LocationDetails> locationDetails =
            ((json.decode(response.body) as List<dynamic>)
                .cast<Map<String, dynamic>>()
                .map((e) => LocationDetails.fromJson(e))).toList();
        return locationDetails;
      }
      return null;
    } catch (ex) {
      return null;
    }
  }
}
