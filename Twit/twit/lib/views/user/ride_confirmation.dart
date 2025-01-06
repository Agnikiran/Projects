import 'dart:async';

import 'package:flutter/material.dart';
import '../../components/label_icon.dart';
import '../../components/rounded_button.dart';
import '../../models/driver_details.dart';
import '../../models/location_details.dart';
import '../../models/user_details.dart';
import '../../services/auth_services.dart';
import '../../services/navigation.dart';
import '../../constants.dart' as constants;

class ConfirmRidePage extends StatefulWidget {
  const ConfirmRidePage({super.key});

  @override
  State<ConfirmRidePage> createState() => _ConfirmRidePageState();
}

class _ConfirmRidePageState extends State<ConfirmRidePage> {
  late Map<String, Object?>? _arguments;
  late UserDetails? userDetails;
  late LocationDetails source, destination;
  late String? time, distance;
  late StreamController<List<DriverDetails?>?>? _driversList;

  @override
  void initState() {
    super.initState();
    _driversList = StreamController<List<DriverDetails?>?>.broadcast();
    fetchAllDrivers();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, Object?>;
    userDetails = UserDetails.fromJson(
        _arguments![constants.userDetails] as Map<String, String>);
    source =
        LocationDetails.fromJson(_arguments!['source'] as Map<String, dynamic>);
    destination = LocationDetails.fromJson(
        _arguments!['destination'] as Map<String, dynamic>);
    time = _arguments!['time'].toString();
    distance = _arguments!['distance'].toString();
  }

  Future fetchAllDrivers() async {
    Object? data = await AuthService().getAllDrivers();
    if (data is List<DriverDetails>) {
      if (!_driversList!.isClosed) _driversList!.sink.add(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      primary: true,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Drivers Available",
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  color: Colors.white,
                ),
                clipBehavior: Clip.hardEdge,
                child: StreamBuilder<List<DriverDetails?>?>(
                    stream: _driversList!.stream,
                    builder: (context, snapshot) => (snapshot.connectionState ==
                                ConnectionState.active ||
                            snapshot.connectionState == ConnectionState.done)
                        ? (snapshot.hasData && snapshot.data!.isNotEmpty)
                            ? ListView.separated(
                                shrinkWrap: true,
                                primary: true,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 40),
                                itemBuilder: (context, index) => Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Colors.grey,
                                              spreadRadius: 1,
                                              blurRadius: 15,
                                              blurStyle: BlurStyle.outer),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(
                                                constants.appLogoImage,
                                                height: 100,
                                                fit: BoxFit.scaleDown,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      snapshot.data![index]!
                                                          .name as String,
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 30,
                                                          fontWeight:
                                                              FontWeight.w900),
                                                    ),
                                                    Text(
                                                      snapshot.data![index]!
                                                          .mobile as String,
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w900),
                                                    ),
                                                    RoundedButton(
                                                        text: "Select",
                                                        onTap: () async {
                                                          showDialog(
                                                              context: context,
                                                              barrierDismissible:
                                                                  false,
                                                              useRootNavigator:
                                                                  true,
                                                              useSafeArea: true,
                                                              builder: (context) =>
                                                                  const Center(
                                                                    child:
                                                                        CircularProgressIndicator(),
                                                                  ));
                                                          if (await AuthService()
                                                                  .saveUserRides(
                                                                      userDetails,
                                                                      {
                                                                    'source': source
                                                                        .toJson(),
                                                                    'destination':
                                                                        destination
                                                                            .toJson(),
                                                                    'time':
                                                                        time,
                                                                    'distance':
                                                                        distance,
                                                                    'driver': snapshot
                                                                        .data![
                                                                            index]!
                                                                        .toJson(),
                                                                    'completed':
                                                                        false,
                                                                    'accepted':
                                                                        false,
                                                                    'rejected':
                                                                        false,
                                                                  }) as bool ==
                                                              true) {
                                                            if (!mounted) {
                                                              return;
                                                            }
                                                            Navigation.pop(
                                                                this.context);
                                                            Navigation.popAndPush(
                                                                this.context,
                                                                Navigation
                                                                    .userRideStatusScreenRoute,
                                                                arguments: {
                                                                  'user': userDetails!
                                                                      .toJson(),
                                                                  'driver': snapshot
                                                                      .data![
                                                                          index]!
                                                                      .toJson()
                                                                });
                                                          } else {
                                                            if (!mounted) {
                                                              return;
                                                            }
                                                            Navigation.pop(
                                                                this.context);
                                                          }
                                                        },
                                                        roundness: 10),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          const Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              LabelIcon(
                                                  label: "15",
                                                  icon:
                                                      Icons.thumb_up_outlined),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              LabelIcon(
                                                  label: "4",
                                                  icon: Icons.message_outlined),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              LabelIcon(
                                                  label: "4.4",
                                                  icon: Icons.star),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                      height: 30,
                                    ),
                                itemCount: snapshot.data!.length)
                            : Container(
                                alignment: Alignment.center,
                                child: const Text(
                                  "No Drivers Found",
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                        : const Center(
                            child: CircularProgressIndicator(),
                          )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
