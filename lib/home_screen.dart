import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 顶部标题栏
        AppBar(
          title: Text('会员制管理'),
          centerTitle: false,
          actions: [
            // 提醒铃铛图标
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: null,
            ),
            // 用户头像
            Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.person,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
        // 主页面内容
        Expanded(
          child: Center(
            child: Text('首页'),
          ),
        ),
      ],
    );
  }
}