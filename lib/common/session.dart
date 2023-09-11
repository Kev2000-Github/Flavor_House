
class Session {
  String token = '';
  static final Session _session = Session._internal();

  factory Session() {
    return _session;
  }

  Session._internal();
}