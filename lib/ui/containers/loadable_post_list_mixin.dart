import 'package:flutter/material.dart';
import 'package:mutex/mutex.dart';

import '../../model/base/post.dart';

mixin LoadablePostList {
  Mutex get mutex;
  List<Post> get posts;
  Future<void> loadNewPosts();

  Future<bool> loadIfLast(int index,
      {bool snackBar = false, BuildContext? context}) async {
    bool shouldUpdateState = false;

    // Must avoid double firing while new posts are already loading, as it
    // would lead to loading twice as many posts.
    await mutex.protect(() async {
      if (index > posts.length - 2) {
        if (snackBar && context != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Loading new posts..."),
            ),
          );
        }

        await loadNewPosts();
        shouldUpdateState = true;
      }
    });

    return shouldUpdateState;
  }
}