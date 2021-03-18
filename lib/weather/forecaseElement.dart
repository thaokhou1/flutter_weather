import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget forecastElement(daysFromNow, abbreviation, minTemperature,
    maxTemperature, humidityForecast) {
  var now = new DateTime.now();
  var oneDayFromNow = now.add(new Duration(days: daysFromNow));
  return Material(
      type: MaterialType.transparency,
      child: Padding(
          padding: EdgeInsets.only(top: 20),
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(2.0, 2.0),
                          blurRadius: 6.0)
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Row(
                    children: <Widget>[
                      Column(children: <Widget>[
                        Text(
                          DateFormat.EEEE().format(oneDayFromNow),
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
                      Flexible(
                          fit: FlexFit.tight, child: SizedBox(width: 20.0)),
                      Padding(
                        padding: EdgeInsets.fromLTRB(60, 0, 5, 0),
                        child: Image.network(
                          'https://www.metaweather.com/static/img/weather/png/' +
                              abbreviation +
                              '.png',
                          width: 35,
                        ),
                      ),
                      Text(
                        maxTemperature.toString() + ' ° ',
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
                      Flexible(
                          fit: FlexFit.tight, child: SizedBox(width: 50.0)),
                      Padding(
                        padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
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
          )));
}
