import 'package:upday_task/dal/redux/models/app_state.dart';
import 'package:upday_task/dal/redux/reducers/gallery.dart';

AppState appReducer(AppState state, action) => AppState(
  images: galleryReducer(state.images, action),
);

