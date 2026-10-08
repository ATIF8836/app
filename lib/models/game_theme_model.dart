class GameThemeModel {
  final String id;
  final String name;
  final List<int> backgroundColors;
  final int frameStartColor;
  final int frameEndColor;
  final int boardBaseColor;

  const GameThemeModel({
    required this.id,
    required this.name,
    required this.backgroundColors,
    required this.frameStartColor,
    required this.frameEndColor,
    required this.boardBaseColor,
  });
}
