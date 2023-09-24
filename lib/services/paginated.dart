

class Paginated<T> {
  final List<T> _data;
  int page;
  int totalPages;

  Paginated(this._data, this.page, this.totalPages);
  factory Paginated.initial() {
    return Paginated([], 1, 1);
  }

  void push(T item) => _data.add(item);
  void insertFirst(T item) => _data.insert(0, item);
  T getItem(int index) => _data[index];
  T findItem(bool Function(T) test) => _data.firstWhere(test);
  T pop() => _data.removeLast();
  void clear() => _data.clear();
  void addAll(Iterable<T> iterable) => _data.addAll(iterable);
  void addPage(Paginated<T> newPage) {
    _data.addAll(newPage.getData());
    page = newPage.page;
    totalPages = newPage.totalPages;
  }
  List<T> getData() => _data;
  void removeWhere(bool Function(T) test) {
    _data.removeWhere(test);
  }
  bool get isNotEmpty {
    return _data.isNotEmpty;
  }
  int get items {
    return _data.length;
  }
}