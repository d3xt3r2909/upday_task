import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:upday_task/dal/redux/middleware/middleware.dart';
import 'package:upday_task/dal/redux/models/app_state.dart';
import 'package:upday_task/dal/redux/reducers/reducer.dart';
import 'package:upday_task/settings/app_settings.dart';
import 'package:upday_task/settings/dimensions.dart';

class FallbackMaterialLocalisationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const FallbackMaterialLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<MaterialLocalizations> load(Locale locale) =>
      DefaultMaterialLocalizations.load(locale);

  @override
  bool shouldReload(FallbackMaterialLocalisationsDelegate old) => false;
}

class InitialSetup extends StatefulWidget {
  final AppEnvironment environment;

  InitialSetup({@required this.environment}) {
    AppSettings.setEnvironment(environment);
  }

  @override
  InitialSetupState createState() => InitialSetupState();
}

class InitialSetupState extends State<InitialSetup>
    with WidgetsBindingObserver {
  final store = Store<AppState>(
    appReducer,
    initialState: AppState.init(),
    // middleware: appMiddleware(), if you use middleware add function in
    // this list and then you are ready to use
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Notification bar change color
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.white,
    ));

    return StoreProvider(
        store: store,
        child: MaterialApp(
            localizationsDelegates: [
              FlutterI18nDelegate(
                  useCountryCode: false, path: 'assets/flutter_i18n'),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: <Locale>[
              Locale('en')
            ],
            title: 'UpDay Task',
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              appBar: AppBar(
                title: Text('Hello'),
              ),
              body: Container(
                color: Colors.black12,
              ),
            ),
            theme: ThemeData(
              fontFamily: 'Lato',
              brightness: Brightness.light,
              primaryColor: Colors.white,
              primarySwatch: Colors.blue,
              primaryColorDark: Colors.grey[200],
              accentColor: Colors.red,
              iconTheme: IconThemeData(size: AppDimensions.iconSize),
              cursorColor: Theme.of(context).accentColor,
            ),
            // disable OS level text scaling
            builder: (context, child) => MediaQuery(
                child: child,
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1))));
  }
}
