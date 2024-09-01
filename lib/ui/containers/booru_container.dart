import 'package:flutter/material.dart';
import 'package:mutex/mutex.dart';

import '../../model/base/booru.dart';
import '../../model/base/post.dart';
import 'post_grid.dart';
import '../components/weighted_icon.dart';
import 'post_list.dart';

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

  final Mutex _mutex = Mutex();

  @override
  void initState() {
    super.initState();
    _loadNewPosts();
  }

  Future<void> _loadNewPosts() async {
    // Avoid downloading posts twice
    await _mutex.protect(() async {
      List<Post> newPosts =
          await widget._booru.listPosts(100, _page, widget._tags);
      _updatePosts(_posts + newPosts);
      _page += 1;
    });
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
              child: PostList(
                _posts,
                loadNewPosts: _loadNewPosts,
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
                            loadNewPosts: _loadNewPosts,
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
}
