import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            // 注入 JavaScript 隐藏所有不需要的元素
            _controller.runJavaScript('''
              // 添加全局样式隐藏所有可能的浮动元素
              var style = document.createElement('style');
              style.innerHTML = `
                * {
                  -webkit-user-select: none !important;
                }
                /* 隐藏所有固定定位和绝对定位的元素（除了主内容） */
                body > div[style*="position: fixed"],
                body > div[style*="position:fixed"],
                body > div[style*="position: absolute"],
                body > div[style*="position:absolute"],
                [style*="z-index: 999"],
                [style*="z-index:999"],
                [style*="z-index: 9999"],
                [style*="z-index:9999"],
                /* Google Sites 特定元素 */
                .sites-footer-container,
                .sites-footer,
                .sites-watermark,
                [role="contentinfo"],
                footer,
                /* 隐藏所有可能的浮动按钮和图标 */
                button[style*="position: fixed"],
                a[style*="position: fixed"],
                div[style*="bottom: 0"],
                div[style*="bottom:0"],
                div[style*="left: 0"],
                div[style*="left:0"] {
                  display: none !important;
                  visibility: hidden !important;
                  opacity: 0 !important;
                  pointer-events: none !important;
                }
              `;
              document.head.appendChild(style);
              
              // 延迟执行，确保页面完全加载后再移除元素
              setTimeout(function() {
                // 移除所有固定定位的元素
                var fixedElements = document.querySelectorAll('[style*="position: fixed"], [style*="position:fixed"]');
                fixedElements.forEach(function(el) {
                  if (!el.closest('main') && !el.closest('article')) {
                    el.remove();
                  }
                });
                
                // 移除底部的所有元素
                var bottomElements = document.querySelectorAll('[style*="bottom: 0"], [style*="bottom:0"]');
                bottomElements.forEach(function(el) {
                  el.remove();
                });
                
                // 移除左下角的元素
                var leftBottomElements = document.querySelectorAll('[style*="left: 0"][style*="bottom"]');
                leftBottomElements.forEach(function(el) {
                  el.remove();
                });
              }, 1000);
            ''');
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse('https://sites.google.com/view/moyuyszc/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '隐私政策',
          style: TextStyle(
            color: Colors.grey.shade900,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(
                color: Color(0xFFF9457A),
              ),
            ),
          // 白色遮罩覆盖左下角
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              width: 50,
              height: 70,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
