import 'package:redux/redux.dart';
import 'package:upday_task/dal/redux/actions/gallery.dart';
import 'package:upday_task/dal/redux/models/app_state.dart';

Middleware<AppState> middlewareGallery() =>
        (Store<AppState> store, action, NextDispatcher next) async {

      if (action is GetAndUpdateGallery) {

      }


      // THIS calls the reducer. Every action that is handled before this will
      // have the state before the change. Everything called after this
      // will have the changed state
      next(action);
    };

