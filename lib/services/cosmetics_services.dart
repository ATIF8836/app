import '../data/dice_skins.dart';
import '../data/game_themes.dart';
import '../data/token_skins.dart';
import '../models/dice_skin_model.dart';
import '../models/game_theme_model.dart';
import '../models/token_skin_model.dart';

class CosmeticsService {
  static final CosmeticsService _instance = CosmeticsService._internal();
  factory CosmeticsService() => _instance;
  CosmeticsService._internal();

  String equippedThemeId = 'classic';
  String equippedDiceId = 'classic';
  String equippedTokenId = 'classic';

  List<GameThemeModel> get allThemes => gameThemes;
  List<DiceSkinModel> get allDiceSkins => diceSkins;
  List<TokenSkinModel> get allTokenSkins => tokenSkins;

  GameThemeModel get equippedTheme =>
      gameThemes.firstWhere((e) => e.id == equippedThemeId);

  DiceSkinModel get equippedDice =>
      diceSkins.firstWhere((e) => e.id == equippedDiceId);

  TokenSkinModel get equippedToken =>
      tokenSkins.firstWhere((e) => e.id == equippedTokenId);

  void equipTheme(String id) {
    equippedThemeId = id;
  }

  void equipDice(String id) {
    equippedDiceId = id;
  }

  void equipToken(String id) {
    equippedTokenId = id;
  }
}
