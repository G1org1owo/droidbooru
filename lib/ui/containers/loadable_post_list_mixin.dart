import 'package:flutter/material.dart';
import 'package:mutex/mutex.dart';

import '../../model/base/post.dart';

mixin LoadablePostList {
  final Mutex _mutex = Mutex();
  List<Post> get posts;
  Future<void> loadNewPosts();

  bool _loading = false;

  Future<bool> loadIfLast(int index,
      {bool snackBar = false, BuildContext? context}) async {
    bool shouldUpdateState = false;

    // Must avoid double firing while new posts are already loading, as it
    // would lead to loading twice as many posts.
    if(_loading) return false;

    if (index > posts.length - 2) {
      _loading = true;

      if (snackBar && context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Loading new posts..."),
          ),
        );
      }

      await loadNewPosts().onError((error, _) {
        if(context != null && context.mounted){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Could not load posts!"),
            ),
          );
        }
      });
      shouldUpdateState = true;
      _loading = false;
    }

    return shouldUpdateState;
  }
}