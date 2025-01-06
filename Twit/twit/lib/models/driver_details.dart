import '../interface/driver_details_interface.dart';

class DriverDetails extends DriverDetailsInterface {
  @override
  late String? name, mobile, email;
  @override
  late int? likes, comments;
  @override
  late double? rating;

  DriverDetails() {
    name = null;
    likes = null;
    comments = null;
    rating = null;
    mobile = null;
    email = null;
  }

  Map<String, dynamic> toJson() => {
        super.name: name,
        super.likes: likes,
        super.comments: comments,
        super.rating: rating,
        super.mobile: mobile,
        super.email: email
      };

  DriverDetails.fromJson(Map<String, dynamic> data) {
    name = data[super.name];
    likes = data[super.likes];
    comments = data[super.comments];
    rating = data[super.rating];
    mobile = data[super.mobile];
    email = data[super.email];
  }
}
