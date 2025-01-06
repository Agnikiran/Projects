import '../interface/notification_data_interface.dart';
import '../models/location_details.dart';
import '../models/user_details.dart';

class NotificationData extends NotificationDataInterface {
  @override
  late String? totalTime, totalDist;
  @override
  late UserDetails? cust;
  @override
  late LocationDetails? custSourceLoc, custDestLoc;
  @override
  late bool? rideCompleted, rideAccepted, rideRejected;

  NotificationData() {
    cust = null;
    custSourceLoc = null;
    custDestLoc = null;
    totalTime = null;
    totalDist = null;
    rideCompleted = false;
    rideAccepted = false;
    rideRejected = false;
  }

  Map<String, Object> toJson() => {
        super.cust: cust ?? UserDetails(),
        super.custSourceLoc: custSourceLoc ?? "",
        super.custDestLoc: custDestLoc ?? "",
        super.totalTime: totalTime ?? "",
        super.totalDist: totalDist ?? "",
        super.rideCompleted: rideCompleted ?? false,
        super.rideAccepted: rideAccepted ?? false,
        super.rideRejected: rideRejected ?? false,
      };

  NotificationData.fromJson(Map<String, dynamic> data) {
    cust = (data[super.cust] != null)
        ? UserDetails.fromJson(
            (data[super.cust] as Map<String, dynamic>).cast<String, String>())
        : UserDetails();
    custSourceLoc = (data[super.custSourceLoc] != null)
        ? LocationDetails.fromJson(
            data[super.custSourceLoc] as Map<String, dynamic>)
        : LocationDetails();
    custDestLoc = (data[super.custDestLoc] != null)
        ? LocationDetails.fromJson(
            data[super.custDestLoc] as Map<String, dynamic>)
        : LocationDetails();
    totalTime = "${data[super.totalTime] ?? ""}";
    totalDist = "${data[super.totalDist] ?? ""}";
    rideCompleted = data[super.rideCompleted];
    rideAccepted = data[super.rideAccepted];
    rideRejected = data[super.rideRejected];
  }

  bool isMatchDriverSide(NotificationData other) {
    return (cust!.name == other.cust!.name &&
        cust!.mobile == other.cust!.mobile &&
        custSourceLoc!.name == other.custSourceLoc!.name &&
        custSourceLoc!.latitude == other.custSourceLoc!.latitude &&
        custSourceLoc!.longitude == other.custSourceLoc!.longitude &&
        custDestLoc!.name == other.custDestLoc!.name &&
        custDestLoc!.latitude == other.custDestLoc!.latitude &&
        custDestLoc!.longitude == other.custDestLoc!.longitude &&
        rideCompleted == other.rideCompleted &&
        rideAccepted == other.rideAccepted &&
        rideRejected == other.rideRejected);
  }

  bool isMatchUserSide(NotificationData other) {
    return (custSourceLoc!.name == other.custSourceLoc!.name &&
        custSourceLoc!.latitude == other.custSourceLoc!.latitude &&
        custSourceLoc!.longitude == other.custSourceLoc!.longitude &&
        custDestLoc!.name == other.custDestLoc!.name &&
        custDestLoc!.latitude == other.custDestLoc!.latitude &&
        custDestLoc!.longitude == other.custDestLoc!.longitude &&
        rideCompleted == other.rideCompleted &&
        rideAccepted == other.rideAccepted &&
        rideRejected == other.rideRejected);
  }
}
