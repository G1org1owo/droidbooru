enum TagType implements Comparable<TagType> {
  artist,
  copyright,
  character,
  meta,
  general;

  @override
  int compareTo(TagType other) {
    return index - other.index;
  }
}