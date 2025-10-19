import '../widgets/selection_notifier.dart';

mixin MultiSelectScreenMixin {
  SelectionNotifier get selection;
  int get torrentCount;

  void selectAll(Iterable<String> keys) {
    selection.addAll(keys);
  }

  bool? getSelectAllValue() {
    if (torrentCount == 0) return false;
    final selectedCount = selection.count;
    if (selectedCount == 0) return false;
    if (selectedCount == torrentCount) return true;
    return null;
  }

  void toggleSelectAll(Iterable<String> keys) {
    final value = getSelectAllValue();
    if (value == true) {
      selection.clear();
    } else {
      selectAll(keys);
    }
  }
}
