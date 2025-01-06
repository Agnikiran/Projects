import 'package:flutter/material.dart';
import '../components/entry.dart';
import '../components/rounded_button.dart';
import '../constants.dart' as constants;
import '../core/theme/app_pallete.dart';
import '../main.dart';
import '../models/login_details.dart';
import '../models/user_details.dart';
import '../services/auth_services.dart';
import '../services/navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late Map<String, Object?>? _arguments;
  late TextEditingController _mobileNumberController;
  late TextEditingController _passController;
  late LoginDetails? loginDetails;

  @override
  void initState() {
    super.initState();
    loginDetails = LoginDetails();
    _mobileNumberController = TextEditingController();
    _passController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, Object?>;
    loginDetails!.visitType = _arguments![constants.visitType] as String;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  constants.loginScreenHeaderText,
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 25),
                ),
                const SizedBox(
                  height: 30,
                ),
                Entry(
                  controller: _mobileNumberController,
                  placeholder: "ENTER YOUR MOBILE NUMBER",
                  isVisibleErrorText: loginDetails!.mobile is String &&
                      loginDetails!.mobile!.replaceAll(" ", "").isEmpty,
                  title: "MOBILE NUMBER",
                  keyboardType: TextInputType.phone,
                  onChanged: (controller) =>
                      setState(() => loginDetails!.mobile = controller.text),
                ),
                const SizedBox(
                  height: 30,
                ),
                Entry(
                  controller: _passController,
                  placeholder: "ENTER YOUR PASSWORD",
                  isVisibleErrorText: loginDetails!.password is String &&
                      loginDetails!.password!.replaceAll(" ", "").isEmpty,
                  keyboardType: TextInputType.visiblePassword,
                  title: "PASSWORD",
                  onChanged: (controller) =>
                      setState(() => loginDetails!.password = controller.text),
                ),
                const SizedBox(
                  height: 30,
                ),
                RoundedButton(
                    text: "SIGN IN",
                    onTap: () async {
                      if (loginDetails!.isAnyEmpty()) return;
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          useRootNavigator: true,
                          useSafeArea: true,
                          builder: (context) => const Center(
                                child: CircularProgressIndicator(),
                              ));
                      Object? validUser =
                          await AuthService().login(loginDetails!.toJson());
                      if (!mounted) return;
                      Navigation.pop(this.context);
                      if (validUser is UserDetails) {
                        if ((await storage.readAll()).isNotEmpty) {
                          await storage.deleteAll();
                        }
                        storage.writeAll({
                          constants.name: validUser.name,
                          constants.mobile: validUser.mobile,
                          constants.visitType: validUser.visitType
                        });
                        if (!mounted) return;
                        await Navigation.goToHome(
                            this.context,
                            validUser.visitType == constants.user
                                ? Navigation.userHomeScreenRoute
                                : Navigation.driverHomeScreenRoute,
                            arguments: {
                              constants.userDetails: validUser.toJson()
                            });
                        return;
                      } else {
                        showDialog(
                          context: this.context,
                          barrierDismissible: false,
                          useRootNavigator: true,
                          useSafeArea: true,
                          builder: (context) => Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.all(20),
                                child: const Text(
                                  "Details Invalid",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        );
                        await Future.delayed(const Duration(seconds: 3),
                            () async {
                          if (!mounted) return;
                          Navigation.pop(this.context);
                        });
                      }
                    },
                    roundness: 10),
                const SizedBox(
                  height: 30,
                ),
                const Text("FORGOT PASSWORD?"),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
              ),
              child: Column(
                children: [
                  const Text(
                    "NEW TO ${constants.appName}",
                    style: TextStyle(color: AppPallete.primaryColor),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  RoundedButton(
                      text: "SIGN UP",
                      onTap: () => Navigation.push(
                          context, Navigation.signupScreenRoute,
                          arguments: _arguments),
                      roundness: 10),
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}
