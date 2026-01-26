import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/mock_data_service.dart';
import '../services/storage_service.dart';

class AIScreen extends StatefulWidget {
  const AIScreen({super.key});

  @override
  State<AIScreen> createState() => _AIScreenState();
}

class _AIScreenState extends State<AIScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final StorageService _storageService = StorageService();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  String _nickname = '漫游雨林的树懒';
  List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _loadNickname();
    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  Future<void> _loadNickname() async {
    final nickname = await _storageService.getNickname();
    setState(() {
      _nickname = nickname;
    });
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'text': text,
        'isUser': true,
        'timestamp': DateTime.now(),
      });
      _isTyping = true;
    });

    _controller.clear();
    _scrollToBottom();

    // Simulate AI response
    Future.delayed(Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _messages.add({
            'text': _generateAIResponse(text),
            'isUser': false,
            'timestamp': DateTime.now(),
          });
          _isTyping = false;
        });
        _scrollToBottom();
      }
    });
  }

  void _handlePresetQuestion(String question) {
    _sendMessage(question);
  }

  String _generateAIResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();
    
    if (lowerMessage.contains('推荐') && lowerMessage.contains('景点')) {
      return '根据你的喜好，我推荐以下几个景点：\n\n1. 大理古城 - 适合喜欢古镇文化的你\n2. 西湖 - 江南美景，四季皆宜\n3. 鼓浪屿 - 海岛风情，建筑艺术\n\n需要我为你详细介绍哪个景点吗？';
    } else if (lowerMessage.contains('规划') || lowerMessage.contains('旅行')) {
      return '好的！让我帮你规划一次完美的旅行。请告诉我：\n\n1. 你想去哪里？\n2. 计划几天的行程？\n3. 预算大概是多少？\n4. 有什么特别想体验的吗？\n\n我会根据你的需求定制专属行程～';
    } else if (lowerMessage.contains('美食')) {
      return '说到美食，我有很多推荐！\n\n🍜 成都火锅 - 麻辣鲜香\n🥟 广州早茶 - 一盅两件\n🍲 西安小吃 - 肉夹馍、凉皮\n🦀 海南海鲜 - 新鲜美味\n\n你对哪个地方的美食感兴趣呢？';
    } else if (lowerMessage.contains('活动')) {
      return '最近有很多有趣的活动哦！\n\n🎨 艺术展览 - 各大城市美术馆\n🎵 音乐节 - 春秋季户外音乐节\n🏃 马拉松 - 各地城市马拉松\n🎭 文化节 - 地方特色文化活动\n\n需要我推荐具体的活动吗？';
    } else {
      return '我明白了！作为你的智能旅行助手，我可以帮你：\n\n✨ 推荐热门景点\n📅 规划旅行行程\n🍜 寻找地道美食\n🏨 预订优质住宿\n\n还有什么我可以帮你的吗？';
    }
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final questions = MockDataService.getAIQuestions();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Background blob
            Positioned(
              top: MediaQuery.of(context).size.height * 0.25,
              left: MediaQuery.of(context).size.width * 0.5 - 128,
              child: Container(
                width: 256,
                height: 256,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryPink.withOpacity(0.2),
                      AppTheme.accentPurple.withOpacity(0.2),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  SizedBox(height: 60),
                  // Title
                  Text(
                    'Hi, $_nickname',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '你想要的智能旅行规划师',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  SizedBox(height: 32),

                  // AI Bot Center or Messages
                  Expanded(
                    child: _messages.isEmpty
                        ? SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Animated Bot Icon
                                ScaleTransition(
                                  scale: _pulseAnimation,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        width: 140,
                                        height: 140,
                                        decoration: BoxDecoration(
                                          color: AppTheme.primaryPink.withOpacity(0.2),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      Container(
                                        width: 112,
                                        height: 112,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              AppTheme.primaryPink,
                                              AppTheme.accentPurple,
                                            ],
                                          ),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppTheme.primaryPink.withOpacity(0.3),
                                              blurRadius: 20,
                                              offset: Offset(0, 8),
                                            ),
                                          ],
                                        ),
                                        child: Stack(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.2),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            Center(
                                              child: Icon(
                                                Icons.smart_toy,
                                                size: 42,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 32),

                                // Preset Questions
                                ...questions.map((question) {
                                  return Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.only(bottom: 10),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () => _handlePresetQuestion(question),
                                        borderRadius: BorderRadius.circular(16),
                                        child: Container(
                                          padding: EdgeInsets.all(14),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.8),
                                            borderRadius: BorderRadius.circular(16),
                                            border: Border.all(color: Colors.grey.shade100),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.shade100,
                                                blurRadius: 4,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  question,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey.shade700,
                                                  ),
                                                ),
                                              ),
                                              Icon(
                                                Icons.chevron_right,
                                                size: 16,
                                                color: Colors.grey.shade300,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                                SizedBox(height: 20),
                              ],
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.only(bottom: 16),
                            itemCount: _messages.length + (_isTyping ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == _messages.length && _isTyping) {
                                return _buildTypingIndicator();
                              }
                              final message = _messages[index];
                              return _buildMessageBubble(
                                message['text'],
                                message['isUser'],
                              );
                            },
                          ),
                  ),

                  // Input Area
                  Padding(
                    padding: EdgeInsets.only(bottom: 16, top: 8),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.grey.shade100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                hintText: '问点什么...',
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade400,
                                ),
                                border: InputBorder.none,
                              ),
                              onSubmitted: (text) => _sendMessage(text),
                            ),
                          ),
                          Container(
                            width: 32,
                            height: 32,
                            margin: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryPink,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(Icons.send, size: 14, color: Colors.white),
                              onPressed: () => _sendMessage(_controller.text),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(String text, bool isUser) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryPink, AppTheme.accentPurple],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.smart_toy, size: 18, color: Colors.white),
            ),
            SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser
                    ? AppTheme.primaryPink
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isUser ? 16 : 4),
                  topRight: Radius.circular(isUser ? 4 : 16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  color: isUser ? Colors.white : Colors.grey.shade800,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.primaryPink.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  _nickname[0],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryPink,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryPink, AppTheme.accentPurple],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.smart_toy, size: 18, color: Colors.white),
          ),
          SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                SizedBox(width: 4),
                _buildDot(1),
                SizedBox(width: 4),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600),
      builder: (context, value, child) {
        final delay = index * 0.2;
        final animValue = (value - delay).clamp(0.0, 1.0);
        final opacity = (animValue * 2).clamp(0.3, 1.0);
        
        return Opacity(
          opacity: opacity,
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
      onEnd: () {
        if (mounted && _isTyping) {
          setState(() {});
        }
      },
    );
  }
}
