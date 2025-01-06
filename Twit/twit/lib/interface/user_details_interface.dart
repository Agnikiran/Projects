import '../constants.dart' as constants;

abstract class UserDetailsInterface {
  final String _name = constants.name;
  final String _mobile = constants.mobile;
  final String _email = constants.email;
  final String _visitType = constants.visitType;

  get name => _name;
  get mobile => _mobile;
  get email => _email;
  get visitType => _visitType;
}
