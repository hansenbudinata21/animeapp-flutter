import 'package:flutter/cupertino.dart';

class AppPageRoute extends PageRouteBuilder {
  AppPageRoute({
    required RoutePageBuilder pageBuilder,
    RouteSettings? settings,
  }) : super(
          pageBuilder: pageBuilder,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
          settings: settings,
        );
}
