import 'package:flutter/material.dart';
import '../components/button.dart';
import '../constants.dart' as constants;
import '../services/navigation.dart';

class DecisionScreen extends StatefulWidget {
  const DecisionScreen({super.key});

  @override
  State<DecisionScreen> createState() => _DecisionScreenState();
}

class _DecisionScreenState extends State<DecisionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            constants.loginImage,
            fit: BoxFit.fitWidth,
          ),
          Expanded(
              child: Container(
            padding: const EdgeInsets.fromLTRB(20.0, 80.0, 20.0, 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Button(
                            onTap: () => Navigation.push(
                                context, Navigation.loginScreenRoute,
                                arguments: {
                                  constants.visitType: constants.driver
                                }),
                            text: constants.loginDriver,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Button(
                            text: constants.loginUser,
                            onTap: () => Navigation.push(
                                context, Navigation.loginScreenRoute,
                                arguments: {
                                  constants.visitType: constants.user
                                }),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Text(
                  constants.decisionScreenFooterText,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xff7177AB), fontSize: 17),
                ),
              ],
            ),
          )),
        ],
      )),
    );
  }
}
