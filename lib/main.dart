import 'dart:async';

import 'package:battery/battery.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Battery _battery = Battery();
  BatteryState _batteryState;
  int _batteryLevel;
  StreamSubscription<BatteryState> _batteryStateSubscription;

  @override
  void initState(){
    super.initState();
    _batteryStateSubscription = _battery.onBatteryStateChanged.listen((BatteryState state) { 
      setState(() {
        _batteryState = state;
      });
    });
  }

  Future<void> _getLevel() async {
    final int batteryLevel = await _battery.batteryLevel;
    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  @override
  void dispose() {
    super.dispose();
    if(_batteryStateSubscription != null) {
      _batteryStateSubscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Battery Example"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("State: $_batteryState"),
            RaisedButton(
              child: Text("Check Levels"),
              onPressed: _getLevel,
            ),
            Text("Levels: $_batteryLevel %")
          ],
        ),
      ),
    );
  }
}