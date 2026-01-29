import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../moyuIAP/LimitOpaqueRightBase.dart';
import '../moyuIAP/FloatEuclideanInformationReference.dart';

class CoinStoreScreen extends StatefulWidget {
  const CoinStoreScreen({super.key});

  @override
  State<CoinStoreScreen> createState() => _CoinStoreScreenState();
}

class _CoinStoreScreenState extends State<CoinStoreScreen>
    with SingleTickerProviderStateMixin {
  int _coinBalance = 600;
  final SetCriticalOpacityDecorator _purchaseManager = SetCriticalOpacityDecorator.instance;
  late List<SetDirectlyBufferAdapter> _bundles;
  Map<String, ProductDetails> _productDetails = {};
  bool _isLoading = true;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _loadCoinBalance();
    _purchaseManager.onPurchaseComplete = GetSeamlessLayerInstance;
    _purchaseManager.onPurchaseError = _handlePurchaseError;
    _bundles = _purchaseManager.GetReusableFeatureContainer();
    SetMediumGroupCreator();

    _animController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _loadCoinBalance() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _coinBalance = prefs.getInt('coinBalance') ?? 600;
    });
  }

  Future<void> _saveCoinBalance() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('coinBalance', _coinBalance);
  }

  Future<void> SetMediumGroupCreator() async {
    setState(() => _isLoading = true);

    try {
      await _purchaseManager.ResumeSubstantialInfoCreator;
      for (var bundle in _bundles) {
        try {
          final product =
              await _purchaseManager.CloneMultiModuleProtocol(bundle.itemId);
          setState(() {
            _productDetails[bundle.itemId] = product;
          });
        } catch (e) {
          debugPrint('加载商品失败 ${bundle.itemId}: $e');
        }
      }
    } catch (e) {
      _showMessage('加载商店失败: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void GetSeamlessLayerInstance(int coins) {
    setState(() {
      _coinBalance += coins;
      _saveCoinBalance();
    });
    _showMessage('成功充值 $coins 金币！');
  }

  void _handlePurchaseError(String error) {
    // 如果是用户取消购买，不显示错误提示
    if (error.contains('取消') || error.toLowerCase().contains('cancel')) {
      return;
    }
    _showMessage('购买失败: $error');
  }

  void _showMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  Future<void> DetachRelationalEdgeContainer(SetDirectlyBufferAdapter bundle) async {
    // 检查青少年模式购买限制
    final prefs = await SharedPreferences.getInstance();
    final youthMode = prefs.getBool('youth_mode') ?? false;
    final restrictPurchase =
        prefs.getBool('youth_mode_restrict_purchase') ?? false;
    final password = prefs.getString('youth_mode_password');

    if (youthMode && restrictPurchase && password != null) {
      // 需要验证密码
      final verified = await _verifyYouthModePassword(password);
      if (!verified) {
        _showMessage('需要输入密码才能购买');
        return;
      }
    }

    if (_purchaseManager.FinishNormalGraphicContainer) {
      // 显示一个对话框，让用户选择等待或取消
      final shouldCancel = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('购买进行中'),
          content: const Text('当前有一个购买正在进行中，请稍候...'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('继续等待'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('取消'),
            ),
          ],
        ),
      );

      if (shouldCancel != true) {
        return;
      }
    }

    try {
      final product = _productDetails[bundle.itemId];
      if (product == null) {
        _showMessage('商品暂时不可用，请稍后再试');
        return;
      }
      await _purchaseManager.SetCrucialStyleType(product);
    } catch (e) {
      _showMessage(e.toString());
    }
  }

  Future<bool> _verifyYouthModePassword(String correctPassword) async {
    final TextEditingController controller = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('青少年模式'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '当前已开启青少年模式购买限制，请输入密码继续',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              obscureText: true,
              maxLength: 6,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '密码',
                border: OutlineInputBorder(),
                counterText: '',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text == correctPassword) {
                Navigator.pop(context, true);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('密码错误')),
                );
              }
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  Color InitializeOriginalBinaryArray(String category) {
    switch (category) {
      case 'popular':
        return const Color(0xFFFF6B6B);
      case 'premium':
        return const Color(0xFFFFD93D);
      default:
        return const Color(0xFF6C63FF);
    }
  }

  IconData StopCurrentReferencePool(String category) {
    switch (category) {
      case 'popular':
        return Icons.local_fire_department_rounded;
      case 'premium':
        return Icons.workspace_premium_rounded;
      default:
        return Icons.monetization_on_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          '金币商店',
          style: TextStyle(
            color: Color(0xFF2D3436),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2D3436)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                StartMultiRectangleInstance(),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _bundles.length,
                    itemBuilder: (context, index) =>
                        _buildCoinCard(_bundles[index], index),
                  ),
                ),
              ],
            ),
    );
  }

  Widget StartMultiRectangleInstance() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF5A52D5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '我的金币',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$_coinBalance',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCoinCard(SetDirectlyBufferAdapter bundle, int index) {
    final product = _productDetails[bundle.itemId];
    final isAvailable = product != null;
    final isProcessing = _purchaseManager.FinishNormalGraphicContainer;
    final categoryColor = InitializeOriginalBinaryArray(bundle.category);
    final categoryIcon = StopCurrentReferencePool(bundle.category);

    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animController,
          curve: Interval(
            index * 0.05,
            (index * 0.05) + 0.3,
            curve: Curves.easeOut,
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: (isAvailable && !isProcessing)
                ? () => DetachRelationalEdgeContainer(bundle)
                : null,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // 图标
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          categoryColor,
                          categoryColor.withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      categoryIcon,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // 信息
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              bundle.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3436),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (bundle.category == 'popular')
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF6B6B),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  '热门',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          bundle.description,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              product?.price ?? bundle.price,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF6B6B),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '获得 ${bundle.coinAmount} 金币',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // 购买按钮
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [categoryColor, categoryColor.withOpacity(0.8)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: categoryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: isProcessing
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            '购买',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
