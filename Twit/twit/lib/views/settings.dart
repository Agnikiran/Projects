import 'package:flutter/material.dart';
import '../components/rounded_button.dart';
import '../services/auth_services.dart';
import '../services/navigation.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RoundedButton(
            text: "Logout",
            onTap: () async {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );
              await AuthService().logout();
              await Future.delayed(const Duration(seconds: 3), () {
                Navigation.goToHome(context, Navigation.homeScreenRoute);
              });
            },
            roundness: 10),
      ),
    );
  }
}
