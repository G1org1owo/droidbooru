import 'package:flutter/material.dart';
import 'package:preload_page_view/preload_page_view.dart';

import '../model/base/post.dart';

class PostDetail extends StatefulWidget {
  final List<Post> _posts;
  final int _initialIndex;
  final void Function(int)? _onExit;

  const PostDetail({required List<Post> posts, int index = 0,
    void Function(int)? onExit, super.key}) :
        _posts = posts,
        _initialIndex = index,
        _onExit = onExit;

  @override
  State<StatefulWidget> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  late int _currentIndex;
  late PreloadPageController _controller;

  @override
  void initState() {
    super.initState();

    _currentIndex = widget._initialIndex;
    _controller = PreloadPageController(initialPage: _currentIndex);
  }

  void updateIndex(int index) {
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
        widget._onExit!(_currentIndex);
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("${_currentIndex + 1}/${_posts.length}"),
        ),
        body: GestureDetector(
          child: Center(
            child: PreloadPageView.builder(
              itemBuilder: (context, index) {
                return FadeInImage(
                  placeholder: NetworkImage(_posts[index].previewUrl),
                  image: NetworkImage(_posts[index].sampleUrl),
                  fit: BoxFit.contain,
                  fadeOutDuration: const Duration(milliseconds: 5),
                  fadeInDuration: const Duration(milliseconds: 5),
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
        ),
      ),
    );
  }
}