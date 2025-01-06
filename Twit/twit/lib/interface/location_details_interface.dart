abstract class LocationDetailsInterface {
  final String _latitude = "lat";
  final String _longitude = "lon";
  final String _name = "display_name";

  get latitude => _latitude;
  get longitude => _longitude;
  get name => _name;
}
