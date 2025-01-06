import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../main.dart';
import '../models/driver_details.dart';
import '../models/login_details.dart';
import '../models/notification_data.dart';
import '../models/signup_details.dart';
import '../models/user_details.dart';
import '../constants.dart' as constants;

class AuthService {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<Object?> getAllDrivers() async {
    QuerySnapshot<Object?> docs = await users.get();
    List<DriverDetails> driversList = List.empty(growable: true);
    for (QueryDocumentSnapshot doc in docs.docs) {
      LoginDetails details = LoginDetails.fromJson(
          (doc.data() as Map<String, dynamic>).cast<String, String>());
      if (details.visitType == constants.user) continue;
      driversList.add(DriverDetails.fromJson(
          (doc.data() as Map<String, dynamic>).cast<String, String>()));
    }
    return driversList;
  }

  Future<Object?> login(Object? data) async => await isUserExists(data);

  Future<Object?> isUserExists(Object? data) async {
    LoginDetails loginData = LoginDetails.fromJson(data as Map<String, String>);
    QuerySnapshot<Object?> docs = await users.get();
    for (QueryDocumentSnapshot doc in docs.docs) {
      LoginDetails details = LoginDetails.fromJson(
          (doc.data() as Map<String, dynamic>).cast<String, String>());
      if (!details.isMatch(loginData)) continue;
      return UserDetails.fromJson(
          (doc.data() as Map<String, dynamic>).cast<String, String>());
    }
    return false;
  }

  Future<Object?> register(Object? data) async {
    if (await isUserAlreadySignedUp(data)) {
      return {"error": "Already Signed Up. Please Login"};
    }
    return users.add(data).then((value) => true).catchError((error) => error);
  }

  Future<bool> isUserAlreadySignedUp(Object? data) async {
    SignupDetails signupData =
        SignupDetails.fromJson(data as Map<String, String>);
    QuerySnapshot<Object?> docs = await users.get();
    for (QueryDocumentSnapshot doc in docs.docs) {
      SignupDetails details = SignupDetails.fromJson(
          (doc.data() as Map<String, dynamic>).cast<String, String>());
      if (details.mobile == signupData.mobile ||
          details.email == signupData.email) return true;
    }
    return false;
  }

  Future<bool?> saveUserRides(UserDetails? user, Object? data) async {
    QuerySnapshot<Object?> docs = await users.get();
    for (QueryDocumentSnapshot doc in docs.docs) {
      SignupDetails details = SignupDetails.fromJson(
          (doc.data() as Map<String, dynamic>).cast<String, String>());
      if (details.visitType == user!.visitType &&
          details.name == user.name &&
          details.mobile == user.mobile) {
        CollectionReference ridesRef =
            FirebaseFirestore.instance.collection('users/${doc.id}/rides');
        return ridesRef
            .add(data)
            .then((value) async => await saveDriverRides(
                    DriverDetails.fromJson(
                        (data as Map<String, dynamic>)['driver']),
                    {
                      'customer': user.toJson(),
                      'source': data['source'],
                      'destination': data['destination'],
                      'time': data['time'],
                      'distance': data['distance'],
                      'completed': data['completed'],
                      'accepted': data['accepted'],
                      'rejected': data['rejected']
                    }))
            .catchError((error) => error);
      }
    }
    return false;
  }

  Future<bool?> saveDriverRides(DriverDetails? driver, Object? data) async {
    QuerySnapshot<Object?> docs = await users.get();
    for (QueryDocumentSnapshot doc in docs.docs) {
      SignupDetails details = SignupDetails.fromJson(
          (doc.data() as Map<String, dynamic>).cast<String, String>());
      if (details.visitType == constants.driver &&
          details.name == driver!.name &&
          details.mobile == driver.mobile &&
          details.email == driver.email) {
        CollectionReference ridesRef =
            FirebaseFirestore.instance.collection('users/${doc.id}/rides');
        return ridesRef
            .add(data)
            .then((value) => true)
            .catchError((error) => error);
      }
    }
    return false;
  }

  Future<bool?> setRideAcceptedByDriver(
      UserDetails? driver, NotificationData? data) async {
    QuerySnapshot<Object?> docs = await users.get();
    for (QueryDocumentSnapshot doc in docs.docs) {
      SignupDetails details = SignupDetails.fromJson(
          (doc.data() as Map<String, dynamic>).cast<String, String>());
      if (details.visitType == driver!.visitType &&
          details.name == driver.name &&
          details.mobile == driver.mobile) {
        CollectionReference ridesRef =
            FirebaseFirestore.instance.collection('users/${doc.id}/rides');
        QuerySnapshot<Object?> rides = await ridesRef.get();
        for (QueryDocumentSnapshot ride in rides.docs) {
          NotificationData rideData =
              NotificationData.fromJson(ride.data() as Map<String, dynamic>);
          if (rideData.isMatchDriverSide(data!)) {
            DocumentReference selectedRide = FirebaseFirestore.instance
                .collection('users/${doc.id}/rides')
                .doc(ride.id);
            return selectedRide
                .update({'accepted': true})
                .then((value) async =>
                    await setRideAcceptedForUser(data.cust, data))
                .catchError((error) => error);
          }
        }
        break;
      }
    }
    return false;
  }

  Future<bool?> setRideAcceptedForUser(
      UserDetails? user, NotificationData? data) async {
    QuerySnapshot<Object?> docs = await users.get();
    for (QueryDocumentSnapshot doc in docs.docs) {
      SignupDetails details = SignupDetails.fromJson(
          (doc.data() as Map<String, dynamic>).cast<String, String>());
      if (details.visitType == user!.visitType &&
          details.name == user.name &&
          details.mobile == user.mobile) {
        CollectionReference ridesRef =
            FirebaseFirestore.instance.collection('users/${doc.id}/rides');
        QuerySnapshot<Object?> rides = await ridesRef.get();
        for (QueryDocumentSnapshot ride in rides.docs) {
          NotificationData rideData =
              NotificationData.fromJson(ride.data() as Map<String, dynamic>);
          if (rideData.isMatchUserSide(data!)) {
            DocumentReference selectedRide = FirebaseFirestore.instance
                .collection('users/${doc.id}/rides')
                .doc(ride.id);
            return selectedRide
                .update({'accepted': true})
                .then((value) => true)
                .catchError((error) => error);
          }
        }
        break;
      }
    }
    return false;
  }

  Future<bool?> setRideRejectedByDriver(
      UserDetails? driver, NotificationData? data) async {
    QuerySnapshot<Object?> docs = await users.get();
    for (QueryDocumentSnapshot doc in docs.docs) {
      SignupDetails details = SignupDetails.fromJson(
          (doc.data() as Map<String, dynamic>).cast<String, String>());
      if (details.visitType == driver!.visitType &&
          details.name == driver.name &&
          details.mobile == driver.mobile) {
        CollectionReference ridesRef =
            FirebaseFirestore.instance.collection('users/${doc.id}/rides');
        QuerySnapshot<Object?> rides = await ridesRef.get();
        for (QueryDocumentSnapshot ride in rides.docs) {
          NotificationData rideData =
              NotificationData.fromJson(ride.data() as Map<String, dynamic>);
          if (rideData.isMatchDriverSide(data!)) {
            DocumentReference selectedRide = FirebaseFirestore.instance
                .collection('users/${doc.id}/rides')
                .doc(ride.id);
            await selectedRide
                .delete()
                .then((value) async =>
                    await setRideRejectedForUser(data.cust, data))
                .catchError((error) => error);
          }
        }
        break;
      }
    }
    return false;
  }

  Future<bool?> setRideRejectedForUser(
      UserDetails? user, NotificationData? data) async {
    QuerySnapshot<Object?> docs = await users.get();
    for (QueryDocumentSnapshot doc in docs.docs) {
      SignupDetails details = SignupDetails.fromJson(
          (doc.data() as Map<String, dynamic>).cast<String, String>());
      if (details.visitType == user!.visitType &&
          details.name == user.name &&
          details.mobile == user.mobile) {
        CollectionReference ridesRef =
            FirebaseFirestore.instance.collection('users/${doc.id}/rides');
        QuerySnapshot<Object?> rides = await ridesRef.get();
        for (QueryDocumentSnapshot ride in rides.docs) {
          NotificationData rideData =
              NotificationData.fromJson(ride.data() as Map<String, dynamic>);
          if (rideData.isMatchUserSide(data!)) {
            DocumentReference selectedRide = FirebaseFirestore.instance
                .collection('users/${doc.id}/rides')
                .doc(ride.id);
            await selectedRide
                .delete()
                .then((value) => true)
                .catchError((error) => error);
          }
        }
        break;
      }
    }
    return false;
  }

  Future<bool?> setRideCompletedByDriver(
      UserDetails? driver, NotificationData? data) async {
    QuerySnapshot<Object?> docs = await users.get();
    for (QueryDocumentSnapshot doc in docs.docs) {
      SignupDetails details = SignupDetails.fromJson(
          (doc.data() as Map<String, dynamic>).cast<String, String>());
      if (details.visitType == driver!.visitType &&
          details.name == driver.name &&
          details.mobile == driver.mobile) {
        CollectionReference ridesRef =
            FirebaseFirestore.instance.collection('users/${doc.id}/rides');
        QuerySnapshot<Object?> rides = await ridesRef.get();
        for (QueryDocumentSnapshot ride in rides.docs) {
          NotificationData rideData =
              NotificationData.fromJson(ride.data() as Map<String, dynamic>);
          if (rideData.isMatchDriverSide(data!)) {
            DocumentReference selectedRide = FirebaseFirestore.instance
                .collection('users/${doc.id}/rides')
                .doc(ride.id);
            return selectedRide
                .update({'completed': true})
                .then((value) async =>
                    await setRideCompletedForUser(data.cust, data))
                .catchError((error) => error);
          }
        }
        break;
      }
    }
    return false;
  }

  Future<bool?> setRideCompletedForUser(
      UserDetails? user, NotificationData? data) async {
    QuerySnapshot<Object?> docs = await users.get();
    for (QueryDocumentSnapshot doc in docs.docs) {
      SignupDetails details = SignupDetails.fromJson(
          (doc.data() as Map<String, dynamic>).cast<String, String>());
      if (details.visitType == user!.visitType &&
          details.name == user.name &&
          details.mobile == user.mobile) {
        CollectionReference ridesRef =
            FirebaseFirestore.instance.collection('users/${doc.id}/rides');
        QuerySnapshot<Object?> rides = await ridesRef.get();
        for (QueryDocumentSnapshot ride in rides.docs) {
          NotificationData rideData =
              NotificationData.fromJson(ride.data() as Map<String, dynamic>);
          if (rideData.isMatchDriverSide(data!)) {
            DocumentReference selectedRide = FirebaseFirestore.instance
                .collection('users/${doc.id}/rides')
                .doc(ride.id);
            return selectedRide
                .update({'completed': true})
                .then((value) => true)
                .catchError((error) => error);
          }
        }
        break;
      }
    }
    return false;
  }

  Future<void> logout() async {
    await storage.deleteAll();
  }
}
