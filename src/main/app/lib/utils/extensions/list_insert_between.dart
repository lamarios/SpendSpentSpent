extension ListExt<T> on List<T> {
  addItemBetween(T item) {
    if (isEmpty) return;
    // The original length of the list
    int originalLength = length;

    // Loop through the list and insert the item at every other position
    for (int i = 1; i < originalLength * 2 - 1; i += 2) {
      insert(i, item);
    }
  }
}
