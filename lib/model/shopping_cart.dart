class ShoppingCart {
  List<Map<String, dynamic>>? order;

  ShoppingCart() {
    order = [];
  }

  void push(Map<String, dynamic> data) {
    order!.add(data);
  }

  void remove(String key) {
    int index = 0;
    for (final e in order!) {
      if (e['product_id'] == key) {
        break;
      }
      index++;
    }
    order!.removeAt(index);
  }

  void clear() {
    order = [];
  }

  bool isEmpty() {
    return order!.isEmpty;
  }

  List<Map<String, dynamic>> get() {
    return order!;
  }
}
