import 'package:flutter/material.dart';
import '../constants.dart' as constants;
import '../main.dart';
import '../models/user_details.dart';
import '../services/navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;
  late UserDetails? userDetails = null;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animationController.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Map<String, String>? data = await storage.readAll();
      if (data.isNotEmpty) {
        userDetails = UserDetails.fromJson(data);
      }
      _animationController.addStatusListener((status) async {
        if (status == AnimationStatus.completed) {
          await Future.delayed(const Duration(seconds: 2), () async {
            if (userDetails != null) {
              await Navigation.goToHome(
                  context,
                  userDetails!.visitType == constants.user
                      ? Navigation.userHomeScreenRoute
                      : Navigation.driverHomeScreenRoute,
                  arguments: {constants.userDetails: userDetails!.toJson()});
              return;
            }
            await Navigation.popAndPush(
                context, Navigation.decisionScreenRoute);
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      primary: true,
      body: FadeTransition(
        opacity: _animation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                  children: [
                    TextSpan(
                        text: constants.appName,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                        )),
                    TextSpan(text: " - "),
                    TextSpan(text: constants.appMotto),
                  ],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    shadows: [
                      BoxShadow(
                        color: Colors.black45,
                        blurRadius: 10,
                        spreadRadius: 5,
                        offset: Offset(2, 0),
                      )
                    ],
                  )),
            ),
            Image.asset(
              constants.appLogoImage,
              alignment: Alignment.center,
              fit: BoxFit.scaleDown,
              scale: 5.0,
            ),
            const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
