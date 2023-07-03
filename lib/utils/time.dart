import 'package:flavor_house/common/config.dart' as config;
import 'package:timeago/timeago.dart' as timeago;

String formatTimeAgo(DateTime from){
  return timeago.format(from, locale: config.locale);
}