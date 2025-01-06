import 'package:flutter/material.dart';
import '../views/settings.dart';
import '../views/decision_screen.dart';
import '../views/login_screen.dart';
import '../views/signup_screen.dart';
import '../views/splash_screen.dart';
import '../views/profile.dart';
import '../views/user/home.dart' as user_home;
import '../views/user/ride_confirmation.dart' as user_ride;
import '../views/user/ride_status.dart' as user_ride_status;
import '../views/driver/home.dart' as driver_home;
import '../views/driver/ride_status.dart' as driver_ride_status;

class Navigation {
  static const String homeScreenRoute = '/';
  static const String loginScreenRoute = '/views/login';
  static const String signupScreenRoute = '/views/signup';
  static const String decisionScreenRoute = '/views/decision';
  static const String profileScreenRoute = '/views/profile';
  static const String settingsScreenRoute = '/views/settings';
  static const String userHomeScreenRoute = '/views/user/home';
  static const String userRideScreenRoute = '/views/user/ride';
  static const String userRideStatusScreenRoute = '/views/user/rideStatus';
  static const String driverHomeScreenRoute = '/views/driver/home';
  static const String driverRideStatusScreenRoute = '/views/driver/rideStatus';

  static Map<String, Widget Function(BuildContext context)> routes = {
    Navigation.homeScreenRoute: (context) => const SplashScreen(),
    Navigation.loginScreenRoute: (context) => const LoginScreen(),
    Navigation.signupScreenRoute: (context) => const SignupScreen(),
    Navigation.decisionScreenRoute: (context) => const DecisionScreen(),
    Navigation.profileScreenRoute: (context) => const Profile(),
    Navigation.settingsScreenRoute: (context) => const Settings(),
    Navigation.userHomeScreenRoute: (context) => const user_home.HomeScreen(),
    Navigation.userRideScreenRoute: (context) =>
        const user_ride.ConfirmRidePage(),
    Navigation.driverHomeScreenRoute: (context) =>
        const driver_home.HomeScreen(),
    Navigation.driverRideStatusScreenRoute: (context) =>
        const driver_ride_status.RideStatus(),
    Navigation.userRideStatusScreenRoute: (context) =>
        const user_ride_status.RideStatus(),
  };

  static void push(BuildContext context, String routeName,
      {Object? arguments}) {
    Navigator.of(context).restorablePushNamed(routeName, arguments: arguments);
  }

  static Future<void> popAndPush(BuildContext context, String routeName,
      {Object? arguments}) async {
    await Navigator.of(context)
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  static void pop(BuildContext context) async {
    Navigator.of(context).pop();
  }

  static Future<void> goToHome(BuildContext context, String routeName,
      {Object? arguments}) async {
    await Navigator.of(context).pushNamedAndRemoveUntil(
        routeName, (route) => false,
        arguments: arguments);
  }
}
