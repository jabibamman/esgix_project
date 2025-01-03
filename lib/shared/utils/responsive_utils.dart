import 'package:flutter/cupertino.dart';

int calculateOffset(BuildContext context) {
  final screenHeight = MediaQuery.of(context).size.height;
  const tweetHeight = 150.0;
  final tweetsPerScreen = (screenHeight / tweetHeight).ceil();
  return tweetsPerScreen + 3;
}
