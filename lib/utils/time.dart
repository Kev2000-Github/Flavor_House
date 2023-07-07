import 'package:flavor_house/common/config.dart';
import 'package:timeago/timeago.dart' as timeago;

String formatTimeAgo(DateTime from){
  return timeago.format(from, locale: Config.locale);
}