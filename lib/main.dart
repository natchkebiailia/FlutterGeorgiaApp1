import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: TextTheme(
          body1: TextStyle(color: Colors.white),
          body2: TextStyle(
            color: Colors.white,
            fontSize: 21,
          ),
        ),
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String dropdownValue = 'Georgia';
  Map<dynamic, dynamic> mainData;

  void fetchData(String country) async {
    final response =
        await http.get("https://pomber.github.io/covid19/timeseries.json");

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var jsonData = json.decode(response.body);
      var countryData = jsonData[country];
      var lastDate = countryData[countryData.length - 1];
      setState(() {
        mainData = lastDate;
        print(lastDate);
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData(dropdownValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Column(
                children: <Widget>[
                  Image.asset(
                    "assets/images/corona.jpeg",
                    width: 200,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Corona",
                    style: TextStyle(fontSize: 30),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.white,
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.location_city),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: DropdownButton<String>(
                            value: dropdownValue,
                            isExpanded: true,
                            icon: Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.deepPurple),
                            underline: Container(),
                            onChanged: (String newValue) {
                              fetchData(newValue);
                              setState(() {
                                dropdownValue = newValue;
                              });
                            },
                            items: <String>['Georgia', 'Italy', 'France', 'US']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Information",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Card(
                    number: mainData != null ? mainData["confirmed"] : null,
                    color: Colors.blue,
                    title: "confirmed",
                  ),
                  Card(
                    number: mainData != null ? mainData["recovered"] : null,
                    color: Colors.green,
                    title: "Recovered",
                  ),
                  Card(
                    number: mainData != null ? mainData["deaths"] : null,
                    color: Colors.red,
                    title: "Deaths",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Card extends StatelessWidget {
  final int number;
  final Color color;
  final String title;

  const Card({Key key, this.number, this.color, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return number != null
        ? Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              color: color,
            ),
            padding: EdgeInsets.all(20),
            width: (MediaQuery.of(context).size.width - 100) / 3,
            child: Column(
              children: <Widget>[
                Text(
                  number.toString(),
                  style: Theme.of(context).textTheme.body2,
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          )
        : CircularProgressIndicator();
  }
}
