import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:upday_task/dal/redux/actions/gallery.dart';
import 'package:upday_task/dal/redux/models/app_state.dart';
import 'package:redux/redux.dart';
import 'package:upday_task/pages/gallery/widgets/shimmer_grid.dart';
import 'package:upday_task/pages/gallery/widgets/shimmer_item.dart';
import 'package:upday_task/settings/colors.dart';

/// Page which is showing gallery of images downloaded from shutter stock API
/// service
class GalleryPage extends StatefulWidget {
  GalleryPage();

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  bool bottomBarVisibility = false;
  Store<AppState> currentStore;
  int pageNumber = 1;
  int visitedIndex = 0, currentIndex = 0;
  bool _isLoading;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() => bottomBarVisibility = true);
      }

      if (_scrollController.position.userScrollDirection ==
              ScrollDirection.forward &&
          currentIndex == 0) {
        setState(() => bottomBarVisibility = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) => StoreConnector(
        onInit: (Store<AppState> store) {
          currentStore = store;
          _getData(store: store, page: pageNumber);
        },
        converter: (Store<AppState> store) => store.state,
        builder: (context, AppState model) => Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Image.asset('assets/images/shutter_stock.png', height: 250,),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: bottomBarVisibility
              ? FloatingActionButton(
                  backgroundColor: AppColors.primaryLight,
                  child: const Icon(
                    Icons.arrow_upward,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _scrollController
                        .animateTo(0,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInCubic)
                        .then((value) {
                      setState(() => bottomBarVisibility = false);
                    });
                  },
                )
              : null,
          bottomNavigationBar: bottomBarVisibility
              ? BottomAppBar(
                  shape: CircularNotchedRectangle(),
                  notchMargin: 4.0,
                  child: SizedBox(
                    height: 35,
                  ),
                )
              : null,
          body: _buildBody(model),
        ),
      );

  /// Build body of the page
  Widget _buildBody(AppState state) {

    /// Initial loading of images
    if (state?.images?.length == null || state.images.isEmpty) {
      return JourneyShimmerList();
    }

    return Container(
      color: Theme.of(context).primaryColorLight,
      child: GridView.builder(
        controller: _scrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        key: Key('listview_trip'),
        itemCount: state.images.length,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: ((BuildContext context, int index) {
          // Current number of images in gallery
          final int galleryLength = state.images?.length ?? 0;
          currentIndex = index;

          // @TODO 29?????
          if (galleryLength - 1 - index == 15 && galleryLength > 29) {
            _isLoading = true;
            try {
              _getData(store: currentStore, page: pageNumber);
              if (visitedIndex < index) {
                pageNumber++;
              }
            } catch (e) {
              print('Limit has been reached on API side, need more filters');
            }
            visitedIndex = index;
          }
          if (_isLoading && (galleryLength - index <= 2)) {
            return Card(
              child: GalleryShimmerItem(),
            );
          } else {
            return Card(
              color: Colors.black45,
              child: Padding(
                padding: EdgeInsets.all(2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/upday_logo.png',
                    image: state.images[index].assets['preview'].url,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            );
          }
        }),
      ),
    );
  }

  Future<void> _getData(
      {@required Store<AppState> store,
      @required int page,
      int perPage = 30}) async {
    _isLoading = true;

    final galleryAction = RequestGetGallery(page, perPage);

    store.dispatch(galleryAction);

    await galleryAction.completer.future.whenComplete(() {
      setState(() => _isLoading = false);
    });
  }
}
