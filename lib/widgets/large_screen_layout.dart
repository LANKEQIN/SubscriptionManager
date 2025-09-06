import 'package:flutter/material.dart';
import '../utils/responsive_layout.dart';
import 'large_screen_navigation.dart';
import '../widgets/sync_indicator.dart';

/// 大屏设备专用的主布局组件
class LargeScreenLayout extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget child;
  final String title;
  final List<Widget>? actions;
  
  const LargeScreenLayout({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.child,
    required this.title,
    this.actions,
  });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // 侧边导航栏
          LargeScreenNavigation(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
          ),
          
          // 主内容区域
          Expanded(
            child: Column(
              children: [
                // 顶部应用栏
                LargeScreenAppBar(
                  title: title,
                  actions: actions,
                ),
                
                // 主要内容
                Expanded(
                  child: Stack(
                    children: [
                      // 内容区域
                      SizedBox(
                        width: double.infinity,
                        child: child,
                      ),
                      
                      // 同步状态指示器
                      const SyncIndicator(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 大屏设备专用的内容容器
class LargeScreenContent extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final bool centerContent;
  
  const LargeScreenContent({
    super.key,
    required this.child,
    this.padding,
    this.centerContent = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final maxWidth = ResponsiveLayout.getMaxContentWidth(context);
    final defaultPadding = ResponsiveLayout.getPagePadding(context);
    
    Widget content = Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      padding: padding ?? defaultPadding,
      child: child,
    );
    
    if (centerContent) {
      content = Center(
        child: content,
      );
    }
    
    return SingleChildScrollView(
      child: content,
    );
  }
}

/// 大屏设备专用的网格布局
class LargeScreenGrid extends StatelessWidget {
  final List<Widget> children;
  final int? crossAxisCount;
  final double? childAspectRatio;
  final double? mainAxisSpacing;
  final double? crossAxisSpacing;
  
  const LargeScreenGrid({
    super.key,
    required this.children,
    this.crossAxisCount,
    this.childAspectRatio,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
  });
  
  @override
  Widget build(BuildContext context) {
    final columnCount = crossAxisCount ?? ResponsiveLayout.getColumnCount(context);
    final spacing = ResponsiveLayout.getCardSpacing(context);
    
    return GridView.count(
      crossAxisCount: columnCount,
      childAspectRatio: childAspectRatio ?? 1.0,
      mainAxisSpacing: mainAxisSpacing ?? spacing,
      crossAxisSpacing: crossAxisSpacing ?? spacing,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: children,
    );
  }
}

/// 大屏设备专用的卡片容器
class LargeScreenCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? elevation;
  final Color? color;
  
  const LargeScreenCard({
    super.key,
    required this.child,
    this.padding,
    this.elevation,
    this.color,
  });
  
  @override
  Widget build(BuildContext context) {
    final spacing = ResponsiveLayout.getCardSpacing(context);
    
    return Card(
      elevation: elevation ?? 2,
      color: color,
      child: Padding(
        padding: padding ?? EdgeInsets.all(spacing),
        child: child,
      ),
    );
  }
}

/// 大屏设备专用的分栏布局
class LargeScreenColumns extends StatelessWidget {
  final List<Widget> children;
  final List<int>? flex;
  final double? spacing;
  
  const LargeScreenColumns({
    super.key,
    required this.children,
    this.flex,
    this.spacing,
  });
  
  @override
  Widget build(BuildContext context) {
    final defaultSpacing = ResponsiveLayout.getCardSpacing(context);
    final actualSpacing = spacing ?? defaultSpacing;
    
    List<Widget> rowChildren = [];
    
    for (int i = 0; i < children.length; i++) {
      if (i > 0) {
        rowChildren.add(SizedBox(width: actualSpacing));
      }
      
      final flexValue = flex != null && i < flex!.length ? flex![i] : 1;
      rowChildren.add(
        Expanded(
          flex: flexValue,
          child: children[i],
        ),
      );
    }
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rowChildren,
    );
  }
}