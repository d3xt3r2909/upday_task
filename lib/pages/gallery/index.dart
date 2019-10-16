import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:rxdart/rxdart.dart';
import 'package:upday_task/dal/model/response/gallery_item.dart';
import 'package:upday_task/dal/redux/models/app_state.dart';
import 'package:redux/redux.dart';
import 'package:upday_task/pages/gallery/view_model/gallery.dart';
import 'package:upday_task/pages/gallery/widgets/visibility_widget.dart';
import 'package:upday_task/pages/gallery/widgets/item_list_picker.dart';
import 'package:upday_task/pages/gallery/widgets/shimmer_grid.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  Observable observable;

  // State of this page
  GalleryBlock _galleryBlock;

  @override
  void initState() {
    super.initState();
    // Show or hide bottom bar after scrolling
    _scrollController.addListener(() =>
        _galleryBlock.bbScrollControllerSink
            .add(_scrollController.position.userScrollDirection));
  }

  @override
  Widget build(BuildContext context) =>
      StoreConnector(
        rebuildOnChange: false,
        onInit: (Store<AppState> store) {
          // Initialize business layer with current store
          _galleryBlock = GalleryBlock(
            store: store,
          );

          observable = Observable(_galleryBlock.outErrorHandler);

          observable.listen((something) {
            _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content: Text('Something went wrong'),
                duration: Duration(days: 3),
                action: SnackBarAction(
                  label: 'TRY',
                  onPressed: () {
                    _galleryBlock.itemEventSink.add(
                      ItemEvent(
                          index: _galleryBlock.visitedIndex,
                          isInitial: true,
                          isTryAgain: true),
                    );
                  },
                ),
              ),
            );
          });

          Stream streamGroup = mergeste
          // Catch data on init method
          _galleryBlock.itemEventSink.add(ItemEvent(index: 0, isInitial: true));
        },
        converter: (Store<AppState> store) => store.state,
        builder: (context, AppState model) =>
            Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                title: Image.asset(
                  'assets/images/shutter_stock.png',
                  height: AppDimensions.appBarSize,
                ),
              ),
              floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
              // We can use visibility widget but it can be expensive-performance
              floatingActionButton: StreamBuilder(
                stream: _galleryBlock.outBottomBarVisibility,
                initialData: false,
                builder:
                    (BuildContext context, AsyncSnapshot<bool> showBottomBar) =>
                    VisibilityWidget(
                      isVisible: showBottomBar.data,
                      child: FloatingActionButton(
                        key: Key('gallery_top_floating_button'),
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
                      ),
                    ),
              ),
              bottomNavigationBar: StreamBuilder(
                stream: _galleryBlock.outBottomBarVisibility,
                initialData: false,
                builder:
                    (BuildContext context, AsyncSnapshot<bool> showBottomBar) =>
                    VisibilityWidget(
                      child: BottomAppBar(
                        shape: CircularNotchedRectangle(),
                        notchMargin: 4.0,
                        child: SizedBox(
                          height: 35,
                        ),
                      ),
                      isVisible: showBottomBar.data,
                    ),
              ),
              body: _buildBody(model),
            ),
      );

  /// Build body of the page
  Widget _buildBody(AppState state) =>
      StreamBuilder(
        stream: _galleryBlock.outGalleryStream,
        builder: (BuildContext context, AsyncSnapshot<ItemResponse> snapshot) =>
            OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) =>
                  AnimatedSwitcher(
                    duration: const Duration(seconds: 1),
                    child: _galleryBlock.showLoaderList
                        ? GalleryShimmerList(orientation)
                        : Container(
                      color: Theme
                          .of(context)
                          .primaryColorLight,
                      child: GridView.builder(
                        controller: _scrollController,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                          orientation == Orientation.portrait ? 2 : 3,
                        ),
                        key: Key('gallery_grid_key'),
                        itemCount: snapshot.data.sourceList.length,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemBuilder: ((BuildContext context, int index) {
                          _galleryBlock.itemEventSink
                              .add(ItemEvent(index: index));

                          return GalleryItemPicker(
                              showLoadingItem: snapshot.data
                                  .shouldShowLoadingItems,
                              imageUrl: snapshot
                                  .data.sourceList[index].assets['preview']
                                  .url);
                        }),
                      ),
                    ),
                  ),
            ),
      );
}
