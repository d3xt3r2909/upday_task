import 'package:redux/redux.dart';
import 'package:shutterstock_flutter/dal/redux/middleware/gallery.dart';
import 'package:shutterstock_flutter/dal/redux/models/app_state.dart';

List<Middleware<AppState>> appMiddleware() => [middlewareGallery()].toList();
