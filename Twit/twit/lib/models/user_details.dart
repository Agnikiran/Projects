import '../interface/user_details_interface.dart';

class UserDetails extends UserDetailsInterface {
  @override
  late String? name, mobile, email, visitType;

  UserDetails() {
    name = null;
    mobile = null;
    email = null;
    visitType = null;
  }

  Map<String, String> toJson() => {
        super.name: name ?? "",
        super.mobile: mobile ?? "",
        super.email: email ?? "",
        super.visitType: visitType ?? ""
      };

  UserDetails.fromJson(Map<String, String> data) {
    name = data[super.name] ?? "";
    mobile = data[super.mobile] ?? "";
    email = data[super.email] ?? "";
    visitType = data[super.visitType] ?? "";
  }
}
