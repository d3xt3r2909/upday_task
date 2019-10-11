import 'package:redux/redux.dart';
import 'package:upday_task/dal/redux/middleware/gallery.dart';
import 'package:upday_task/dal/redux/models/app_state.dart';

List<Middleware<AppState>> appMiddleware() => [middlewareGallery()].toList();
