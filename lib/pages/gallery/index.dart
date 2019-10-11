import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:upday_task/dal/redux/actions/gallery.dart';
import 'package:upday_task/dal/redux/models/app_state.dart';
import 'package:redux/redux.dart';
import 'package:upday_task/settings/app_settings.dart';

/// Page which is showing gallery of images downloaded from shutter stock API
/// service
class GalleryPage extends StatefulWidget {
  GalleryPage();

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> fakeSourceList = [
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
    'https://public-media.interaction-design.org/images/uploads/user-content/1445/cs977W2YrigNGmmEwHlhI0eRuoLI9rSnsEWqXX4c.jpeg',
  ];

  bool _isLoading;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.white,
    ));

    return StoreConnector(
      onInit: (Store<AppState> store) {
        print('print');
        _getData(store);
      },
      converter: (Store<AppState> store) => store.state,
      builder: (context, model) => Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Upday task'),
        ),
        body: _buildBody(model),
      ),
    );
  }

  /// Build body of the page
  Widget _buildBody(AppState state) {

    if(state?.images?.length == null || state.images.isEmpty) {
      return Container(
        child: Text('Loading'),
      );
    }
    return Container(
      color: Colors.black26,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        key: Key('listview_trip'),
        itemCount: state.images.length,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: ((BuildContext context, int index) {
          print('Holder');
          return Card(
            child:
            Image.network(state.images[index].assets['large_thumb'].url),
          );
        }),
      ),
    );
  }

  Future<void> _getData(Store<AppState> store) async {
    _isLoading = true;

    final galleryAction = RequestGetGallery();

    store.dispatch(galleryAction);

    await galleryAction.completer.future.whenComplete(() {
      setState(() => _isLoading = false);
    });
  }
}
