import 'package:droidbooru/db/booru_context.dart';
import 'package:droidbooru/model/base/booru_deserializer.dart';
import 'package:droidbooru/model/moebooru/moe_booru.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  BooruDeserializer("moebooru", Moebooru.fromUrl);

  group("BooruContext", () {
    BooruContext ctx = BooruContext.memory();
    test("singleton", () {
      expect(BooruContext(), BooruContext());
      expect(ctx, isNot(BooruContext()));
    });

    Moebooru booru = Moebooru.fromUrl("https://konachan.com");

    test("add", () async {
      Moebooru newBooru = await ctx.add(booru) as Moebooru;
      expect(newBooru.url, booru.url);
      expect(newBooru.type, booru.type);
      expect(newBooru.id, isNot(booru.id));

      expect((await ctx.find(booru.url.origin))!.id, newBooru.id);

      booru = newBooru;
    });

    test("update", () async {
      Moebooru newBooru = BooruDeserializer.deserialize('moebooru', "https://yande.re", id: booru.id)! as Moebooru;
      await ctx.update(newBooru);

      expect((await ctx.read(booru.id!))!.url.origin, "https://yande.re");
    });

    test("delete", () async {
      await ctx.delete(booru);
      expect(await ctx.find(booru.url.origin), null);
    });
  });
}
