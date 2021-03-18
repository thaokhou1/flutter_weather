import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

void main() => runApp(WeatherApp());

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  var humidityForecast = List<int>.filled(7, 0);
  int temperature;
  var minTemperatureForecast = List<int>.filled(7, 0);
  var maxTemperatureForecast = List<int>.filled(7, 0);
  String location = 'San Francisco';
  int woeid = 2487956;
  String weather = 'clear';
  String abbreviation = '';
  var abbreviationForecast = List<String>.filled(7, '');
  String errorMessage = '';
  String weatherDescription = '';
  String searchApiUrl =
      'https://www.metaweather.com/api/location/search/?query=';
  String locationApiUrl = 'https://www.metaweather.com/api/location/';

  initState() {
    super.initState();
    fetchLocation();
    fetchLocationDay();
  }

  void fetchLocation() async {
    var locationResult = await http.get(locationApiUrl + woeid.toString());
    var result = json.decode(locationResult.body);
    var consolidatedWeather = result["consolidated_weather"];
    var data = consolidatedWeather[0];

    setState(() {
      temperature = data["the_temp"].round();
      weather = data["weather_state_name"].replaceAll(' ', ' ').toLowerCase();
      abbreviation = data["weather_state_abbr"];
      weatherDescription = data["weather_state_name"];
    });
  }

  void fetchLocationDay() async {
    var today = new DateTime.now();
    for (var i = 0; i < 7; i++) {
      var locationDayResult = await http.get(locationApiUrl +
          woeid.toString() +
          '/' +
          new DateFormat('y/M/d')
              .format(today.add(new Duration(days: i + 1)))
              .toString());
      var result = json.decode(locationDayResult.body);
      var data = result[0];

      setState(() {
        minTemperatureForecast[i] = data["min_temp"].round();
        maxTemperatureForecast[i] = data["max_temp"].round();
        abbreviationForecast[i] = data["weather_state_abbr"];
        humidityForecast[i] = data["humidity"].round();
        weatherDescription = data["weather_state_name"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: Container(
          child: temperature == null
              ? Center(child: CircularProgressIndicator())
              : Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    centerTitle: false,
                    titleSpacing: 20,
                    title: Text(
                      location,
                      style: TextStyle(color: Colors.black, fontSize: 15.0),
                    ),
                    backgroundColor: Colors.white,
                    elevation: 0.0,
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.refresh_sharp,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          // doesn't load atm
                        },
                      )
                    ],
                  ),
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Stack(children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(250, 0, 0, 0),
                          child: Image.network(
                            'https://www.metaweather.com/static/img/weather/png/' +
                                abbreviation +
                                '.png',
                            width: 100,
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            Column(children: <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 250, 0),
                                child: Text(
                                  weatherDescription,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 60.0),
                                ),
                              )
                            ]),
                            Column(children: <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 250, 0),
                                child: Text(
                                  temperature.toString() + ' °',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 60.0),
                                ),
                              ),
                            ])
                          ],
                        ),
                      ]),
                      Column(
                        children: <Widget>[
                          for (var i = 0; i < 7; i++)
                            forecastElement(
                                i + 1,
                                abbreviationForecast[i],
                                minTemperatureForecast[i],
                                maxTemperatureForecast[i],
                                humidityForecast[i]),
                        ],
                      ),
                    ],
                  ),
                )),
    );
  }
}

Widget forecastElement(daysFromNow, abbreviation, minTemperature,
    maxTemperature, humidityForecast) {
  var now = new DateTime.now();
  var oneDayFromNow = now.add(new Duration(days: daysFromNow));
  return Padding(
    padding: const EdgeInsets.all(5),
    child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey, offset: Offset(2.0, 2.0), blurRadius: 6.0)
            ]),
        child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Row(
            children: <Widget>[
              Column(children: <Widget>[
                Text(
                  DateFormat.EEEE().format(oneDayFromNow),
                  // textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  DateFormat.MMMd().format(oneDayFromNow),
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ]),
              Flexible(fit: FlexFit.tight, child: SizedBox(width: 20.0)),
              Padding(
                padding: EdgeInsets.fromLTRB(80, 0, 5, 0),
                child: Image.network(
                  'https://www.metaweather.com/static/img/weather/png/' +
                      abbreviation +
                      '.png',
                  width: 35,
                ),
              ),
              Flexible(fit: FlexFit.tight, child: SizedBox(width: 60.0)),
              Text(
                maxTemperature.toString() + ' °',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
              ),
              Flexible(fit: FlexFit.loose, child: SizedBox(width: 7.0)),
              Text(
                minTemperature.toString() + ' °',
                style: TextStyle(color: Colors.grey, fontSize: 17.0),
              ),
              Flexible(fit: FlexFit.tight, child: SizedBox(width: 50.0)),
              Padding(
                padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
                child: Text(
                  humidityForecast.toString() + ' %',
                  style: TextStyle(color: Colors.black, fontSize: 10.0),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 3, 0),
                child: Image(
                  image: AssetImage('images/down.png'),
                ),
              )
            ],
          ),
        )),
  );
}
