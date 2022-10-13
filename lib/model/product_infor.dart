class ProductInfo {
  String? name;
  String? image;
  int? buyQuantity;
  int? price;

  ProductInfo(this.name, this.image, this.buyQuantity, this.price);

  int getTotal() {
    return price! * buyQuantity!;
  }
}
