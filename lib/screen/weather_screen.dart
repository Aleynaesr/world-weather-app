import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/database/weather_bloc.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/util/constants.dart';

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

var cityController = TextEditingController();

class _WeatherPageState extends State<WeatherPage> {
  @override
  void initState() {
    super.initState();
    cityController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final WeatherBloc weatherBloc = BlocProvider.of<WeatherBloc>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            child: Image.asset(
              "assets/weather.png",
              fit: BoxFit.contain,
            ),
          ),
        ),
        BlocBuilder<WeatherBloc, WeatherState>(builder: (context, state) {
          print("state");
          print(state);
          if (state is WeatherIsNotSearched)
            return Container(
              padding: EdgeInsets.only(
                left: 32,
                right: 32,
              ),
              child: Column(
                children: [
                  Text(
                    "World Weather",
                    style: TextStyle(
                      fontFamily: 'Kaushan Script',
                      fontSize: 56,
                      fontWeight: FontWeight.w500,
                      color: kTextColor,
                    ),
                  ),
                  Text(
                    "Search",
                    style: TextStyle(
                      fontFamily: 'Kaushan Script',
                      fontSize: 51,
                      fontWeight: FontWeight.w300,
                      color: kTextColor,
                    ),
                  ),
                  SizedBox(
                    height: 55,
                  ),
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    controller: cityController,
                    decoration: InputDecoration(
                      prefixIconColor: kPrimaryColor,
                      suffixIconColor: kPrimaryColor,
                      hoverColor: kPrimaryColor,
                      focusColor: kPrimaryColor,
                      labelText: "City Name",
                      fillColor: Colors.white,
                      prefixIcon: Icon(
                        Icons.search,
                        color: kPrimaryColor,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                          color: kPrimaryColor,
                          style: BorderStyle.solid,
                        ),
                      ),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(color: kPrimaryColor),
                      ),
                    ),
                    style: TextStyle(color: kTextColor),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              color: Colors.white, width: 0.50),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        primary: kPrimaryColor,
                        onPrimary: Colors.white,
                        onSurface: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          weatherBloc.add(FetchWeather(cityController.text));
                        });
                      },
                      child: Text(
                        "Search",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          else if (state is WeatherIsLoading)
            return Center(
              child: CircularProgressIndicator(),
            );
          else if (state is WeatherIsLoaded)
            return ShowWeather(state.getWeather, cityController.text);
          else
            return Column(
              children: [
                Text(
                  "City not found, try again!",
                  style: TextStyle(
                    fontFamily: 'Kaushan Script',
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: kTextColor,
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 32,
                    right: 32,
                  ),
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        side:
                            const BorderSide(color: Colors.white, width: 0.50),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      primary: kPrimaryColor,
                      onPrimary: Colors.white,
                      onSurface: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        BlocProvider.of<WeatherBloc>(context)
                            .add(ResetWeather());
                        cityController.clear();
                      });
                    },
                    child: Text(
                      "Search",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            );
        })
      ],
    );
  }
}

class ShowWeather extends StatelessWidget {
  WeatherModel weatherModel;

  var city;

  ShowWeather(this.weatherModel, this.city);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 32, left: 32, top: 10),
      child: Column(
        children: [
          Text(
            city.toUpperCase(),
            style: TextStyle(
              fontFamily: 'Kaushan Script',
              color: kTextColor,
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Text(
            weatherModel.getTemp.round().toString() + " °C",
            style: TextStyle(
              color: kTextColor,
              fontSize: 50,
            ),
          ),
          Text(
            "Temperature",
            style: TextStyle(color: kPrimaryColor, fontSize: 14),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    weatherModel.getMinTemp.round().toString() + " °C",
                    style: TextStyle(
                      color: kTextColor,
                      fontSize: 30,
                    ),
                  ),
                  Text(
                    "Min Temperature",
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    weatherModel.getMaxTemp.round().toString() + " °C",
                    style: TextStyle(
                      color: kTextColor,
                      fontSize: 30,
                    ),
                  ),
                  Text(
                    "Max Temperature",
                    style: TextStyle(color: kPrimaryColor, fontSize: 14),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.white, width: 0.50),
                  borderRadius: BorderRadius.circular(25),
                ),
                primary: kPrimaryColor,
                onPrimary: Colors.white,
                onSurface: Colors.white,
              ),
              onPressed: () {
                BlocProvider.of<WeatherBloc>(context).add(ResetWeather());
                cityController.clear();
              },
              child: Text(
                "Search",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
