import 'package:shutterstock_flutter/dal/redux/models/app_state.dart';
import 'package:shutterstock_flutter/dal/redux/reducers/gallery.dart';

AppState appReducer(AppState state, action) => AppState(
  images: galleryReducer(state.images, action),
);

