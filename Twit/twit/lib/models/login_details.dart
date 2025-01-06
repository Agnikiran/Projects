import '../interface/login_details_interface.dart';

class LoginDetails extends LoginDetailsInterface {
  @override
  late String? mobile, password, visitType;

  LoginDetails() {
    mobile = null;
    password = null;
    visitType = null;
  }

  Map<String, String> toJson() => {
        super.mobile: mobile ?? "",
        super.password: password ?? "",
        super.visitType: visitType ?? ""
      };

  LoginDetails.fromJson(Map<String, String> data) {
    mobile = data[super.mobile] ?? "";
    password = data[super.password] ?? "";
    visitType = data[super.visitType] ?? "";
  }

  bool isAnyEmpty() =>
      ((mobile is String && mobile!.replaceAll(" ", "").isEmpty) ||
              (password is String && password!.replaceAll(" ", "").isEmpty) ||
              (visitType is String && visitType!.replaceAll(" ", "").isEmpty))
          ? true
          : false;

  bool isMatch(LoginDetails other) => (mobile == other.mobile &&
      password == other.password &&
      visitType == other.visitType);
}
