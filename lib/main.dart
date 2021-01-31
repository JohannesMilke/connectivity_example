import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:connectivity_example/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Has Internet?';

  @override
  Widget build(BuildContext context) => OverlaySupport(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: title,
          theme: ThemeData(primarySwatch: Colors.teal),
          home: MainPage(title: title),
        ),
      );
}

class MainPage extends StatefulWidget {
  final String title;

  const MainPage({
    @required this.title,
  });

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  StreamSubscription subscription;

  @override
  void initState() {
    super.initState();

    subscription =
        Connectivity().onConnectivityChanged.listen(showConnectivitySnackBar);
  }

  @override
  void dispose() {
    subscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(padding: EdgeInsets.all(12)),
            child: Text('Check Connection', style: TextStyle(fontSize: 20)),
            onPressed: () async {
              final result = await Connectivity().checkConnectivity();
              showConnectivitySnackBar(result);
            },
          ),
        ),
      );

  void showConnectivitySnackBar(ConnectivityResult result) {
    final hasInternet = result != ConnectivityResult.none;
    final message = hasInternet
        ? 'You have again ${result.toString()}'
        : 'You have no internet';
    final color = hasInternet ? Colors.green : Colors.red;

    Utils.showTopSnackBar(context, message, color);
  }
}
