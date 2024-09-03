import 'package:droidbooru/db/favorites_context.dart';
import 'package:droidbooru/model/base/post.dart';
import 'package:droidbooru/model/moebooru/moe_booru.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("FavoritesContext", () {
    FavoritesContext ctx = FavoritesContext.memory();
    test("singleton", () {
      expect(FavoritesContext(), FavoritesContext());
      expect(ctx, isNot(FavoritesContext()));
    });

    Future<Post> post = Moebooru.fromUrl("https://konachan.com")
        .listPosts(1, 1, []).then((posts) => posts[0]);

    test("add", () async {
      await ctx.add(await post);
      expect(await ctx.isFavorite(await post), true);
    });

    test("remove", () async {
      await ctx.remove(await post);
      expect(await ctx.isFavorite(await post), false);
    });
  });
}
