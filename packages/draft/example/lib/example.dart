import 'package:draft_annotation/draft_annotation.dart';

part 'example.draft.dart';

class BoringInner {
  final int field;

  BoringInner({
    required this.field,
  });
}

@draft
class CoolInner {
  final int field;
  final InnerInnerInner inner;

  CoolInner({
    required this.field,
    required this.inner,
  });
}

@draft
class InnerInnerInner {
  final int field;

  InnerInnerInner({
    required this.field,
  });
}

@draft
class DataFields {
  final Map<String, String> map;
  final List<String> list;
  final Set<String> set;
  final Set<String>? nullableSet;
  final Map<String, String>? nullableMap;
  final List<String>? nullableList;
  final String? nullableString;

  const DataFields({
    required this.map,
    required this.list,
    required this.set,
    required this.nullableString,
    required this.nullableSet,
    required this.nullableMap,
    required this.nullableList,
  });
}

@draft
class Foo {
  final String fieldA;
  final String fieldB;
  final BoringInner boringInner;
  final CoolInner coolInner;
  final DataFields dataFields;

  const Foo({
    required this.fieldA,
    required this.fieldB,
    required this.boringInner,
    required this.coolInner,
    required this.dataFields,
  });
}

void main() {
  final foo = Foo(
    fieldA: 'a',
    fieldB: 'b',
    boringInner: BoringInner(field: 1),
    coolInner: CoolInner(field: 2, inner: InnerInnerInner(field: 3)),
    dataFields: DataFields(
      map: {'a': 'b'},
      list: ['a', 'b'],
      set: {'a', 'b'},
      nullableString: null,
      nullableSet: null,
      nullableMap: null,
      nullableList: null,
    ),
  );

  final foo2 = foo.produce((draft) {
    draft.fieldB = 'c';
    draft.coolInner.field += 3;
    draft.coolInner = CoolInner(field: 4, inner: InnerInnerInner(field: 5));
    draft.coolInner.inner.field = 100;
    draft.dataFields.map['a'] = 'c';
    draft.dataFields.list.add('c');
    draft.dataFields.nullableList = ['d', 'e'];
  });

  print(foo2.fieldB); // c
  print(foo2.coolInner.field); // 4
  print(foo2.coolInner.inner.field); // 100

  // data
  print(foo2.dataFields.map); // {a: c}
  print(foo2.dataFields.list); // [a, b, c]
  print(foo2.dataFields.set); // {a, b}
  print(foo2.dataFields.nullableString); // null
  print(foo2.dataFields.nullableSet); // null
  print(foo2.dataFields.nullableMap); // null
  print(foo2.dataFields.nullableList); // [d, e]

  final foo5 = foo.draft()
    ..fieldB = 'd'
    ..fieldA = 'e' * 5;

  print(foo5.save());
}
