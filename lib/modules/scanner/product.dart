class Product {
  late String name;
  late String nickname;
  late String skuId;
  late String barcode;
  late int amount;
  late double unitPrice;
  late int itemsInCardList;

  Product({
    required this.name, 
    required this.nickname, 
    required this.skuId, 
    required this.barcode, 
    required this.amount, 
    required this.unitPrice,
    required this.itemsInCardList
  });

  bool tryDecreaseAmount() {
    if (amount >= 1) {
      amount--;
      return true;
    }

    return false;
  }
}