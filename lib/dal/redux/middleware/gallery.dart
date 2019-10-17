import 'package:redux/redux.dart';
import 'package:shutterstock_flutter/dal/helper/http_request_handler.dart';
import 'package:shutterstock_flutter/dal/helper/path.dart';
import 'package:shutterstock_flutter/dal/model/response/gallery_wrapper.dart';
import 'package:shutterstock_flutter/dal/model/response/http_response_wrapper.dart';
import 'package:shutterstock_flutter/dal/redux/actions/gallery.dart';
import 'package:shutterstock_flutter/dal/redux/models/app_state.dart';

Middleware<AppState> middlewareGallery() =>
        (Store<AppState> store, action, NextDispatcher next) async {

      if (action is RequestGetGallery) {
        try {
          final AppHttpRequestHandler httpClient = AppHttpRequestHandler();

          final Map<String, String> queryParameters = {
            'per_page': action.getPerPageInString,
            'page': action.getPageInString,
          };

          final HttpResponseWrapper responseServer = await httpClient.getHttp(
              queryParameters: queryParameters,
              path: Paths.map[Path.search]);

          final GalleryWrapperModel responseGallery =
          GalleryWrapperModel.parseGalleryWrapper(responseServer.body);

          // check is there images
          store.dispatch(AddImagesAction(responseGallery.images));
          action.completer.complete('Data from API has been added to store');
        } catch (e) {
          action.completer.completeError(e);
        }
      }

      // THIS calls the reducer. Every action that is handled before this will
      // have the state before the change. Everything called after this
      // will have the changed state
      next(action);
    };

