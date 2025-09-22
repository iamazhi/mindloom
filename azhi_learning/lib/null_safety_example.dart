void main() {
  // 1. 可空类型示例
  String? nullableName = null;  // 可以为 null
  String nonNullableName = "John";  // 不能为 null
  
  print("nullableName: $nullableName");
  print("nonNullableName: $nonNullableName");
  
  // 2. 安全调用操作符示例
  print("nullableName 的长度: ${nullableName?.length}");  // 返回 null，不会报错
  print("nonNullableName 的长度: ${nonNullableName.length}");  // 返回 4
  
  // 3. 链式安全调用
  Person? person = Person("Alice", null);
  print("地址的城市: ${person?.address?.city}");  // 返回 null
  
  person = Person("Bob", Address("北京"));
  print("地址的城市: ${person?.address?.city}");  // 返回 "北京"
  
  // 4. 空值合并操作符 ??
  String displayName = nullableName ?? "匿名用户";
  print("显示名称: $displayName");
  
  // 5. 空值赋值操作符 ??=
  nullableName ??= "默认名称";
  print("赋值后的 nullableName: $nullableName");
}

class Person {
  String name;
  Address? address;  // 可空的地址
  
  Person(this.name, this.address);
}

class Address {
  String city;
  
  Address(this.city);
}
