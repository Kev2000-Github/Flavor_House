import 'package:flavor_house/common/config.dart';
import 'package:timeago/timeago.dart' as timeago;

String formatTimeAgo(DateTime from){
  return timeago.format(from, locale: Config.locale);
}

bool hasOneDayPassed(DateTime other) {
  DateTime now = DateTime.now();
  return now.difference(other).inDays >= 1;
}