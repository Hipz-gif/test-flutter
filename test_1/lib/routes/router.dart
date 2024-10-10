import 'package:test_1/page/report_page.dart';
import 'package:test_1/view/page_under_construction.dart';

import '../resources/routes.dart';

import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RouteName.splash:
      return _pageBuilder((_) => const ReportPage(), settings: settings);

    default:
      return _pageBuilder((_) => const PageUnderConstruction(),
          settings: settings);
  }
}

PageRouteBuilder<dynamic> _pageBuilder(Widget Function(BuildContext) page,
    {required RouteSettings settings}) {
  return PageRouteBuilder(
      settings: settings,
      transitionsBuilder: (_, animation, __, child) =>
          FadeTransition(opacity: animation, child: child),
      pageBuilder: (context, _, __) => page(context));
}
