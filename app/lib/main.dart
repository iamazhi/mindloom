// Copyright 2021 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'src/constants.dart';
import 'src/home.dart';

// 应用程序入口
void main() async {
  runApp(const App());
}

// 应用主组件，使用StatefulWidget以便动态切换主题等
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

// App的状态类
class _AppState extends State<App> {
  // 是否使用Material3设计
  bool _useMaterial3 = true;
  // 当前主题模式（系统/亮色/暗色）
  ThemeMode _themeMode = ThemeMode.system;
  // 当前选中的主题色种子
  ColorSeed _colorSelected = ColorSeed.baseColor;
  // 当前选中的图片
  ColorImageProvider _imageSelected = ColorImageProvider.leaves;
  // 由图片生成的色板
  ColorScheme? _imageColorScheme = const ColorScheme.light();
  // 当前颜色选择方式（色种子或图片）
  ColorSelectionMethod _colorSelectionMethod = ColorSelectionMethod.colorSeed;

  // 判断是否为亮色模式
  bool get _useLightMode => switch (_themeMode) {
    ThemeMode.system =>
      View.of(context).platformDispatcher.platformBrightness ==
          Brightness.light,
    ThemeMode.light => true,
    ThemeMode.dark => false,
  };

  // 处理亮/暗色模式切换
  void _handleBrightnessChange(bool useLightMode) {
    setState(() {
      _themeMode = useLightMode ? ThemeMode.light : ThemeMode.dark;
    });
  }

  // 处理Material版本切换
  void _handleMaterialVersionChange() {
    setState(() {
      _useMaterial3 = !_useMaterial3;
    });
  }

  // 处理色种子选择
  void _handleColorSelect(int value) {
    setState(() {
      _colorSelectionMethod = ColorSelectionMethod.colorSeed;
      _colorSelected = ColorSeed.values[value];
    });
  }

  // 处理图片选择，并异步生成色板
  void _handleImageSelect(int value) {
    final String url = ColorImageProvider.values[value].url;
    ColorScheme.fromImageProvider(provider: NetworkImage(url)).then((
      newScheme,
    ) {
      setState(() {
        _colorSelectionMethod = ColorSelectionMethod.image;
        _imageSelected = ColorImageProvider.values[value];
        _imageColorScheme = newScheme;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 不显示debug横幅
      title: '不知',
      themeMode: _themeMode, // 主题模式
      theme: ThemeData(
        colorSchemeSeed:
            _colorSelectionMethod == ColorSelectionMethod.colorSeed
            ? _colorSelected.color
            : null, // 使用色种子生成色板
        colorScheme: _colorSelectionMethod == ColorSelectionMethod.image
            ? _imageColorScheme
            : null, // 使用图片生成的色板
        useMaterial3: _useMaterial3, // 是否启用Material3
        brightness: Brightness.light, // 亮色主题
      ),
      darkTheme: ThemeData(
        colorSchemeSeed:
            _colorSelectionMethod == ColorSelectionMethod.colorSeed
            ? _colorSelected.color
            : _imageColorScheme!.primary, // 暗色主题下的色种子
        useMaterial3: _useMaterial3,
        brightness: Brightness.dark, // 暗色主题
      ),
      home: Home(
        useLightMode: _useLightMode,
        useMaterial3: _useMaterial3,
        colorSelected: _colorSelected,
        imageSelected: _imageSelected,
        handleBrightnessChange: _handleBrightnessChange,
        handleMaterialVersionChange: _handleMaterialVersionChange,
        handleColorSelect: _handleColorSelect,
        handleImageSelect: _handleImageSelect,
        colorSelectionMethod: _colorSelectionMethod,
      ),
    );
  }
}
