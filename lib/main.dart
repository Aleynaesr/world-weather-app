import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/screen/weather_screen.dart';
import 'database/weather_bloc.dart';
import 'database/weather_repo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'World Weather Search',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: BlocProvider(
            create: (context) => WeatherBloc(WeatherRepo()),
            child: WeatherPage(),
          ),
        ));
  }
}
