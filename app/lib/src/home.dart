// Copyright 2021 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'buttons.dart';
import 'color_palettes_screen.dart';
import 'component_screen.dart';
import 'constants.dart';
import 'elevation_screen.dart';
import 'expanded_trailing_actions.dart';
import 'navigation_transition.dart';
import 'one_two_transition.dart';
import 'typography_screen.dart';

/// Home 主页组件，包含主题、颜色、导航等设置
class Home extends StatefulWidget {
  const Home({
    super.key,
    required this.useLightMode, // 是否使用亮色模式
    required this.useMaterial3, // 是否使用Material3
    required this.colorSelected, // 当前选中的颜色
    required this.handleBrightnessChange, // 亮度切换回调
    required this.handleMaterialVersionChange, // Material版本切换回调
    required this.handleColorSelect, // 颜色选择回调
    required this.handleImageSelect, // 图片选择回调
    required this.colorSelectionMethod, // 颜色选择方式
    required this.imageSelected, // 当前选中的图片
  });

  final bool useLightMode; // 是否亮色模式
  final bool useMaterial3; // 是否Material3
  final ColorSeed colorSelected; // 当前选中的颜色种子
  final ColorImageProvider imageSelected; // 当前选中的图片
  final ColorSelectionMethod colorSelectionMethod; // 颜色选择方式

  final void Function(bool useLightMode) handleBrightnessChange; // 亮度切换回调
  final void Function() handleMaterialVersionChange; // Material版本切换回调
  final void Function(int value) handleColorSelect; // 颜色选择回调
  final void Function(int value) handleImageSelect; // 图片选择回调

  @override
  State<Home> createState() => _HomeState();
}

/// Home页面的状态
class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>(); // Scaffold的key
  late final AnimationController controller; // 动画控制器
  late final CurvedAnimation railAnimation; // 导航栏动画
  bool controllerInitialized = false; // 动画控制器是否初始化
  bool showMediumSizeLayout = false; // 是否显示中等布局
  bool showLargeSizeLayout = false; // 是否显示大布局

  int screenIndex = ScreenSelected.component.value; // 当前选中的页面索引

  @override
  initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: transitionLength.toInt() * 2), // 动画时长
      value: 0,
      vsync: this,
    );
    railAnimation = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.5, 1.0), // 动画曲线
    );
  }

  @override
  void dispose() {
    controller.dispose(); // 释放动画控制器
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double width = MediaQuery.of(context).size.width; // 屏幕宽度
    final AnimationStatus status = controller.status; // 动画状态
    if (width > mediumWidthBreakpoint) {
      // 宽度大于中等断点
      if (width > largeWidthBreakpoint) {
        // 宽度大于大断点
        showMediumSizeLayout = false;
        showLargeSizeLayout = true;
      } else {
        showMediumSizeLayout = true;
        showLargeSizeLayout = false;
      }
      // 动画前进
      if (status != AnimationStatus.forward &&
          status != AnimationStatus.completed) {
        controller.forward();
      }
    } else {
      // 小屏幕
      showMediumSizeLayout = false;
      showLargeSizeLayout = false;
      // 动画反向
      if (status != AnimationStatus.reverse &&
          status != AnimationStatus.dismissed) {
        controller.reverse();
      }
    }
    // 初始化动画控制器的值
    if (!controllerInitialized) {
      controllerInitialized = true;
      controller.value = width > mediumWidthBreakpoint ? 1 : 0;
    }
  }

  /// 切换页面
  void handleScreenChanged(int screenSelected) {
    setState(() {
      screenIndex = screenSelected;
    });
  }

  /// 根据选中的页面类型创建对应的页面
  Widget createScreenFor(
    ScreenSelected screenSelected,
    bool showNavBarExample,
  ) => switch (screenSelected) {
    ScreenSelected.component => Expanded(
      child: OneTwoTransition(
        animation: railAnimation,
        one: FirstComponentList(
          showNavBottomBar: showNavBarExample,
          scaffoldKey: scaffoldKey,
          showSecondList: showMediumSizeLayout || showLargeSizeLayout,
        ),
        two: SecondComponentList(scaffoldKey: scaffoldKey),
      ),
    ),
    ScreenSelected.color => const ColorPalettesScreen(),
    ScreenSelected.typography => const TypographyScreen(),
    ScreenSelected.elevation => const ElevationScreen(),
  };

  /// 创建AppBar
  PreferredSizeWidget _createAppBar() {
    return AppBar(
      title: widget.useMaterial3
          ? const Text('见智') // Material3标题
          : const Text('不知'), // Material2标题
      actions: !showMediumSizeLayout && !showLargeSizeLayout
          ? [
              // 右上角操作按钮
              BrightnessButton(
                handleBrightnessChange: widget.handleBrightnessChange,
              ),
              Material3Button(
                handleMaterialVersionChange:
                    widget.handleMaterialVersionChange,
              ),
              ColorSeedButton(
                handleColorSelect: widget.handleColorSelect,
                colorSelected: widget.colorSelected,
                colorSelectionMethod: widget.colorSelectionMethod,
              ),
              ColorImageButton(
                handleImageSelect: widget.handleImageSelect,
                imageSelected: widget.imageSelected,
                colorSelectionMethod: widget.colorSelectionMethod,
              ),
            ]
          : [Container()],
    );
  }

  /// 侧边栏底部的操作按钮
  Widget _trailingActions() => Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Flexible(
        child: BrightnessButton(
          handleBrightnessChange: widget.handleBrightnessChange,
          showTooltipBelow: false,
        ),
      ),
      Flexible(
        child: Material3Button(
          handleMaterialVersionChange: widget.handleMaterialVersionChange,
          showTooltipBelow: false,
        ),
      ),
      Flexible(
        child: ColorSeedButton(
          handleColorSelect: widget.handleColorSelect,
          colorSelected: widget.colorSelected,
          colorSelectionMethod: widget.colorSelectionMethod,
        ),
      ),
      Flexible(
        child: ColorImageButton(
          handleImageSelect: widget.handleImageSelect,
          imageSelected: widget.imageSelected,
          colorSelectionMethod: widget.colorSelectionMethod,
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller, // 监听动画
      builder: (context, child) {
        return NavigationTransition(
          scaffoldKey: scaffoldKey,
          animationController: controller,
          railAnimation: railAnimation,
          appBar: _createAppBar(),
          body: createScreenFor(
            ScreenSelected.values[screenIndex],
            controller.value == 1,
          ),
          navigationRail: NavigationRail(
            extended: showLargeSizeLayout, // 是否展开侧边栏
            destinations: _navRailDestinations, // 侧边栏目的地
            selectedIndex: screenIndex, // 当前选中索引
            onDestinationSelected: (index) {
              setState(() {
                screenIndex = index;
                handleScreenChanged(screenIndex);
              });
            },
            trailing: Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: showLargeSizeLayout
                    ? ExpandedTrailingActions(
                        useLightMode: widget.useLightMode,
                        handleBrightnessChange: widget.handleBrightnessChange,
                        useMaterial3: widget.useMaterial3,
                        handleMaterialVersionChange:
                            widget.handleMaterialVersionChange,
                        handleImageSelect: widget.handleImageSelect,
                        handleColorSelect: widget.handleColorSelect,
                        colorSelectionMethod: widget.colorSelectionMethod,
                        imageSelected: widget.imageSelected,
                        colorSelected: widget.colorSelected,
                      )
                    : _trailingActions(),
              ),
            ),
          ),
          navigationBar: NavigationBars(
            onSelectItem: (index) {
              setState(() {
                screenIndex = index;
                handleScreenChanged(screenIndex);
              });
            },
            selectedIndex: screenIndex,
            isExampleBar: false,
          ),
        );
      },
    );
  }
}

/// 侧边栏导航目的地列表
final List<NavigationRailDestination> _navRailDestinations = appBarDestinations
    .map(
      (destination) => NavigationRailDestination(
        icon: Tooltip(
          message: destination.label, // 图标提示
          child: destination.icon,
        ),
        selectedIcon: Tooltip(
          message: destination.label, // 选中图标提示
          child: destination.selectedIcon,
        ),
        label: Text(destination.label), // 文字标签
      ),
    )
    .toList(growable: false);
