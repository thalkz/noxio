import 'package:flutter/material.dart';
import 'package:noxio/models/app_model.dart';
import 'package:noxio/models.dart';
import 'package:provider/provider.dart';

class NoxioColors {
  static Color blue(BuildContext context) {
    return Provider.of<AppModel>(context, listen: false).primary;
  }

  static Color red(BuildContext context) {
    return Provider.of<AppModel>(context, listen: false).secondary;
  }

  static Color white(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return Colors.grey.shade800;
    } else {
      return Colors.grey.shade300;
    }
  }

  static Color black(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.light) {
      return Colors.black87;
    } else {
      return Colors.grey.shade200;
    }
  }

  static Color player(BuildContext context, Player player) {
    return player == Player.blue ? blue(context) : red(context);
  }
}
