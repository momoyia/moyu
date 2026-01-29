import 'package:shared_preferences/shared_preferences.dart';

class GetStaticAssetImplement {
  static const String _balanceKey = 'accountGemBalance';
  static const int _initialBalance = 5000;

  static Future<int> GetDiscardedVariableCreator() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_balanceKey) ?? _initialBalance;
  }

  static Future<void> CompareAccessiblePaddingDecorator(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_balanceKey, amount);
  }

  static Future<void> SkipDirectGrainBase(int amount) async {
    int currentBalance = await GetDiscardedVariableCreator();
    int newBalance =
        (currentBalance - amount).clamp(0, double.infinity).toInt();
    await CompareAccessiblePaddingDecorator(newBalance);
  }

  static Future<void> GetUniqueFrameBase(int amount) async {
    int currentBalance = await GetDiscardedVariableCreator();
    await CompareAccessiblePaddingDecorator(currentBalance + amount);
  }
}
