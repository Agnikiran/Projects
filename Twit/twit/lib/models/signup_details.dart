import '../interface/signup_details_interface.dart';

class SignupDetails extends SignupScreenInterface {
  @override
  late String? name, email, mobile, password, confPassword, visitType;

  SignupDetails() {
    name = null;
    email = null;
    mobile = null;
    password = null;
    confPassword = null;
    visitType = null;
  }

  Map<String, String> toJson() => {
        super.name: name ?? "",
        super.email: email ?? "",
        super.mobile: mobile ?? "",
        super.password: password ?? "",
        super.visitType: visitType ?? ""
      };

  SignupDetails.fromJson(Map<String, String?> data) {
    name = data[super.name] ?? "";
    email = data[super.email] ?? "";
    mobile = data[super.mobile] ?? "";
    password = data[super.password] ?? "";
    confPassword = data[super.confPassword] ?? "";
    visitType = data[super.visitType] ?? "";
  }

  bool isAnyEmpty() => ((name is String && name!.replaceAll(" ", "").isEmpty) ||
          (email is String && email!.replaceAll(" ", "").isEmpty) ||
          (mobile is String && mobile!.replaceAll(" ", "").isEmpty) ||
          (password is String && password!.replaceAll(" ", "").isEmpty) ||
          (confPassword is String &&
              confPassword!.replaceAll(" ", "").isEmpty) ||
          (visitType is String && visitType!.replaceAll(" ", "").isEmpty))
      ? true
      : false;
}
