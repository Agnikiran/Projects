import 'package:flutter/material.dart';
import '../core/theme/app_pallete.dart';
import '../models/user_details.dart';
import '../services/navigation.dart';
import '../constants.dart' as constants;

class NavigationBar extends StatefulWidget {
  final String currentRoute;
  final UserDetails? userDetails;
  const NavigationBar(
      {required this.currentRoute, required this.userDetails, super.key});

  @override
  State<NavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: const BoxDecoration(
        color: AppPallete.primaryColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () async {
              if (widget.currentRoute == Navigation.userHomeScreenRoute ||
                  widget.currentRoute == Navigation.driverHomeScreenRoute) {
                return;
              }
              await Navigation.goToHome(
                  context,
                  (widget.userDetails!.visitType == constants.user)
                      ? Navigation.userHomeScreenRoute
                      : Navigation.driverHomeScreenRoute,
                  arguments: {
                    constants.userDetails: widget.userDetails!.toJson()
                  });
            },
            child: const Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(constants.homeIcon),
                Text("Home"),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (widget.currentRoute == Navigation.profileScreenRoute) {
                return;
              }
              Navigation.push(context, Navigation.profileScreenRoute,
                  arguments: {
                    constants.userDetails: widget.userDetails!.toJson()
                  });
            },
            child: const Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(constants.profileIcon),
                Text("Profile"),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (widget.currentRoute == Navigation.settingsScreenRoute) return;
              Navigation.push(context, Navigation.settingsScreenRoute,
                  arguments: {
                    constants.userDetails: widget.userDetails!.toJson()
                  });
            },
            child: const Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(constants.settingsIcon),
                Text("Settings"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
