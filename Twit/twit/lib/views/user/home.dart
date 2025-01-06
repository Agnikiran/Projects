import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../../components/location_selector.dart';
import '../../components/rounded_button.dart';
import '../../core/theme/app_pallete.dart';
import '../../models/location_details.dart';
import '../../models/user_details.dart';
import '../../services/navigation.dart';
import '../nav_bar.dart' as nav;
import '../../constants.dart' as constants;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Map<String, Object?>? _arguments;
  late UserDetails? userDetails;
  late StreamController<LatLng>? _currentLocationStreamController;
  late StreamController<LatLng>? _sourceLocationStreamController,
      _destinationLocationStreamController;
  late TextEditingController? _sourceLocationController,
      _destinationLocationController;
  late List<LatLng>? _bothLocationsController;
  bool _rideRequested = false;
  late LocationDetails? source, destination;
  late bool _oneSelected, _twoSelected, _threeSelected, _fourSelected;

  @override
  void initState() {
    super.initState();
    _sourceLocationController = TextEditingController();
    _destinationLocationController = TextEditingController();
    _currentLocationStreamController = StreamController.broadcast();
    _sourceLocationStreamController = StreamController.broadcast();
    _destinationLocationStreamController = StreamController.broadcast();
    _bothLocationsController = List.empty(growable: true);
    source = null;
    destination = null;
    _oneSelected = false;
    _twoSelected = true;
    _threeSelected = false;
    _fourSelected = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      primary: true,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    constants.appName,
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  LocationSelector(
                    _sourceLocationController!,
                    icon: Icons.pin_drop,
                    placeholder: "Select Starting Point",
                    onTap: (Object? locationDetails) async {
                      if (!mounted) return;
                      if ((locationDetails as List<LocationDetails>)
                          .isNotEmpty) {
                        LocationDetails? data = await showAdaptiveDialog(
                          context: this.context,
                          builder: (context) => Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                clipBehavior: Clip.hardEdge,
                                decoration:
                                    BoxDecoration(color: Colors.grey.shade400),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: ListView.separated(
                                    shrinkWrap: true,
                                    primary: true,
                                    itemBuilder: (context, index) =>
                                        GestureDetector(
                                          onTap: () => Navigator.of(context)
                                              .pop(locationDetails[index]),
                                          child: Container(
                                            padding: const EdgeInsets.all(20),
                                            color: Colors.white24,
                                            child: Text(
                                              locationDetails[index].name
                                                  as String,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  decoration:
                                                      TextDecoration.none,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                          ),
                                        ),
                                    separatorBuilder: (context, index) =>
                                        Divider(
                                          thickness: 2,
                                          color: Colors.grey.shade300,
                                        ),
                                    itemCount: locationDetails.length),
                              ),
                            ],
                          ),
                        );
                        if (data != null) {
                          if (!_sourceLocationStreamController!.isClosed) {
                            _sourceLocationStreamController!.sink
                                .add(LatLng(data.latitude!, data.longitude!));
                          }
                          if (_bothLocationsController!.isEmpty) {
                            _bothLocationsController!.insert(
                                0, LatLng(data.latitude!, data.longitude!));
                          } else {
                            _bothLocationsController![0] =
                                LatLng(data.latitude!, data.longitude!);
                          }
                          _sourceLocationController!.text = data.name as String;
                          source = data;
                          setState(() {});
                        }
                        return;
                      }
                      showAdaptiveDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "No Data Found",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                      await Future.delayed(const Duration(seconds: 2),
                          () async {
                        if (!mounted) return;
                        Navigation.pop(this.context);
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  LocationSelector(
                    _destinationLocationController!,
                    icon: Icons.my_location,
                    placeholder: "Select Ending Point",
                    onTap: (Object? locationDetails) async {
                      if (!mounted) return;
                      if ((locationDetails as List<LocationDetails>)
                          .isNotEmpty) {
                        LocationDetails? data = await showAdaptiveDialog(
                          context: this.context,
                          builder: (context) => Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                clipBehavior: Clip.hardEdge,
                                decoration:
                                    BoxDecoration(color: Colors.grey.shade400),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: ListView.separated(
                                    shrinkWrap: true,
                                    primary: true,
                                    itemBuilder: (context, index) =>
                                        GestureDetector(
                                          onTap: () => Navigator.of(context)
                                              .pop(locationDetails[index]),
                                          child: Container(
                                            padding: const EdgeInsets.all(20),
                                            color: Colors.white24,
                                            child: Text(
                                              locationDetails[index].name
                                                  as String,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  decoration:
                                                      TextDecoration.none,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                          ),
                                        ),
                                    separatorBuilder: (context, index) =>
                                        Divider(
                                          thickness: 2,
                                          color: Colors.grey.shade300,
                                        ),
                                    itemCount: locationDetails.length),
                              ),
                            ],
                          ),
                        );
                        if (data != null) {
                          if (!_destinationLocationStreamController!.isClosed) {
                            _destinationLocationStreamController!.sink
                                .add(LatLng(data.latitude!, data.longitude!));
                          }
                          if (_bothLocationsController!.length < 2) {
                            _bothLocationsController!.insert(
                                1, LatLng(data.latitude!, data.longitude!));
                          } else {
                            _bothLocationsController![1] =
                                LatLng(data.latitude!, data.longitude!);
                          }
                          _destinationLocationController!.text =
                              data.name as String;
                          destination = data;
                          setState(() {});
                        }
                        return;
                      }
                      showAdaptiveDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "No Data Found",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                      await Future.delayed(const Duration(seconds: 2),
                          () async {
                        if (!mounted) return;
                        Navigation.pop(this.context);
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: StreamBuilder(
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
                                      StreamBuilder(
                                          stream:
                                              _sourceLocationStreamController!
                                                  .stream,
                                          builder: (context, snapshot) =>
                                              (snapshot.connectionState ==
                                                          ConnectionState
                                                              .active ||
                                                      snapshot.connectionState ==
                                                          ConnectionState.done)
                                                  ? (snapshot.hasData)
                                                      ? MarkerLayer(
                                                          rotate: true,
                                                          markers: [
                                                            Marker(
                                                                point: snapshot
                                                                    .data!,
                                                                child:
                                                                    const Icon(
                                                                  Icons
                                                                      .location_on,
                                                                  color: Colors
                                                                      .black,
                                                                  size: 30,
                                                                )),
                                                          ],
                                                        )
                                                      : const SizedBox()
                                                  : const SizedBox()),
                                      StreamBuilder(
                                          stream:
                                              _destinationLocationStreamController!
                                                  .stream,
                                          builder: (context, snapshot) =>
                                              (snapshot.connectionState ==
                                                          ConnectionState
                                                              .active ||
                                                      snapshot.connectionState ==
                                                          ConnectionState.done)
                                                  ? (snapshot.hasData)
                                                      ? MarkerLayer(
                                                          rotate: true,
                                                          markers: [
                                                            Marker(
                                                                point: snapshot
                                                                    .data!,
                                                                child:
                                                                    const Icon(
                                                                  Icons
                                                                      .location_on,
                                                                  color: Colors
                                                                      .black,
                                                                  size: 30,
                                                                )),
                                                          ],
                                                        )
                                                      : const SizedBox()
                                                  : const SizedBox()),
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
                            ),
                    ),
                  ),
                ],
              ),
            ),
            if (_bothLocationsController!.length == 2)
              Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(color: AppPallete.primaryColor),
                child: (!_rideRequested)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "${(Geolocator.distanceBetween(_bothLocationsController![0].latitude, _bothLocationsController![0].longitude, _bothLocationsController![1].latitude, _bothLocationsController![1].longitude) / 1000).toStringAsFixed(2)} km",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            ((Geolocator.distanceBetween(
                                                _bothLocationsController![0]
                                                    .latitude,
                                                _bothLocationsController![0]
                                                    .longitude,
                                                _bothLocationsController![1]
                                                    .latitude,
                                                _bothLocationsController![1]
                                                    .longitude) /
                                            1000 /
                                            40 *
                                            60 *
                                            4)
                                        .round() <
                                    60)
                                ? "${(Geolocator.distanceBetween(_bothLocationsController![0].latitude, _bothLocationsController![0].longitude, _bothLocationsController![1].latitude, _bothLocationsController![1].longitude) / 1000 / 40 * 60 * 4).round()} minutes"
                                : "${((Geolocator.distanceBetween(_bothLocationsController![0].latitude, _bothLocationsController![0].longitude, _bothLocationsController![1].latitude, _bothLocationsController![1].longitude) / 1000 / 40 * 60 * 4).round() ~/ 60)} hr ${(Geolocator.distanceBetween(_bothLocationsController![0].latitude, _bothLocationsController![0].longitude, _bothLocationsController![1].latitude, _bothLocationsController![1].longitude) / 1000 / 40 * 60 * 4).round() - (((Geolocator.distanceBetween(_bothLocationsController![0].latitude, _bothLocationsController![0].longitude, _bothLocationsController![1].latitude, _bothLocationsController![1].longitude) / 1000 / 40 * 60 * 4).round() ~/ 60) * 60)} minutes",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          RoundedButton(
                              text: "Request Ride",
                              onTap: () => setState(
                                  () => _rideRequested = !_rideRequested),
                              roundness: 10),
                        ],
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            "Travellers and Time",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w900),
                            textAlign: TextAlign.start,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "No. of Travellers",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700),
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => setState(() {
                                      _oneSelected = !_oneSelected;
                                      if (_twoSelected) {
                                        _twoSelected = !_twoSelected;
                                      } else if (_threeSelected) {
                                        _threeSelected = !_threeSelected;
                                      } else if (_fourSelected) {
                                        _fourSelected = !_fourSelected;
                                      }
                                    }),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: _oneSelected
                                            ? Colors.white
                                            : Colors.indigo.shade900,
                                      ),
                                      child: Text(
                                        "1",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: _oneSelected
                                                ? Colors.indigo.shade900
                                                : Colors.white,
                                            fontWeight: FontWeight.w900),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () => setState(() {
                                      _twoSelected = !_twoSelected;
                                      if (_oneSelected) {
                                        _oneSelected = !_oneSelected;
                                      } else if (_threeSelected) {
                                        _threeSelected = !_threeSelected;
                                      } else if (_fourSelected) {
                                        _fourSelected = !_fourSelected;
                                      }
                                    }),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: _twoSelected
                                            ? Colors.white
                                            : Colors.indigo.shade900,
                                      ),
                                      child: Text(
                                        "2",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: _twoSelected
                                                ? Colors.indigo.shade900
                                                : Colors.white,
                                            fontWeight: FontWeight.w900),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () => setState(() {
                                      _threeSelected = !_threeSelected;
                                      if (_twoSelected) {
                                        _twoSelected = !_twoSelected;
                                      } else if (_oneSelected) {
                                        _oneSelected = !_oneSelected;
                                      } else if (_fourSelected) {
                                        _fourSelected = !_fourSelected;
                                      }
                                    }),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: _threeSelected
                                            ? Colors.white
                                            : Colors.indigo.shade900,
                                      ),
                                      child: Text(
                                        "3",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: _threeSelected
                                                ? Colors.indigo.shade900
                                                : Colors.white,
                                            fontWeight: FontWeight.w900),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () => setState(() {
                                      _fourSelected = !_fourSelected;
                                      if (_twoSelected) {
                                        _twoSelected = !_twoSelected;
                                      } else if (_threeSelected) {
                                        _threeSelected = !_threeSelected;
                                      } else if (_oneSelected) {
                                        _oneSelected = !_oneSelected;
                                      }
                                    }),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: _fourSelected
                                            ? Colors.white
                                            : Colors.indigo.shade900,
                                      ),
                                      child: Text(
                                        "4",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: _fourSelected
                                                ? Colors.indigo.shade900
                                                : Colors.white,
                                            fontWeight: FontWeight.w900),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Schedule Time",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700),
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text(
                                        "Now",
                                        style: TextStyle(
                                            color: Colors.indigo.shade900,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          RoundedButton(
                              text: "Confirm",
                              onTap: () {
                                Navigation.push(
                                    context, Navigation.userRideScreenRoute,
                                    arguments: {
                                      constants.userDetails:
                                          userDetails!.toJson(),
                                      'source': source!.toJson(),
                                      'destination': destination!.toJson(),
                                      'time': (Geolocator.distanceBetween(
                                                  _bothLocationsController![0]
                                                      .latitude,
                                                  _bothLocationsController![0]
                                                      .longitude,
                                                  _bothLocationsController![1]
                                                      .latitude,
                                                  _bothLocationsController![1]
                                                      .longitude) /
                                              1000 /
                                              40 *
                                              60 *
                                              4)
                                          .round(),
                                      'distance': (Geolocator.distanceBetween(
                                                  _bothLocationsController![0]
                                                      .latitude,
                                                  _bothLocationsController![0]
                                                      .longitude,
                                                  _bothLocationsController![1]
                                                      .latitude,
                                                  _bothLocationsController![1]
                                                      .longitude) /
                                              1000)
                                          .toStringAsFixed(2)
                                    });
                                _rideRequested = !_rideRequested;
                                _bothLocationsController!.clear();
                                setState(() {});
                              },
                              roundness: 10),
                        ],
                      ),
              ),
            nav.NavigationBar(
              userDetails: userDetails,
              currentRoute: Navigation.userHomeScreenRoute,
            ),
          ],
        ),
      ),
    );
  }
}
