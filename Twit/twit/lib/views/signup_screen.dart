import 'package:flutter/material.dart';
import '../components/entry.dart';
import '../models/signup_details.dart';
import '../services/auth_services.dart';
import '../services/navigation.dart';
import '../components/rounded_button.dart';
import '../constants.dart' as constants;
import '../core/theme/app_pallete.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late Map<String, Object?>? _arguments;
  late TextEditingController _nameController,
      _emailController,
      _mobileController,
      _passwordController,
      _confPasswordController;
  late SignupDetails? signupDetails;
  @override
  void initState() {
    super.initState();
    signupDetails = SignupDetails();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _mobileController = TextEditingController();
    _passwordController = TextEditingController();
    _confPasswordController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, Object?>;
    signupDetails!.visitType = _arguments![constants.visitType] as String;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Create an accont",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 25),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Entry(
                              controller: _nameController,
                              title: "NAME",
                              isVisibleErrorText:
                                  signupDetails!.name is String &&
                                      signupDetails!.name!
                                          .replaceAll(" ", "")
                                          .isEmpty,
                              keyboardType: TextInputType.name,
                              placeholder: "ENTER YOUR NAME",
                              onChanged: (controller) => setState(
                                  () => signupDetails!.name = controller.text)),
                          const SizedBox(
                            height: 30,
                          ),
                          Entry(
                              controller: _emailController,
                              title: "EMAIL",
                              isVisibleErrorText:
                                  signupDetails!.email is String &&
                                      signupDetails!.email!
                                          .replaceAll(" ", "")
                                          .isEmpty,
                              keyboardType: TextInputType.emailAddress,
                              placeholder: "ENTER YOUR EMAIL ADDRESS",
                              onChanged: (controller) => setState(() =>
                                  signupDetails!.email = controller.text)),
                          const SizedBox(
                            height: 30,
                          ),
                          Entry(
                              controller: _mobileController,
                              title: "MOBILE NUMBER",
                              isVisibleErrorText:
                                  signupDetails!.mobile is String &&
                                      signupDetails!.mobile!
                                          .replaceAll(" ", "")
                                          .isEmpty,
                              keyboardType: TextInputType.phone,
                              placeholder: "ENTER YOUR MOBILE NUMBER",
                              onChanged: (controller) => setState(() =>
                                  signupDetails!.mobile = controller.text)),
                          const SizedBox(
                            height: 30,
                          ),
                          Entry(
                              controller: _passwordController,
                              title: "PASSWORD",
                              isVisibleErrorText:
                                  signupDetails!.password is String &&
                                      signupDetails!.password!
                                          .replaceAll(" ", "")
                                          .isEmpty,
                              keyboardType: TextInputType.visiblePassword,
                              placeholder: "ENTER YOUR PASSWORD",
                              onChanged: (controller) => setState(() =>
                                  signupDetails!.password = controller.text)),
                          const SizedBox(
                            height: 30,
                          ),
                          Entry(
                              controller: _confPasswordController,
                              title: "CONFIRM PASSWORD",
                              isVisibleErrorText:
                                  signupDetails!.confPassword is String &&
                                          signupDetails!.confPassword!
                                              .replaceAll(" ", "")
                                              .isEmpty ||
                                      signupDetails!.confPassword !=
                                          signupDetails!.password,
                              placeholder:
                                  "ENTER YOUR PASSWORD AGAIN TO CONFIRM",
                              keyboardType: TextInputType.visiblePassword,
                              onChanged: (controller) => setState(() =>
                                  signupDetails!.confPassword =
                                      controller.text)),
                          const SizedBox(
                            height: 30,
                          ),
                          RoundedButton(
                              text: "SIGN UP",
                              onTap: () async {
                                if (signupDetails!.isAnyEmpty()) return;
                                if (signupDetails!.confPassword !=
                                    signupDetails!.password) return;
                                showAdaptiveDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    useRootNavigator: true,
                                    useSafeArea: true,
                                    builder: (context) => const Center(
                                          child: CircularProgressIndicator(),
                                        ));
                                Object? userDetails = await AuthService()
                                    .register(signupDetails!.toJson());
                                if (!mounted) return;
                                Navigation.pop(this.context);
                                if (userDetails is bool) {
                                  showAdaptiveDialog(
                                    context: this.context,
                                    barrierDismissible: false,
                                    useRootNavigator: true,
                                    useSafeArea: true,
                                    builder: (context) => Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          padding: const EdgeInsets.all(20),
                                          child: const Text(
                                            "Successfully Signed Up",
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
                                } else {
                                  showAdaptiveDialog(
                                    context: this.context,
                                    barrierDismissible: false,
                                    useRootNavigator: true,
                                    useSafeArea: true,
                                    builder: (context) => Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          padding: const EdgeInsets.all(20),
                                          child: Text(
                                            (userDetails as Map<String,
                                                String>)["error"] as String,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w900),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                await Future.delayed(const Duration(seconds: 3),
                                    () async {
                                  if (!mounted) return;
                                  Navigation.pop(this.context);
                                  Navigation.pop(this.context);
                                });
                              },
                              roundness: 10),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
              ),
              child: Column(
                children: [
                  const Text(
                    "ALREADY HAVE AN ACCOUNT",
                    style: TextStyle(color: AppPallete.primaryColor),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  RoundedButton(
                      text: "SIGN IN",
                      onTap: () => Navigation.pop(context),
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
