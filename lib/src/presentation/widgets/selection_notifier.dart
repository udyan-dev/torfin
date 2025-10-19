import 'package:flutter/foundation.dart';

class SelectionNotifier extends ChangeNotifier {
  final Set<String> _selected = {};

  bool get isActive => _selected.isNotEmpty;
  int get count => _selected.length;
  Set<String> get keys => Set.unmodifiable(_selected);

  bool isSelected(String key) => _selected.contains(key);

  void toggle(String key) {
    _selected.contains(key) ? _selected.remove(key) : _selected.add(key);
    notifyListeners();
  }

  void addAll(Iterable<String> keys) {
    _selected.addAll(keys);
    notifyListeners();
  }

  void clear() {
    _selected.clear();
    notifyListeners();
  }
}
