enum MoebooruTagType {
  general(0),
  artist(1),
  copyright(3),
  character(4),
  style(5),
  circle(6);

  const MoebooruTagType(this.value);
  final int value;

  static MoebooruTagType getByValue(int value) {
    return MoebooruTagType.values.firstWhere((x) => x.value == value);
  }
}