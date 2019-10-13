import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:upday_task/dal/redux/models/app_state.dart';
import 'package:redux/redux.dart';
import 'package:upday_task/pages/gallery/view_model/gallery.dart';
import 'package:upday_task/pages/gallery/widgets/item_list.dart';
import 'package:upday_task/pages/gallery/widgets/shimmer_grid.dart';
import 'package:upday_task/pages/gallery/widgets/shimmer_item.dart';
import 'package:upday_task/settings/colors.dart';
import 'package:upday_task/settings/dimensions.dart';

/// Simple page which is showing gallery of images downloaded from shutter
/// stock API service
class GalleryPage extends StatefulWidget {
  GalleryPage();

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final ScrollController _scrollController = ScrollController();

  // State of this page
  GalleryBlock _galleryBlock;

  @override
  void initState() {
    super.initState();
    // Show or hide bottom bar after scrolling
    _scrollController.addListener(() => _galleryBlock.bbScrollControllerSink
        .add(_scrollController.position.userScrollDirection));
  }

  @override
  Widget build(BuildContext context) => StoreConnector(
        onInit: (Store<AppState> store) {
          // Initialize business layer with current store
          _galleryBlock = GalleryBlock(
            store: store,
          );
          // Catch data on init method
          _galleryBlock.itemEventSink.add(ItemEvent(index: 0, isInitial: true));
        },
        converter: (Store<AppState> store) => store.state,
        builder: (context, AppState model) => StreamBuilder(
          stream: _galleryBlock.outBottomBarVisibility,
          initialData: false,
          builder: (BuildContext context, AsyncSnapshot<bool> showBottomBar) =>
              Scaffold(
            appBar: AppBar(
              title: Image.asset(
                'assets/images/shutter_stock.png',
                height: AppDimensions.appBarSize,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            // We can use visibility widget but it can be expensive-performance
            floatingActionButton: showBottomBar.data
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
                          .then(
                            (value) =>
                                _galleryBlock.bbVisibilitySink.add(false),
                          );
                    },
                  )
                : null,
            bottomNavigationBar: showBottomBar.data
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
        ),
      );

  /// Build body of the page
  Widget _buildBody(AppState state) => OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) =>
            AnimatedSwitcher(
          duration: const Duration(seconds: 1),
          child: _galleryBlock.showLoaderList
              ? JourneyShimmerList(orientation)
              : StreamBuilder(
                  stream: _galleryBlock.outItem,
                  initialData: false,
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) =>
                          Container(
                    color: Theme.of(context).primaryColorLight,
                    child: GridView.builder(
                      controller: _scrollController,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            orientation == Orientation.portrait ? 2 : 3,
                      ),
                      key: Key('listview_trip'),
                      itemCount: state.images.length,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemBuilder: ((BuildContext context, int index) {
                        _galleryBlock.itemEventSink
                            .add(ItemEvent(index: index));

                        // Show loading 2 additional loading item buttons
                        // otherwise show normal item with image in it
                        if (snapshot.data) {
                          return Card(child: GalleryShimmerItem());
                        } else {
                          return GalleryItemList(
                            imageUrl: state.images[index].assets['preview'].url,
                          );
                        }
                      }),
                    ),
                  ),
                ),
        ),
      );
}
