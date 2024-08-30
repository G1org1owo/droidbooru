import 'package:flutter/material.dart' hide PageScrollPhysics, NavigationDrawer;
import 'package:preload_page_view/preload_page_view.dart';

import '../model/base/post.dart';
import 'navigation_drawer.dart';
import 'post_drawer.dart';
import 'post_interactive_image.dart';

class PostDetail extends StatefulWidget {
  final List<Post> _posts;
  final int _initialIndex;
  final void Function(int)? _onExit;
  final Future<bool> Function(int)? _onIndexUpdate;

  const PostDetail({required List<Post> posts, int index = 0,
    void Function(int)? onExit, Future<bool> Function(int)? onIndexUpdate,
    super.key}) :
      _posts = posts,
      _initialIndex = index,
      _onExit = onExit,
      _onIndexUpdate = onIndexUpdate;

  @override
  State<StatefulWidget> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  static const double maxScale = 3.0;
  static const double minScale = 1.0;

  late int _currentIndex;
  bool _scrollLocked = false;

  late PreloadPageController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _currentIndex = widget._initialIndex;
    _controller = PreloadPageController(initialPage: _currentIndex);
  }

  void updateIndex(int index) {
    if(widget._onIndexUpdate != null) {
      widget._onIndexUpdate!(index).then(
        (shouldUpdateState) => shouldUpdateState? setState(() {}) : null
      );
    }
    setState(() {
      _currentIndex = index;
    });
  }

  List<Post> get _posts => widget._posts;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if(didPop) return;

        // Update outer context based on new scroll index
        if(widget._onExit != null) widget._onExit!(_currentIndex);
        Navigator.pop(context);
      },
      child: Scaffold(
        key: _scaffoldKey,
        extendBodyBehindAppBar: true,
        endDrawerEnableOpenDragGesture: false,
        drawerEnableOpenDragGesture: false,
        appBar: AppBar(
          title: Text("${_currentIndex + 1}/${_posts.length}"),
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              onPressed: (){ },
              icon: const Icon(Icons.favorite_border),
            ),
            IconButton(
              onPressed: (){ },
              icon: const Icon(Icons.save_outlined),
            ),
            IconButton(
              onPressed: () {
                _scaffoldKey.currentState?.openEndDrawer();
              },
              icon: const Icon(Icons.info_outline_rounded),
            ),
            IconButton(
              onPressed: (){ },
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
        drawer: const NavigationDrawer(),
        endDrawer: PostDrawer(_posts[_currentIndex]),
        body: PreloadPageView.builder(
          physics: _scrollLocked ?
          const NeverScrollableScrollPhysics() :
          const PageScrollPhysics(),
          itemBuilder: (context, index) {
            return PostInteractiveImage(
              post: _posts[index],
              maxScale: maxScale,
              minScale: minScale,
              fit: BoxFit.contain,
              onScaleUpdate: (details) {
                _setScrollLock(details.scale);
              },
            );
          },
          itemCount: _posts.length,
          controller: _controller,
          onPageChanged: (int page) {
            updateIndex(page);
          },
          preloadPagesCount: 2,
        ),
      ),
    );
  }

  void _setScrollLock(double scale) {
    bool scrollLocked = scale > 1.0;

    if(scrollLocked != _scrollLocked) {
      setState(() {
        _scrollLocked = scrollLocked;
      });
    }
  }
}