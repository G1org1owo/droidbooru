import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../db/favorites_context.dart';
import '../../model/base/post.dart';
import '../components/weighted_icon.dart';
import '../details/post_detail.dart';

class PostContainer extends StatelessWidget {
  final List<Post> _posts;
  final int _index;
  final BoxFit _fit;
  final void Function(int)? _onExit;
  final Future<bool> Function(int)? _onIndexUpdate;

  const PostContainer({required List<Post> posts, int index = 0,
    BoxFit fit = BoxFit.fill, void Function(int)? onExit,
    Future<bool> Function(int)? onIndexUpdate, super.key}) :
      _posts = posts,
      _index = index,
      _fit = fit,
      _onExit = onExit,
      _onIndexUpdate = onIndexUpdate;

  Post get _post => _posts[_index];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        int newIndex = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PostDetail(
            posts: _posts,
            index: _index,
            onIndexUpdate: _onIndexUpdate,
          )),
        );

        if(_onExit != null) _onExit(newIndex);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: Stack(
          alignment: Alignment.bottomRight,
          fit: StackFit.passthrough,
          children: [
            FadeInImage.memoryNetwork(
              fadeInDuration: const Duration(milliseconds: 100),
              fadeOutDuration: const Duration(milliseconds: 100),
              placeholder: kTransparentImage,
              image: _post.previewUrl,
              fit: _fit,
            ),
            FutureBuilder(
              future: FavoritesContext().isFavorite(_post),
              builder: (context, snapshot) {
                if(snapshot.hasData && snapshot.data!) {
                  return Container(
                    padding: const EdgeInsets.all(5),
                    alignment: Alignment.bottomRight,
                    child: ClipOval(
                      child: Material(
                        color: Theme.of(context).colorScheme.surface,
                        child: const SizedBox(
                          width: 24,
                          height: 24,
                          child: Align(
                            alignment: Alignment.center,
                            child: WeightedIcon(
                              Icons.favorite_rounded,
                              color: Colors.pinkAccent,
                              iconSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                // Don't show anything if post isn't a favorite
                return const SizedBox.shrink();
              }
            ),
          ],
        ),
      ),
    );
  }
}