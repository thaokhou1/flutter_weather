import 'dart:convert';
import 'package:flutter_weather/weather/forecaseElement.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../main.dart';

class HomeState extends State<Home> {
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
        debugShowCheckedModeBanner: false,
        home: Container(
            child: temperature == null
                ? Center(child: CircularProgressIndicator())
                : Container(
                    color: Colors.white,
                    child: Stack(children: <Widget>[
                      Container(
                        height: 250,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(35),
                              bottomRight: Radius.circular(35)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                offset: Offset(1.0, 1.0),
                                blurRadius: 3.0)
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 30, 0, 0),
                        child: Text(
                          location,
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.black,
                              fontSize: 15.0),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(340, 30, 0, 0),
                        child: Icon(
                          Icons.refresh_sharp,
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Stack(children: <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(250, 80, 0, 60),
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
                                      padding:
                                          EdgeInsets.fromLTRB(0, 80, 250, 0),
                                      child: Text(
                                        weatherDescription,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            decoration: TextDecoration.none,
                                            color: Colors.black,
                                            fontSize: 40.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ]),
                                  Column(children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 10, 250, 0),
                                      child: Text(
                                        temperature.toString() + ' °',
                                        style: TextStyle(
                                            decoration: TextDecoration.none,
                                            color: Colors.black,
                                            fontSize: 35.0),
                                      ),
                                    ),
                                  ])
                                ],
                              ),
                            ]),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
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
                              ),
                            )
                          ],
                        ),
                      ),
                    ]))));
  }
}
