import '../models/game_theme_model.dart';

const List<GameThemeModel> gameThemes = [
  GameThemeModel(
    id: 'classic',
    name: 'Classic',
    backgroundColors: [0xFF321B7B, 0xFF1B0E58, 0xFF090420],
    frameStartColor: 0xFF95633D,
    frameEndColor: 0xFF6C4323,
    boardBaseColor: 0xFFF8F5F1,
  ),
  GameThemeModel(
    id: 'desert',
    name: 'Desert',
    backgroundColors: [0xFF9A6A2E, 0xFF6C421A, 0xFF3F230A],
    frameStartColor: 0xFFC48B4B,
    frameEndColor: 0xFF8E5A2D,
    boardBaseColor: 0xFFFFF3E0,
  ),
  GameThemeModel(
    id: 'frost',
    name: 'Frost',
    backgroundColors: [0xFF6EC6FF, 0xFF2F80ED, 0xFF1B3C73],
    frameStartColor: 0xFFB0D8FF,
    frameEndColor: 0xFF6FA8DC,
    boardBaseColor: 0xFFF2FAFF,
  ),
];
