import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_1/resources/fonts.dart';
import 'package:test_1/resources/routes.dart';
import 'package:test_1/routes/router.dart';
import 'package:test_1/bloc/report/report_bloc.dart'; // Đừng quên import ReportBloc

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReportBloc(), // Cung cấp ReportBloc
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My App',
        theme: ThemeData(
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: Fonts.inter,
          appBarTheme: const AppBarTheme(color: Colors.transparent),
        ),
        onGenerateRoute: generateRoute,
        initialRoute: RouteName.splash,
      ),
    );
  }
}
