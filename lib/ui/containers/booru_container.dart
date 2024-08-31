import 'package:flutter/material.dart';
import 'package:mutex/mutex.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../model/base/booru.dart';
import '../../model/base/post.dart';
import 'post_container.dart';
import 'post_grid.dart';
import '../components/weighted_icon.dart';

class BooruContainer extends StatefulWidget {
  final Booru _booru;
  final List<String> _tags;

  const BooruContainer(this._booru, {List<String> tags = const [], super.key}) :
    _tags = tags;

  @override
  State<StatefulWidget> createState() => _BooruState();
}

class _BooruState extends State<BooruContainer> {
  final List<Post> _posts = [];
  int _page = 1;

  final ItemPositionsListener _listener = ItemPositionsListener.create();
  final ItemScrollController _controller = ItemScrollController();
  final Mutex _mutex = Mutex();

  @override
  void initState() {
    super.initState();
    _loadNewPosts();

    _listener.itemPositions.addListener(() async {
      final positions = _listener.itemPositions.value;
      final lastVisibleItem = positions.reduce((last, position) =>
        last.index > position.index? last : position
      );

      _loadIfSecondLast(lastVisibleItem.index);
    });
  }

  Future<bool> _loadIfSecondLast(int index, {bool snackBar = false}) async {
    bool shouldUpdateState = false;

    // Must avoid double firing while new posts are already loading, as it
    // would lead to loading twice as many posts.
    await _mutex.protect(() async {
      if(index > _posts.length - 2) {
        if(snackBar) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Loading new posts..."),
            ),
          );
        }

        await _loadNewPosts();
        shouldUpdateState = true;
      }
    });

    return shouldUpdateState;
  }

  Future<void> _loadNewPosts() async {
    List<Post> newPosts = await widget._booru.listPosts(100, _page, widget._tags);
    _updatePosts(_posts + newPosts);
    _page += 1;
  }

  void _updatePosts(List<Post> posts) => setState(() {
    _posts.clear();
    _posts.addAll(posts);
  });

  void _resetPosts() {
    _page = 1;
    _posts.clear();
  }

  @override
  void didUpdateWidget(covariant BooruContainer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if(oldWidget._tags != widget._tags) {
      _resetPosts();
      _loadNewPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: DecoratedBox(
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerLow/*Color.fromARGB(255, 25, 20, 30)*/),
        child: Column(
          children: [
            // Tag List
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget._tags.join(' '),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w400),
                ),
              )
            ),

            // Post List
            SizedBox(
              height: 150,
              child: ScrollablePositionedList.builder(
                scrollDirection: Axis.horizontal,
                itemScrollController: _controller,
                itemPositionsListener: _listener,
                itemCount: _posts.length,
                itemBuilder: postBuilder,
                shrinkWrap: true,
              ),
            ),

            // Booru info and controls
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              height: 50,
              child: Row(
                children: [
                  Text(
                    widget._booru.url.authority,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      // TODO: implement search grid view
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => PostGrid(
                            _posts,
                            onIndexUpdate: (index) =>
                              _loadIfSecondLast(index, snackBar: true),
                          )
                      ));
                    },
                    icon: WeightedIcon(
                      Icons.search_rounded,
                      color: Theme.of(context).colorScheme.inversePrimary,
                      iconWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // TODO: implement refresh search
                    },
                    icon: WeightedIcon(
                      Icons.cached_rounded,
                      color: Theme.of(context).colorScheme.inversePrimary,
                      iconWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      )
    );
  }

  Widget postBuilder(BuildContext context, int index) {
    return PostContainer(
        posts: _posts,
        index: index,
        onIndexUpdate: (index) => _loadIfSecondLast(index, snackBar: true),
        onExit: (index) => _controller.jumpTo(index: index),
    );
  }
}
