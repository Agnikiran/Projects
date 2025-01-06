abstract class NotificationDataInterface {
  final String _cust = "customer";
  final String _custSourceLoc = "source";
  final String _custDestLoc = "destination";
  final String _totalTime = "time";
  final String _totalDist = "distance";
  final String _rideCompleted = "completed";
  final String _rideAccepted = "accepted";
  final String _rideRejected = "rejected";

  get cust => _cust;
  get custSourceLoc => _custSourceLoc;
  get custDestLoc => _custDestLoc;
  get totalTime => _totalTime;
  get totalDist => _totalDist;
  get rideCompleted => _rideCompleted;
  get rideAccepted => _rideAccepted;
  get rideRejected => _rideRejected;
}
