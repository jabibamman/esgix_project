import 'package:timeago/timeago.dart' as timeago;

String formatTwitterDate(DateTime createdAt) {
  final now = DateTime.now();
  final difference = now.difference(createdAt);

  if (difference.inSeconds < 60) {
    return timeago.format(createdAt, locale: 'en_short');
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} min';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} h';
  } else if (createdAt.year == now.year) {
    return '${createdAt.day}/${createdAt.month}';
  } else {
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }
}
