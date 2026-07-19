import 'dart:convert';

import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/features/club_store/models/cart_item_model.dart';
import 'package:adcc/features/store/models/store_item_model.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClubStoreCartRepository {
  ClubStoreCartRepository._internal({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient.instance;

  static ClubStoreCartRepository? _instance;
  static ClubStoreCartRepository get instance => _instance ??= ClubStoreCartRepository._internal();

  static const String _storageKey = 'club_store_cart_items';

  final ApiClient _apiClient;
  final ValueNotifier<List<CartItemModel>> items = ValueNotifier([]);

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) {
      items.value = [];
      return;
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        items.value = decoded
            .whereType<Map<String, dynamic>>()
            .map(CartItemModel.fromJson)
            .toList();
      } else {
        items.value = [];
      }
    } catch (_) {
      items.value = [];
    }
  }

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(items.value.map((item) => item.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }

  Future<void> addItemFromStoreItem(
    StoreItemModel item,
    String selectedSize,
    String selectedColor,
    int quantity,
  ) async {
    final cartItem = CartItemModel.fromStoreItem(item, selectedSize, selectedColor, quantity);
    await addItem(cartItem);
  }

  Future<void> addItem(CartItemModel item) async {
    final existingIndex = items.value.indexWhere((element) => element.id == item.id);
    final updatedItems = List<CartItemModel>.from(items.value);

    if (existingIndex >= 0) {
      final existing = updatedItems[existingIndex];
      final maxAllowed = existing.availableStock;
      final newQuantity = (existing.quantity + item.quantity).clamp(1, maxAllowed);
      updatedItems[existingIndex] = existing.copyWith(quantity: newQuantity);
    } else {
      final maxAllowed = item.availableStock;
      final newQuantity = item.quantity.clamp(1, maxAllowed);
      updatedItems.add(item.copyWith(quantity: newQuantity));
    }

    items.value = updatedItems;
    await _saveCart();
  }

  Future<void> updateItemQuantity(String cartItemId, int quantity) async {
    if (quantity < 1) return;
    final updatedItems = items.value.map((item) {
      if (item.id == cartItemId) {
        final maxAllowed = item.availableStock;
        final newQuantity = quantity.clamp(1, maxAllowed);
        return item.copyWith(quantity: newQuantity);
      }
      return item;
    }).toList();
    items.value = updatedItems;
    await _saveCart();
  }

  Future<void> removeItem(String cartItemId) async {
    final updatedItems = items.value.where((item) => item.id != cartItemId).toList();
    items.value = updatedItems;
    await _saveCart();
  }

  Future<void> clearCart() async {
    items.value = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }

  double get subtotal {
    return items.value.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  double total({double shipping = 0}) {
    return subtotal + shipping;
  }

  bool get isEmpty => items.value.isEmpty;
  int get itemCount => items.value.length;

  Future<Map<String, dynamic>> createOrder({
    required String name,
    required String line1,
    required String city,
    required String emirate,
    required String phone,
    required String paymentMethod,
    String? paymentLast4,
    double shipping = 0,
    String? notes,
  }) async {
    final response = await _apiClient.post<dynamic>(
      ApiEndpoints.merchandiseOrders,
      data: {
        'items': items.value.map((item) => item.toJson()).toList(),
        'shippingAddress': {
          'name': name,
          'line1': line1,
          'city': city,
          'emirate': emirate,
          'phone': phone,
        },
        'paymentMethod': paymentMethod,
        if (paymentLast4 != null && paymentLast4.isNotEmpty) 'paymentLast4': paymentLast4,
        'shipping': shipping,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      },
    );

    if (response.data is Map<String, dynamic>) {
      final rawData = response.data as Map<String, dynamic>;
      if (rawData.containsKey('data') && rawData['data'] is Map<String, dynamic>) {
        return rawData['data'] as Map<String, dynamic>;
      }
      return rawData;
    }

    return <String, dynamic>{};
  }
}
