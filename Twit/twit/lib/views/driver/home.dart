import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../../components/rounded_button.dart';
import '../../core/theme/app_pallete.dart';
import '../../models/notification_data.dart';
import '../../models/signup_details.dart';
import '../../models/user_details.dart';
import '../../services/auth_services.dart';
import '../../services/navigation.dart';
import '../../constants.dart' as constants;
import '../nav_bar.dart' as nav;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Map<String, Object?>? _arguments;
  late UserDetails? userDetails;
  late StreamController<LatLng>? _currentLocationStreamController;
  late bool _showNotificationModal;
  late StreamController<List<NotificationData>?>?
      _notificationsStreamController;
  late List<LatLng>? _bothLocationsController;

  @override
  void initState() {
    super.initState();
    _showNotificationModal = false;
    _currentLocationStreamController = StreamController.broadcast();
    _notificationsStreamController = StreamController.broadcast();
    _bothLocationsController = List.empty(growable: true);
    fetchCurrentLocation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, Object?>;
    userDetails = UserDetails.fromJson(
        _arguments![constants.userDetails] as Map<String, String>);
  }

  Future<void> fetchCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    LatLng? currentLocation;
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      currentLocation = LatLng(position.latitude, position.longitude);
    }
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      currentLocation = LatLng(position.latitude, position.longitude);
    }
    if (!_currentLocationStreamController!.isClosed &&
        currentLocation is LatLng) {
      _currentLocationStreamController!.sink.add(currentLocation);
    }
  }

  Future<void> _displayNotificationPopupModal() async {
    setState(() => _showNotificationModal = !_showNotificationModal);
    List<NotificationData>? notifications = List.empty(growable: true);
    if (_showNotificationModal) {
      QuerySnapshot<Object?> docs = await AuthService().users.get();
      for (QueryDocumentSnapshot doc in docs.docs) {
        SignupDetails details = SignupDetails.fromJson(
            (doc.data() as Map<String, dynamic>).cast<String, String>());
        if (details.name == userDetails!.name &&
            details.mobile == userDetails!.mobile &&
            details.visitType == userDetails!.visitType) {
          CollectionReference ridesRef =
              FirebaseFirestore.instance.collection('users/${doc.id}/rides');
          ridesRef.snapshots().listen((querySnapshot) {
            for (var change in querySnapshot.docChanges) {
              notifications.add(NotificationData.fromJson(
                  change.doc.data() as Map<String, dynamic>));
            }
            if (!_notificationsStreamController!.isClosed) {
              _notificationsStreamController!.sink.add(notifications);
            }
          });
          break;
        }
      }
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
            Stack(
              children: [
                const Center(
                  child: Text(
                    constants.appName,
                    style: TextStyle(fontSize: 40, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: () => _displayNotificationPopupModal(),
                    child: Container(
                        padding: const EdgeInsets.all(20),
                        color: Colors.transparent,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.notifications,
                          size: 20,
                        )),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Stack(
                children: [
                  StreamBuilder<LatLng?>(
                      stream: _currentLocationStreamController!.stream,
                      builder: (context, snapshot) => (snapshot
                                      .connectionState ==
                                  ConnectionState.active ||
                              snapshot.connectionState == ConnectionState.done)
                          ? (snapshot.hasData)
                              ? FlutterMap(
                                  options: MapOptions(
                                      initialCenter: snapshot.data!,
                                      initialZoom: 18),
                                  children: [
                                      TileLayer(
                                        urlTemplate:
                                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                        userAgentPackageName:
                                            'com.example.twit',
                                      ),
                                      Visibility(
                                        visible: _bothLocationsController!
                                            .isNotEmpty,
                                        child: PolylineLayer(
                                          polylines: [
                                            Polyline(
                                                color: AppPallete.primaryColor,
                                                strokeWidth: 5,
                                                points:
                                                    _bothLocationsController!),
                                          ],
                                        ),
                                      ),
                                      (_bothLocationsController!.isEmpty)
                                          ? MarkerLayer(
                                              markers: [
                                                Marker(
                                                    point: snapshot.data!,
                                                    rotate: true,
                                                    child: const Icon(
                                                      Icons.location_on,
                                                      color: Colors.black,
                                                      size: 30,
                                                    )),
                                              ],
                                            )
                                          : MarkerLayer(
                                              markers: [
                                                Marker(
                                                    point:
                                                        _bothLocationsController![
                                                            0],
                                                    rotate: true,
                                                    child: const Icon(
                                                      Icons.location_on,
                                                      color: Colors.black,
                                                      size: 30,
                                                    )),
                                                Marker(
                                                    point:
                                                        _bothLocationsController![
                                                            1],
                                                    rotate: true,
                                                    child: const Icon(
                                                      Icons.location_on,
                                                      color: Colors.black,
                                                      size: 30,
                                                    )),
                                              ],
                                            ),
                                    ])
                              : FlutterMap(
                                  options: const MapOptions(
                                    initialCenter: LatLng(1.55, 1.66),
                                    initialZoom: 18,
                                  ),
                                  children: [
                                    TileLayer(
                                      urlTemplate:
                                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                      userAgentPackageName: 'com.example.twit',
                                    )
                                  ],
                                )
                          : const Center(
                              child: CircularProgressIndicator(),
                            )),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: nav.NavigationBar(
                      userDetails: userDetails,
                      currentRoute: Navigation.driverHomeScreenRoute,
                    ),
                  ),
                  if (_showNotificationModal)
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
                            child: Text(
                              "Notifications",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          StreamBuilder(
                            stream: _notificationsStreamController!.stream,
                            builder: (context, snapshot) =>
                                (snapshot.connectionState ==
                                            ConnectionState.active ||
                                        snapshot.connectionState ==
                                            ConnectionState.done)
                                    ? (snapshot.hasData &&
                                            snapshot.data!.isNotEmpty)
                                        ? Expanded(
                                            child: ListView.separated(
                                                itemBuilder:
                                                    (context, index) =>
                                                        Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: (snapshot
                                                                          .data![
                                                                              index]
                                                                          .rideCompleted! ||
                                                                      snapshot
                                                                          .data![
                                                                              index]
                                                                          .rideAccepted!)
                                                                  ? Colors.grey
                                                                  : (snapshot
                                                                          .data![
                                                                              index]
                                                                          .rideRejected!)
                                                                      ? Colors
                                                                          .red
                                                                      : Colors
                                                                          .green,
                                                            ),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(20),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .stretch,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          bottom:
                                                                              10),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      const Text(
                                                                        "New Ride",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.w900,
                                                                            fontSize: 20),
                                                                      ),
                                                                      Flexible(
                                                                        child:
                                                                            RichText(
                                                                          text: TextSpan(
                                                                              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                                                                              children: [
                                                                                const TextSpan(text: "Customer: "),
                                                                                TextSpan(text: snapshot.data![index].cust!.name)
                                                                              ]),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          bottom:
                                                                              5),
                                                                  child:
                                                                      RichText(
                                                                    text: TextSpan(
                                                                        style: const TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w700),
                                                                        children: [
                                                                          const TextSpan(
                                                                              text: "Starting Point: "),
                                                                          TextSpan(
                                                                              text: snapshot.data![index].custSourceLoc!.name)
                                                                        ]),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          bottom:
                                                                              5),
                                                                  child:
                                                                      RichText(
                                                                    text: TextSpan(
                                                                        style: const TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w700),
                                                                        children: [
                                                                          const TextSpan(
                                                                              text: "Ending Point: "),
                                                                          TextSpan(
                                                                              text: snapshot.data![index].custDestLoc!.name)
                                                                        ]),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          bottom:
                                                                              5),
                                                                  child:
                                                                      RichText(
                                                                    text: TextSpan(
                                                                        style: const TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w700),
                                                                        children: [
                                                                          const TextSpan(
                                                                              text: "Total Distance: "),
                                                                          TextSpan(
                                                                              text: "${snapshot.data![index].totalDist} km")
                                                                        ]),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          bottom:
                                                                              5),
                                                                  child:
                                                                      RichText(
                                                                    text: TextSpan(
                                                                        style: const TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w700),
                                                                        children: [
                                                                          const TextSpan(
                                                                              text: "Approx Time: "),
                                                                          TextSpan(
                                                                              text: "${snapshot.data![index].totalTime} minutes")
                                                                        ]),
                                                                  ),
                                                                ),
                                                                if (!(snapshot
                                                                        .data![
                                                                            index]
                                                                        .rideAccepted! ||
                                                                    snapshot
                                                                        .data![
                                                                            index]
                                                                        .rideCompleted! ||
                                                                    snapshot
                                                                        .data![
                                                                            index]
                                                                        .rideRejected!))
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            10),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        RoundedButton(
                                                                            text:
                                                                                "Accept",
                                                                            color: Colors
                                                                                .white,
                                                                            textColor: Colors
                                                                                .green,
                                                                            onTap:
                                                                                () async {
                                                                              showDialog(
                                                                                  context: context,
                                                                                  barrierDismissible: false,
                                                                                  useRootNavigator: true,
                                                                                  useSafeArea: true,
                                                                                  builder: (context) => const Center(
                                                                                        child: CircularProgressIndicator(),
                                                                                      ));
                                                                              if (await AuthService().setRideAcceptedByDriver(userDetails, snapshot.data![index]) as bool == true) {
                                                                                _showNotificationModal = !_showNotificationModal;
                                                                                if (!mounted) return;
                                                                                Navigation.push(this.context, Navigation.driverRideStatusScreenRoute, arguments: {
                                                                                  'status': 'Accepting'
                                                                                });
                                                                                await Future.delayed(const Duration(seconds: 3), () async {
                                                                                  if (!mounted) return;
                                                                                  Navigation.pop(this.context);
                                                                                });
                                                                                if (!mounted) return;
                                                                                _bothLocationsController!.add(LatLng(snapshot.data![index].custSourceLoc!.latitude!, snapshot.data![index].custSourceLoc!.longitude!));
                                                                                _bothLocationsController!.add(LatLng(snapshot.data![index].custDestLoc!.latitude!, snapshot.data![index].custDestLoc!.longitude!));
                                                                                if (!_currentLocationStreamController!.isClosed) {
                                                                                  _currentLocationStreamController!.sink.add(_bothLocationsController![0]);
                                                                                }
                                                                                Navigation.pop(this.context);
                                                                              } else {
                                                                                _showNotificationModal = !_showNotificationModal;
                                                                                if (!mounted) return;
                                                                                Navigation.pop(this.context);
                                                                              }
                                                                              setState(() {});
                                                                            },
                                                                            roundness:
                                                                                10),
                                                                        RoundedButton(
                                                                            text:
                                                                                "Reject",
                                                                            color: Colors
                                                                                .red,
                                                                            onTap:
                                                                                () async {
                                                                              showDialog(
                                                                                  context: context,
                                                                                  barrierDismissible: false,
                                                                                  useRootNavigator: true,
                                                                                  useSafeArea: true,
                                                                                  builder: (context) => const Center(
                                                                                        child: CircularProgressIndicator(),
                                                                                      ));
                                                                              if (await AuthService().setRideRejectedByDriver(userDetails, snapshot.data![index]) as bool == true) {
                                                                                _showNotificationModal = !_showNotificationModal;
                                                                                if (!mounted) return;
                                                                                Navigation.push(this.context, Navigation.driverRideStatusScreenRoute, arguments: {
                                                                                  'status': 'Rejecting'
                                                                                });
                                                                                await Future.delayed(const Duration(seconds: 3), () async {
                                                                                  if (!mounted) return;
                                                                                  Navigation.pop(this.context);
                                                                                });
                                                                                if (!mounted) return;
                                                                                _bothLocationsController!.add(LatLng(snapshot.data![index].custSourceLoc!.latitude!, snapshot.data![index].custSourceLoc!.longitude!));
                                                                                _bothLocationsController!.add(LatLng(snapshot.data![index].custDestLoc!.latitude!, snapshot.data![index].custDestLoc!.longitude!));
                                                                                if (!_currentLocationStreamController!.isClosed) {
                                                                                  _currentLocationStreamController!.sink.add(_bothLocationsController![0]);
                                                                                }
                                                                                Navigation.pop(this.context);
                                                                              } else {
                                                                                _showNotificationModal = !_showNotificationModal;
                                                                                if (!mounted) return;
                                                                                Navigation.pop(this.context);
                                                                              }
                                                                              setState(() {});
                                                                            },
                                                                            roundness:
                                                                                10),
                                                                      ],
                                                                    ),
                                                                  ),
                                                              ],
                                                            )),
                                                separatorBuilder:
                                                    (context, index) =>
                                                        const Divider(),
                                                itemCount:
                                                    snapshot.data!.length),
                                          )
                                        : Expanded(
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: const Text(
                                                "No Notifications Available",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w900),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          )
                                    : Expanded(
                                        child: Container(
                                            alignment: Alignment.center,
                                            child:
                                                const CircularProgressIndicator()),
                                      ),
                          )
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
