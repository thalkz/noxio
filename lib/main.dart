import 'package:flutter/material.dart';
import 'package:noxio/routes.dart';
import 'package:provider/provider.dart';

import 'models/app_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppModel>(
      create: (context) => AppModel(),
      child: Consumer<AppModel>(
        builder: (context, model, child) {
          return MaterialApp(
            title: 'Noxio',
            theme: model.themeData,
            initialRoute: '/',
            onGenerateRoute: Routes.generateRoute,
          );
        },
      ),
    );
  }
}
