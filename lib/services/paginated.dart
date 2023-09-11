

class Paginated<T> {
  final List<T> _data;
  final int items;
  final int page;
  final int totalPages;

  Paginated(this._data, this.items, this.page, this.totalPages);
  factory Paginated.initial() {
    return Paginated([], 0, 1, 1);
  }

  void push(T item) => _data.add(item);
  T pop() => _data.removeLast();
  void clear() => _data.clear();
  void addAll(Iterable<T> iterable) => _data.addAll(iterable);
  List<T> getData() => _data;
  void removeWhere(bool Function(T) test) {
    _data.removeWhere(test);
  }
  bool get isNotEmpty {
    return _data.isNotEmpty;
  }
}