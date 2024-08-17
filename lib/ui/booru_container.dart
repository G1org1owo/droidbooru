import 'package:flutter/material.dart';
import 'package:mutex/mutex.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../model/base/booru.dart';
import '../model/base/post.dart';
import 'post_container.dart';

class BooruContainer extends StatefulWidget {
  final Booru _booru;
  const BooruContainer(this._booru, {super.key});

  @override
  State<StatefulWidget> createState() => _BooruState();
}

class _BooruState extends State<BooruContainer> {
  List<Post> _posts = [];
  int _page = 1;

  final ItemPositionsListener _listener = ItemPositionsListener.create();
  final ItemScrollController _controller = ItemScrollController();
  final Mutex _mutex = Mutex();

  @override
  void initState() {
    super.initState();
    loadNewPosts();

    _listener.itemPositions.addListener(() async {
      final positions = _listener.itemPositions.value;
      final lastVisibleItem = positions.reduce((last, position) =>
        last.index > position.index? last : position
      );

      // Must avoid double firing while new posts are already loading, as it
      // would lead to loading twice as many posts.
      _mutex.protect(() async {
        if(lastVisibleItem.index > _posts.length - 2) {
          await loadNewPosts();
        }
      });
    });
  }

  Future<void> loadNewPosts() async {
    List<Post> newPosts = await widget._booru.listPosts(100, _page, []);
    updatePosts(_posts + newPosts);
    _page += 1;
  }

  void updatePosts(List<Post> posts) => setState(() => _posts = posts);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: ScrollablePositionedList.builder(
        scrollDirection: Axis.horizontal,
        itemScrollController: _controller,
        itemPositionsListener: _listener,
        itemCount: _posts.length,
        itemBuilder: postBuilder,
      ),
    );
  }

  Widget postBuilder(BuildContext context, int index) {
    return PostContainer(
        posts: _posts,
        index: index,
        onExit: (index) => _controller.jumpTo(index: index),
    );
  }
}
