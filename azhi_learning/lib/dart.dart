// 调用Dart核心库中的sqrt函数，计算16的平方根
import 'dart:math';

void main() async{
  //  变量 
  var name = 'Voyager I';
  var year = 1977;
  var antennaDiameter = 3.7;
  var flybyObjects = ['Jupiter', 'Saturn', 'Uranus', 'Neptune'];
  var image = {
    'tags': ['saturn'],
    'url': '//path/to/saturn.jpg',
  };


  // 流程控制语句
  p("流程控制语句");
  print('DEBUG: year = $year');
  if (year >= 2001) {
    print('21st century');
  } else if (year >= 1901) {
    print('20th century');
  }

  for (final object in flybyObjects) {
    print('DEBUG: flybyObject = $object');
    print(object);
  }

  for (int month = 1; month <= 12; month++) {
    print('DEBUG: month = $month');
    print(month);
  }

  while (year < 2016) {
    print('DEBUG: year before increment = $year');
    year += 1;
    print('DEBUG: year after increment = $year');
  }

  p("函数");
  var result = fibonacci(20);
  print('DEBUG: result = $result');

  p("导入 import");
  double value = 16;
  double result1 = sqrt(value);
  print('DEBUG: sqrt($value) = $result1');

  p("类 (Class)");
  var voyager = Spacecraft('Voyager I', DateTime(1977, 9, 5));
  voyager.describe();
  var voyager3 = Spacecraft.unlaunched('Voyager III');
  voyager3.describe();

  p("枚举类型 (Enum)");
  // 创建一个行星实例 - 选择水星
  final yourPlanet = Planet.mercury;
  
  // 使用枚举的 getter 方法判断是否为巨行星
  if (!yourPlanet.isGiant) {
    print('Your planet is not a "giant planet".');
  }
  
  // 展示枚举的详细信息
  print('选择的行星: ${yourPlanet.name}');  // name 是枚举自带的属性
  print('行星类型: ${yourPlanet.planetType}');
  print('卫星数量: ${yourPlanet.moons}');
  print('是否有光环: ${yourPlanet.hasRings}');
  
  // 比较不同的行星
  print('\n比较水星和天王星:');
  print('水星是巨行星吗? ${Planet.mercury.isGiant}');
  print('天王星是巨行星吗? ${Planet.uranus.isGiant}');


  p("异步编程 (Async)");
  fetchData().then((value) {
    print(value);
  });
  print("请求已发送，等待中...");

  String result2 = await fetchData2(); // 注意 main 方法改成了async
  print(result2);
  print("任务完成");
}


void p(String title) {
  print("${'*' * 100}$title${'*' * 100}");
}

// 函数
int fibonacci(int n) {
  if (n == 0 || n == 1) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
}


class Spacecraft {
  String name;
  DateTime? launchDate; // DateTime? 表示可以是 DateTime 对象或 null

  // Read-only non-final property
  int? get launchYear => launchDate?.year; // int? 表示可以是 int 值或 null

  // Constructor, with syntactic sugar for assignment to members.
  Spacecraft(this.name, this.launchDate) {
    // Initialization code goes here.
  }

  // Named constructor that forwards to the default one.
  Spacecraft.unlaunched(String name) : this(name, null);

  // Method.
  void describe() {
    print('Spacecraft: $name');
    // Type promotion doesn't work on getters.
    var launchDate = this.launchDate;
    if (launchDate != null) {
      int years = DateTime.now().difference(launchDate).inDays ~/ 365;
      print('Launched: $launchYear ($years years ago)');
    } else {
      print('Unlaunched');
    }
  }
}


// 定义行星类型的简单枚举
// terrestrial = 类地行星, gas = 气态行星, ice = 冰态行星
enum PlanetType { terrestrial, gas, ice }

/// 增强型枚举：定义太阳系中不同行星及其属性
/// 这是 Dart 2.17+ 的新功能，枚举可以有构造函数、属性和方法
enum Planet {
  // 每个行星都是枚举的一个实例，通过构造函数创建
  // 水星：类地行星，0个卫星，无光环
  mercury(planetType: PlanetType.terrestrial, moons: 0, hasRings: false),
  // 金星：类地行星，0个卫星，无光环  
  venus(planetType: PlanetType.terrestrial, moons: 0, hasRings: false),
  // ··· 这里省略了其他行星的定义
  // 天王星：冰态行星，27个卫星，有光环
  uranus(planetType: PlanetType.ice, moons: 27, hasRings: true),
  // 海王星：冰态行星，14个卫星，有光环
  neptune(planetType: PlanetType.ice, moons: 14, hasRings: true);

  /// 常量构造函数 - 用于创建枚举实例
  /// required 关键字表示这些参数是必需的
  const Planet({
    required this.planetType,  // 必须指定行星类型
    required this.moons,       // 必须指定卫星数量
    required this.hasRings,    // 必须指定是否有光环
  });

  /// 所有实例变量都是 final 的（不可变）
  final PlanetType planetType;  // 行星类型
  final int moons;              // 卫星数量
  final bool hasRings;          // 是否有光环

  /// 增强型枚举支持 getter 和其他方法
  /// 判断是否为巨行星（气态行星或冰态行星）
  bool get isGiant =>
      planetType == PlanetType.gas || planetType == PlanetType.ice;
}

Future<String> fetchData() {
  return Future.delayed(Duration(seconds: 2), () {
    return "数据加载完成";
  });
}


Future<String> fetchData2() async {
  await Future.delayed(Duration(seconds: 2));
  return "数据加载完成";
}