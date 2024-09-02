import 'package:flutter/material.dart' hide PageScrollPhysics, NavigationDrawer;
import 'package:preload_page_view/preload_page_view.dart';

import '../../db/favorites_context.dart';
import '../../model/base/post.dart';
import '../drawers/navigation_drawer.dart';
import '../drawers/post_drawer.dart';
import '../components/post_interactive_image.dart';

class PostDetail extends StatefulWidget {
  final List<Post> _posts;
  final int _initialIndex;
  final Future<bool> Function(int)? _onIndexUpdate;

  const PostDetail({required List<Post> posts, int index = 0,
    Future<bool> Function(int)? onIndexUpdate,
    super.key}) :
      _posts = posts,
      _initialIndex = index,
      _onIndexUpdate = onIndexUpdate;

  @override
  State<StatefulWidget> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  static const double maxScale = 3.0;
  static const double minScale = 1.0;

  late int _currentIndex;
  bool _scrollLocked = false;
  bool _isFavorite = false;

  late PreloadPageController _controller;
  final FavoritesContext _favoritesContext = FavoritesContext();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _currentIndex = widget._initialIndex;
    _favoritesContext.isFavorite(_currentPost)
        .then((fav) => _isFavorite = fav);
    _controller = PreloadPageController(initialPage: _currentIndex);
  }

  void updateIndex(int index) async {
    if(widget._onIndexUpdate != null) {
      widget._onIndexUpdate!(index).then(
        (shouldUpdateState) => shouldUpdateState? setState(() {}) : null
      );
    }

    _currentIndex = index;
    _isFavorite = await _favoritesContext.isFavorite(_currentPost);

    setState(() { });
  }

  List<Post> get _posts => widget._posts;
  Post get _currentPost => _posts[_currentIndex];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if(didPop) return;

        // Return new scroll index to update outer context
        Navigator.pop(context, _currentIndex);
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
              onPressed: _toggleFavorite,
              icon: _isFavorite ?
                  const Icon(Icons.favorite_rounded, color: Colors.pinkAccent) :
                  const Icon(Icons.favorite_border_rounded),
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
        endDrawer: PostDrawer(_currentPost),
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

  void _toggleFavorite() async {
              _isFavorite?
                _favoritesContext.remove(_currentPost) :
                _favoritesContext.add(_currentPost);

              setState(() {
                _isFavorite = !_isFavorite;
              });
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