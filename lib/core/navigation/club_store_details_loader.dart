import 'package:adcc/features/club_store/repositories/club_store_repository.dart';
import 'package:adcc/features/club_store/view/details_screen.dart';
import 'package:adcc/features/store/models/store_item_model.dart';
import 'package:flutter/material.dart';

class ClubStoreDetailsLoaderScreen extends StatefulWidget {
  final String itemId;

  const ClubStoreDetailsLoaderScreen({super.key, required this.itemId});

  @override
  State<ClubStoreDetailsLoaderScreen> createState() =>
      _ClubStoreDetailsLoaderScreenState();
}

class _ClubStoreDetailsLoaderScreenState
    extends State<ClubStoreDetailsLoaderScreen> {
  final ClubStoreRepository _repository = ClubStoreRepository();
  StoreItemModel? _item;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadItem();
  }

  Future<void> _loadItem() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final item = await _repository.fetchMerchandiseItemById(widget.itemId);

    if (!mounted) return;

    if (item != null) {
      setState(() {
        _item = item;
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = false;
      _error = 'Unable to load product details.';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Product Details')),
        body: Center(child: Text(_error!)),
      );
    }

    return ClubStoreDetailsScreen(item: _item!);
  }
}
