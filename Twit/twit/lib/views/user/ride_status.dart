import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/driver_details.dart';
import '../../models/notification_data.dart';
import '../../models/signup_details.dart';
import '../../models/user_details.dart';
import '../../services/auth_services.dart';
import '../../services/navigation.dart';

class RideStatus extends StatefulWidget {
  const RideStatus({super.key});

  @override
  State<RideStatus> createState() => _RideStatusState();
}

class _RideStatusState extends State<RideStatus> {
  late Map<String, Object?>? _arguments;
  late DriverDetails? driverData;
  late UserDetails? userDetails;
  late bool? canPop;

  @override
  void initState() {
    super.initState();
    canPop = false;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      QuerySnapshot<Object?> docs = await AuthService().users.get();
      for (QueryDocumentSnapshot doc in docs.docs) {
        SignupDetails details = SignupDetails.fromJson(
            (doc.data() as Map<String, dynamic>).cast<String, String>());
        if (details.name == userDetails!.name &&
            details.mobile == userDetails!.mobile &&
            details.visitType == userDetails!.visitType) {
          CollectionReference ridesRef =
              FirebaseFirestore.instance.collection('users/${doc.id}/rides');
          ridesRef.snapshots().listen((querySnapshot) async {
            for (var change in querySnapshot.docChanges) {
              NotificationData notificationData = NotificationData.fromJson(
                  change.doc.data() as Map<String, dynamic>);
              if (notificationData.rideAccepted as bool) {
                if (!mounted) return;
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    useRootNavigator: true,
                    useSafeArea: true,
                    builder: (context) => const Center(
                          child: CircularProgressIndicator(),
                        ));
                Navigation.pop(context);
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  useRootNavigator: true,
                  useSafeArea: true,
                  builder: (context) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: const Text(
                          "Driver Accepted the ride\nPlease wait for the driver to arrive at your location",
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
              } else if (notificationData.rideRejected as bool) {
                if (!mounted) return;
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    useRootNavigator: true,
                    useSafeArea: true,
                    builder: (context) => const Center(
                          child: CircularProgressIndicator(),
                        ));
                Navigation.pop(context);
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  useRootNavigator: true,
                  useSafeArea: true,
                  builder: (context) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: const Text(
                          "Driver Rejected the ride\nWe request you to select another driver",
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
              } else if (notificationData.rideCompleted as bool) {
                if (!mounted) return;
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    useRootNavigator: true,
                    useSafeArea: true,
                    builder: (context) => const Center(
                          child: CircularProgressIndicator(),
                        ));
                Navigation.pop(context);
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  useRootNavigator: true,
                  useSafeArea: true,
                  builder: (context) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: const Text(
                          "Ride Completed\nPlease rate our app",
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
              }
              if (notificationData.rideAccepted! ||
                  notificationData.rideCompleted! ||
                  notificationData.rideRejected!) {
                await Future.delayed(const Duration(seconds: 3), () async {
                  if (!mounted) return;
                  Navigation.pop(context);
                  Navigation.pop(context);
                  setState(() => canPop = true);
                });
              }
            }
          });
          break;
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, Object?>;
    userDetails =
        UserDetails.fromJson(_arguments!['user'] as Map<String, String>);
    driverData =
        DriverDetails.fromJson(_arguments!['driver'] as Map<String, dynamic>);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop!,
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        primary: true,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900),
                    children: [
                      const TextSpan(text: "Driver: "),
                      TextSpan(text: driverData!.name!),
                    ]),
              ),
              Text(
                driverData!.mobile!,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900),
                textAlign: TextAlign.center,
              ),
              Text(
                driverData!.email!,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                "Waiting for response",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w900),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
