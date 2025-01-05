import 'dart:math';

class ListDraft<T> implements List<T> {
  final List<T> _list;

  ListDraft(this._list);

  @override
  T get first => _list.first;

  @override
  set first(T value) {
    _list.first = value;
  }

  @override
  T get last => _list.last;

  @override
  set last(T value) {
    _list.last = value;
  }

  @override
  int get length => _list.length;

  @override
  set length(int newLength) {
    _list.length = newLength;
  }

  @override
  List<T> operator +(List<T> other) => this + other;

  @override
  T operator [](int index) => _list[index];

  @override
  void operator []=(int index, T value) {
    _list[index] = value;
  }

  @override
  void add(T value) {
    _list.add(value);
  }

  @override
  void addAll(Iterable<T> iterable) {
    _list.addAll(iterable);
  }

  @override
  bool any(bool Function(T element) test) => _list.any(test);

  @override
  Map<int, T> asMap() => _list.asMap();

  @override
  List<R> cast<R>() => _list.cast<R>();

  @override
  void clear() {
    _list.clear();
  }

  @override
  bool contains(Object? element) => _list.contains(element);

  @override
  T elementAt(int index) => _list.elementAt(index);

  @override
  bool every(bool Function(T element) test) => _list.every(test);

  @override
  Iterable<E> expand<E>(Iterable<E> Function(T element) toElements) =>
      _list.expand(toElements);

  @override
  void fillRange(int start, int end, [T? fillValue]) {
    _list.fillRange(start, end, fillValue);
  }

  @override
  T firstWhere(bool Function(T element) test, {T Function()? orElse}) =>
      _list.firstWhere(test, orElse: orElse);

  @override
  E fold<E>(E initialValue, E Function(E previousValue, T element) combine) =>
      _list.fold(initialValue, combine);

  @override
  Iterable<T> followedBy(Iterable<T> other) => _list.followedBy(other);

  @override
  void forEach(void Function(T element) action) {
    _list.forEach(action);
  }

  @override
  Iterable<T> getRange(int start, int end) => _list.getRange(start, end);

  @override
  int indexOf(T element, [int start = 0]) => _list.indexOf(element, start);

  @override
  int indexWhere(bool Function(T element) test, [int start = 0]) =>
      _list.indexWhere(test, start);

  @override
  void insert(int index, T element) {
    _list.insert(index, element);
  }

  @override
  void insertAll(int index, Iterable<T> iterable) {
    _list.insertAll(index, iterable);
  }

  @override
  bool get isEmpty => _list.isEmpty;

  @override
  bool get isNotEmpty => _list.isNotEmpty;

  @override
  Iterator<T> get iterator => _list.iterator;

  @override
  String join([String separator = ""]) => _list.join(separator);

  @override
  int lastIndexOf(T element, [int? start]) => _list.lastIndexOf(element, start);

  @override
  int lastIndexWhere(bool Function(T element) test, [int? start]) =>
      _list.lastIndexWhere(test, start);

  @override
  T lastWhere(bool Function(T element) test, {T Function()? orElse}) =>
      _list.lastWhere(test, orElse: orElse);

  @override
  Iterable<E> map<E>(E Function(T e) toElement) => _list.map(toElement);

  @override
  T reduce(T Function(T value, T element) combine) => _list.reduce(combine);

  @override
  bool remove(Object? value) => _list.remove(value);

  @override
  T removeAt(int index) => _list.removeAt(index);

  @override
  T removeLast() => _list.removeLast();

  @override
  void removeRange(int start, int end) {
    _list.removeRange(start, end);
  }

  @override
  void removeWhere(bool Function(T element) test) {
    _list.removeWhere(test);
  }

  @override
  void replaceRange(int start, int end, Iterable<T> replacements) {
    _list.replaceRange(start, end, replacements);
  }

  @override
  void retainWhere(bool Function(T element) test) {
    _list.retainWhere(test);
  }

  @override
  Iterable<T> get reversed => _list.reversed;

  @override
  void setAll(int index, Iterable<T> iterable) {
    _list.setAll(index, iterable);
  }

  @override
  void setRange(int start, int end, Iterable<T> iterable, [int skipCount = 0]) {
    _list.setRange(start, end, iterable, skipCount);
  }

  @override
  void shuffle([Random? random]) {
    _list.shuffle(random);
  }

  @override
  T get single => _list.single;

  @override
  T singleWhere(bool Function(T element) test, {T Function()? orElse}) =>
      _list.singleWhere(test, orElse: orElse);

  @override
  Iterable<T> skip(int count) => _list.skip(count);

  @override
  Iterable<T> skipWhile(bool Function(T value) test) => _list.skipWhile(test);

  @override
  void sort([int Function(T a, T b)? compare]) {
    _list.sort(compare);
  }

  @override
  List<T> sublist(int start, [int? end]) => _list.sublist(start, end);

  @override
  Iterable<T> take(int count) => _list.take(count);

  @override
  Iterable<T> takeWhile(bool Function(T value) test) => _list.takeWhile(test);

  @override
  List<T> toList({bool growable = true}) => _list.toList(growable: growable);

  @override
  Set<T> toSet() => _list.toSet();

  @override
  Iterable<T> where(bool Function(T element) test) => _list.where(test);

  @override
  Iterable<E> whereType<E>() => _list.whereType<E>();
}
