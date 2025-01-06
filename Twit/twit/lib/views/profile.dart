import 'package:flutter/material.dart';
import '../models/user_details.dart';
import '../services/navigation.dart';
import '../constants.dart' as constants;
import 'nav_bar.dart' as nav;

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Map<String, Object?>? _arguments;
  late UserDetails? userDetails;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, Object?>;
    userDetails = UserDetails.fromJson(
        _arguments![constants.userDetails] as Map<String, String>);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.only(top: 80),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    constants.appName,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Image.asset(
                    constants.appLogoImage,
                    fit: BoxFit.fitHeight,
                    height: 100,
                    alignment: Alignment.center,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    userDetails!.name as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 40, color: Colors.white),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "Contact Number",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      userDetails!.mobile as String,
                      style: const TextStyle(fontSize: 20, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            nav.NavigationBar(
              userDetails: userDetails,
              currentRoute: Navigation.profileScreenRoute,
            ),
          ],
        ),
      ),
    );
  }
}
