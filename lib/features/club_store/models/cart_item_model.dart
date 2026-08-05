import 'package:adcc/features/store/models/store_item_model.dart';

class CartItemModel {
  final String id;
  final String productId;
  final String productName;
  final String productImage;
  final String? size;
  final String? color;
  final double price;
  final int quantity;
  final int availableStock;

  CartItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
    this.size,
    this.color,
    this.availableStock = 0,
  });

  factory CartItemModel.fromStoreItem(
    StoreItemModel item,
    String selectedSize,
    String selectedColor,
    int quantity,
  ) {
    final normalizedSize = selectedSize.trim();
    final normalizedColor = selectedColor.trim();
    final itemId = '${item.id}_${normalizedSize.isNotEmpty ? normalizedSize : 'default'}_${normalizedColor.isNotEmpty ? normalizedColor : 'default'}';

    final priceString = item.price.trim();
    final priceValue = double.tryParse(
      priceString.replaceAll(RegExp(r'[^0-9.]'), ''),
    ) ?? 0.0;

    return CartItemModel(
      id: itemId,
      productId: item.id,
      productName: item.title,
      productImage: item.image,
      size: normalizedSize.isNotEmpty ? normalizedSize : null,
      color: normalizedColor.isNotEmpty ? normalizedColor : null,
      price: priceValue,
      quantity: quantity,
      availableStock: item.stockFor(size: normalizedSize, color: normalizedColor),
    );
  }

  CartItemModel copyWith({
    int? quantity,
    int? availableStock,
  }) {
    return CartItemModel(
      id: id,
      productId: productId,
      productName: productName,
      productImage: productImage,
      size: size,
      color: color,
      price: price,
      quantity: quantity ?? this.quantity,
      availableStock: availableStock ?? this.availableStock,
    );
  }

  double get totalPrice => price * quantity;

  String get quantityLabel => 'Qty $quantity';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'size': size ?? '',
      'color': color ?? '',
      'price': price,
      'quantity': quantity,
      'availableStock': availableStock,
    };
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final productId = json['productId'] as String? ?? '';
    final size = (json['size'] as String?)?.trim();
    final color = (json['color'] as String?)?.trim();
    final id = (json['id'] as String?)?.trim().isNotEmpty == true
        ? json['id'] as String
        : '${productId}_${size?.isNotEmpty == true ? size : 'default'}_${color?.isNotEmpty == true ? color : 'default'}';

    final quantity = json['quantity'] is int
        ? json['quantity'] as int
        : int.tryParse('${json['quantity']}') ?? 1;
    final availableStock = json['availableStock'] is int
        ? json['availableStock'] as int
        : int.tryParse('${json['availableStock']}') ?? quantity;

    return CartItemModel(
      id: id,
      productId: productId,
      productName: json['productName'] as String? ?? '',
      productImage: json['productImage'] as String? ?? '',
      size: size,
      color: color,
      price: (json['price'] is num ? (json['price'] as num).toDouble() : double.tryParse('${json['price']}') ?? 0),
      quantity: quantity,
      availableStock: availableStock,
    );
  }
}
