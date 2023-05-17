import 'package:scanner/exceptions/service_exception.dart';
import 'package:scanner/modules/scanner/product.dart';
import 'package:scanner/services/scanner_service/scanner_service_interface.dart';
// import 'package:scanner/services/scanner_service/scanner_service.dart';
import 'package:scanner/services/scanner_service/scanner_mock_service.dart';
import 'package:collection/collection.dart';

class ScannerViewModel {
  List<Product> itemsInCardList = [];
  String _inputStr = '';

  // final ScannerServiceInterface _service = ScannerService();
  final ScannerServiceInterface _service = ScannerMockService();

  void initScanner() {
    itemsInCardList.clear();
  }

  void setInputStr({required String value}) {
    _inputStr = value;
  }

  get getInputStr => _inputStr;

  Future<void> onUserScannedBarcode({
    required String barcode,
  }) async {
    late Product? scannedItem;
    scannedItem = itemsInCardList.firstWhereOrNull((element) => element.barcode == barcode);

    if (scannedItem != null) {
      final bool decreaseAble = scannedItem.tryDecreaseAmount();
      if (decreaseAble) {
        scannedItem.itemsInCardList++;
      }else {
        throw ProductRunOutOfStockError(errorStatus: 200, message: 'Product run out of stock');
      }
    }else {
      try {
        scannedItem = await _service.fetchProductByBarcode(barcode: barcode);
        final bool decreaseAble = scannedItem.tryDecreaseAmount();
        if (decreaseAble) {
          itemsInCardList.add(scannedItem);
          scannedItem.itemsInCardList++;
        }else {
          throw ProductRunOutOfStockError(errorStatus: 200, message: 'Product run out of stock');
        }
      }catch(_) {
        rethrow;
      }
    }
  }

  Future<void> onUserIdentifyKeyword({required String keyword}) async {
    Product? identifiedItem;
    identifiedItem = itemsInCardList.firstWhereOrNull((element) => element.barcode == keyword);

    if (identifiedItem != null) {
      final bool decreaseAble = identifiedItem.tryDecreaseAmount();
      if (decreaseAble) {
        identifiedItem.itemsInCardList++;
      }else {
        throw ProductRunOutOfStockError(errorStatus: 200, message: 'Product run out of stock');
      }
    }else {
      try {
        identifiedItem = await _service.fetchProductById(keyword: keyword);
        final bool decreaseAble = identifiedItem.tryDecreaseAmount();
        if (decreaseAble) {
          itemsInCardList.add(identifiedItem);
          identifiedItem.itemsInCardList++;
        }else {
          throw ProductRunOutOfStockError(errorStatus: 200, message: 'Product run out of stock');
        }
      }catch(_) {
        rethrow;
      }
    }
  }

  void onUserPressedDeleteButton({required int index}) {
    itemsInCardList[index].amount += itemsInCardList[index].itemsInCardList;
    itemsInCardList[index].itemsInCardList = 0;
    itemsInCardList.removeAt(index);
  }

}
