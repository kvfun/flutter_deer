import 'package:flutter/material.dart';
import 'package:flutter_deer/demo/overlay/bottom_navigation/my_bottom_navigation_bar.dart';
import 'package:flutter_deer/demo/overlay/page/test_page.dart';
import 'package:flutter_deer/demo/overlay/route/application.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  OverlayEntry _overlayEntry;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _overlayEntry = OverlayEntry(
        builder: (context) => _buildBottomNavigation(context),
      );
      /// 添加悬浮
      Overlay.of(context).insert(_overlayEntry);
    });
  }
  
  @override
  void dispose() {
    /// 移除悬浮
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        color: Colors.amber,
        child: Center(
          child: GestureDetector(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26.0),
              child: Text('需求说明：\n1.底部固定悬浮BottomNavigationBar点击切换时有移动动画。\n2.进入二级页面图标全灰，返回一级页面返回之前状态。\n3.二级页面内点击按钮，直接返回一级页面。\n\n点击文字进入下一页->', 
                style: const TextStyle(fontSize: 15.0),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => TestPage(),
                ),
              );
            },
          )          
        ),
      )
    );
  } 
  
  _buildBottomNavigation(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Positioned(
      left: width * 0.2,
      right: width * 0.2,
      bottom: 20.0,
      child: SafeArea(
        child: MyBottomNavigationBar(
          /// 是否显示指示器
          isShowIndicator: Application.navigatorObserver.list.isEmpty,
          selectedCallback: (position) {
            /// 返回主页
            Application.navigatorObserver.list.forEach((route) {
              Navigator.removeRoute(context, route);
            });
            /// 手动清空
            Application.navigatorObserver.list = [];
          },
        ),
      ),
    );
  }
}
