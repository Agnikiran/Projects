import '../interface/location_details_interface.dart';

class LocationDetails extends LocationDetailsInterface {
  @override
  late double? latitude, longitude;
  @override
  late String? name;

  LocationDetails() {
    latitude = null;
    longitude = null;
    name = null;
  }

  Map<String, dynamic> toJson() => {
        super.latitude: latitude,
        super.longitude: longitude,
        super.name: name ?? ""
      };

  LocationDetails.fromJson(Map<String, dynamic> data) {
    latitude = data[super.latitude] is double
        ? data[super.latitude]
        : double.parse(data[super.latitude]);
    longitude = data[super.longitude] is double
        ? data[super.longitude]
        : double.parse(data[super.longitude]);
    name = data[super.name];
  }
}
