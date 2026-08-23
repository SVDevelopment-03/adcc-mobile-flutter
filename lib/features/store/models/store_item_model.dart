import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/core/services/api_response.dart';
import 'package:adcc/core/utils/currency_formatter.dart';
import 'package:adcc/core/utils/response_parser.dart';

class MerchandiseVariant {
  final String id;
  final String? size;
  final String? color;
  final String? colorHex;
  final int stock;
  final String sku;

  MerchandiseVariant({
    required this.id,
    this.size,
    this.color,
    this.colorHex,
    required this.stock,
    required this.sku,
  });

  factory MerchandiseVariant.fromJson(Map<String, dynamic> json) {
    return MerchandiseVariant(
      id: ResponseParser.asString(json['id'] ?? json['variantId'] ?? ''),
      size: ResponseParser.asString(json['size']),
      color: ResponseParser.asString(json['color']),
      colorHex: ResponseParser.asString(json['colorHex']),
      stock: ResponseParser.asInt(json['stock'] ?? 0),
      sku: ResponseParser.asString(json['sku']),
    );
  }
}

class StoreItemModel {
  final String id;
  final String image;
  final String title;
  final String postedBy;
  final String price;
  final String location;
  final String timePosted;
  final String category;
  final String description;
  final List<String> details;
  final List<String> specifications;
  // Preserve raw specification/details payload so UI can prefer localized
  // label/value pairs (e.g. `labelAr`/`valueAr`) when available.
  final List<dynamic>? rawSpecifications;
  final List<String> gallery;
  final List<MerchandiseVariant> variants;
  final bool featured;
  final String? video;
  final String? contactMethod;
  final String? phoneNumber;

  const StoreItemModel({
    required this.id,
    required this.image,
    required this.title,
    required this.postedBy,
    required this.price,
    required this.location,
    required this.timePosted,
    required this.category,
    required this.description,
    required this.details,
    required this.specifications,
    this.rawSpecifications,
    required this.gallery,
    required this.variants,
    required this.featured,
    this.video,
    this.contactMethod,
    this.phoneNumber,
  });

  factory StoreItemModel.fromJson(Map<String, dynamic> json) {
    final dynamic priceValue =
        json['price'] ?? json['amount'] ?? json['currentPrice'] ?? 0;
    final String currency = ResponseParser.asString(json['currency'], fallback: '');
    final priceText = priceValue is num
        ? formatPriceWithCurrency(priceValue, currency)
        : priceValue.toString();

    final detailsRaw = json['details'] ?? json['specifications'];
    final details = detailsRaw is List
        ? detailsRaw
            .map((entry) {
              if (entry is Map<String, dynamic>) {
                final label = ResponseParser.asString(entry['label']);
                final value = ResponseParser.asString(entry['value']);
                if (label.isNotEmpty && value.isNotEmpty) {
                  return '$label: $value';
                }
                return ResponseParser.asString(
                    entry['label'] ?? entry['value'] ?? entry.toString());
              }
              return ResponseParser.asString(entry);
            })
            .where((item) => item.isNotEmpty)
            .toList()
        : <String>[];

    // Prefer Arabic-annotated specifications when present (e.g. from
    // merchandise API: `specificationsAr` contains label/value + labelAr/valueAr).
    final specRaw = json['specificationsAr'] ?? json['specifications'] ?? json['specs'];
    final rawSpecifications = specRaw is List ? specRaw : <dynamic>[];

    final specifications = rawSpecifications
        .map((entry) {
          if (entry is Map<String, dynamic>) {
            final label = ResponseParser.asString(entry['label']);
            final value = ResponseParser.asString(entry['value']);
            if (label.isNotEmpty && value.isNotEmpty) {
              return '$label: $value';
            }
            return ResponseParser.asString(
                entry['label'] ?? entry['value'] ?? entry.toString());
          }
          return ResponseParser.asString(entry);
        })
        .where((item) => item.isNotEmpty)
        .toList();

    final variantsRaw = json['variants'] ?? json['productVariants'];
    final variants = variantsRaw is List
        ? variantsRaw
            .whereType<Map<String, dynamic>>()
            .map(MerchandiseVariant.fromJson)
            .toList()
        : <MerchandiseVariant>[];

    final galleryRaw = json['gallery'] ??
        json['images'] ??
        json['photos'] ??
        json['productImages'];
    final gallery = _extractImageList(galleryRaw);

    final fallbackImage = _extractImageFromRaw(json['coverImage'] ??
        json['image'] ??
        json['mainImage'] ??
        json['imageUrl'] ??
        json['url']);
    final normalizedGallery = gallery
        .map(_normalizeImagePath)
        .where((path) => path.isNotEmpty)
        .toList();
    if (normalizedGallery.isEmpty && fallbackImage.isNotEmpty) {
      normalizedGallery.add(_normalizeImagePath(fallbackImage));
    }

    return StoreItemModel(
      id: ResponseParser.asString(json['_id'] ?? json['id']),
      image: normalizedGallery.isNotEmpty
          ? normalizedGallery.first
          : ResponseParser.asString(_normalizeImagePath(fallbackImage),
              fallback: 'assets/images/no-img.jpg'),
      title: ResponseParser.asString(json['title'] ?? json['name'],
          fallback: 'Item'),
      postedBy: (() {
        final primary = json['vendorName'] ??
            json['sellerName'] ??
            json['postedBy'] ??
            json['authorName'];
        if (primary != null && primary.toString().trim().isNotEmpty) {
          return ResponseParser.asString(primary, fallback: '');
        }

        final createdBy = json['createdBy'];
        if (createdBy is Map<String, dynamic>) {
          final name =
              createdBy['fullName'] ?? createdBy['name'] ?? createdBy['email'];
          if (name != null && name.toString().trim().isNotEmpty) {
            return ResponseParser.asString(name, fallback: '');
          }
        }

        return '';
      })(),
      price: priceText,
      location: ResponseParser.asString(json['location'] ?? json['city'],
          fallback: 'UAE'),
      timePosted: ResponseParser.asString(
        json['createdAt'] ?? json['timePosted'],
        fallback: ApiResponse.localized((l) => l.recently_posted, 'Recently posted'),
      ),
      category: ResponseParser.asString(
        json['categoryName'] ?? json['category'] ?? json['categoryId'],
        fallback: 'All',
      ),
      description: ResponseParser.asString(
        json['description'],
        fallback: 'No description available.',
      ),
      details: details,
      specifications: specifications,
      rawSpecifications: rawSpecifications,
      gallery: normalizedGallery,
      variants: variants,
      featured: ResponseParser.asBool(json['featured'] ?? json['isFeatured']),
      contactMethod: ResponseParser.asString(json['contactMethod']),
      video: ResponseParser.asString(json['video'] ?? json['videoUrl']),
      phoneNumber: ResponseParser.asString(json['phoneNumber']),
    );
  }

  static String _normalizeImagePath(dynamic rawPath) {
    final path = ResponseParser.asString(rawPath);
    if (path.isEmpty) return path;
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    if (path.startsWith('www.')) return 'https://$path';
    if (path.startsWith('/')) {
      final baseUrl = ApiConfig.baseUrl.replaceAll(RegExp(r'/+\u001f?$'), '');
      return '$baseUrl$path';
    }
    return path;
  }

  static List<String> _extractImageList(dynamic rawImage) {
    if (rawImage == null) return <String>[];
    if (rawImage is String) return [rawImage];
    if (rawImage is List && rawImage.isNotEmpty) {
      return rawImage
          .map((entry) => _extractImageFromRaw(entry))
          .where((value) => value.trim().isNotEmpty)
          .toList();
    }
    if (rawImage is Map<String, dynamic>) {
      return _extractImageList(rawImage['images'] ??
          rawImage['gallery'] ??
          rawImage['photos'] ??
          rawImage['image']);
    }
    return [rawImage.toString()];
  }

  static String _extractImageFromRaw(dynamic rawImage) {
    if (rawImage == null) return '';
    if (rawImage is String) return rawImage;
    if (rawImage is List && rawImage.isNotEmpty) {
      return rawImage
          .firstWhere(
            (entry) => entry != null && entry.toString().trim().isNotEmpty,
            orElse: () => '',
          )
          .toString();
    }
    if (rawImage is Map<String, dynamic>) {
      return _extractImageFromRaw(
          rawImage['url'] ?? rawImage['path'] ?? rawImage['image']);
    }
    return rawImage.toString();
  }

  List<String> get availableColors {
    final colors = variants
        .map((variant) => variant.color?.trim())
        .where((color) => color != null && color.isNotEmpty)
        .map((color) => color!)
        .toSet()
        .toList();
    return colors;
  }

  List<String> get availableSizes {
    final sizes = variants
        .map((variant) => variant.size?.trim())
        .where((size) => size != null && size.isNotEmpty)
        .map((size) => size!)
        .toSet()
        .toList();
    return sizes;
  }

  bool get hasVariants => variants.isNotEmpty;

  int get totalStock {
    return variants.fold(0, (sum, variant) => sum + variant.stock);
  }

  int stockFor({String? size, String? color}) {
    if (variants.isEmpty) {
      return 0;
    }

    final selectedSize = size?.trim().toLowerCase() ?? '';
    final selectedColor = color?.trim().toLowerCase() ?? '';

    if (selectedSize.isEmpty && selectedColor.isEmpty) {
      return totalStock;
    }

    final matchingVariants = variants.where((variant) {
      final variantSize = variant.size?.trim().toLowerCase() ?? '';
      final variantColor = variant.color?.trim().toLowerCase() ?? '';

      if (selectedSize.isNotEmpty && selectedColor.isNotEmpty) {
        return variantSize == selectedSize && variantColor == selectedColor;
      }
      if (selectedSize.isNotEmpty) {
        return variantSize == selectedSize;
      }
      if (selectedColor.isNotEmpty) {
        return variantColor == selectedColor;
      }
      return false;
    }).toList();

    if (matchingVariants.isNotEmpty) {
      return matchingVariants.fold(0, (sum, variant) => sum + variant.stock);
    }

    return 0;
  }

  bool get isOutOfStock => totalStock <= 0;

  Map<String, dynamic> toUiMap() {
    return {
      'id': id,
      'image': image,
      'title': title,
      'postedBy': postedBy,
      'price': price,
      'timePosted': timePosted,
      'location': location,
      'category': category,
    };
  }

  /// Return localized specifications or details depending on available raw
  /// payload and the requested [localeCode]. If the original entries were
  /// objects with `label`/`value` and `labelAr`/`valueAr`, prefer the
  /// Arabic fields when [localeCode] startsWith('ar'). Falls back to the
  /// pre-computed `specifications` or `details` lists when raw data isn't
  /// available.
  List<String> localizedSpecOrDetails(String localeCode) {
    final useAr = localeCode.toLowerCase().startsWith('ar');
    final raw = (rawSpecifications?.isNotEmpty == true) ? rawSpecifications! : details;

    final list = raw.map((entry) {
      if (entry is Map<String, dynamic>) {
        final labelAr = ResponseParser.asString(entry['labelAr']);
        final valueAr = ResponseParser.asString(entry['valueAr']);
        final labelEn = ResponseParser.asString(entry['label']);
        final valueEn = ResponseParser.asString(entry['value']);

        if (useAr && labelAr.isNotEmpty && valueAr.isNotEmpty) {
          return '$labelAr: $valueAr';
        }

        if (!useAr && labelEn.isNotEmpty && valueEn.isNotEmpty) {
          return '$labelEn: $valueEn';
        }

        // Try mixed fallbacks
        if (useAr && (labelAr.isNotEmpty || valueAr.isNotEmpty)) {
          final l = labelAr.isNotEmpty ? labelAr : (labelEn);
          final v = valueAr.isNotEmpty ? valueAr : (valueEn);
          if ((l ?? '').isNotEmpty && (v ?? '').isNotEmpty) return '$l: $v';
        }
        if ((labelEn).isNotEmpty || (valueEn).isNotEmpty) {
          final l = labelEn;
          final v = valueEn;
          if (l.isNotEmpty && v.isNotEmpty) return '$l: $v';
        }

        return ResponseParser.asString(entry['label'] ?? entry['value'] ?? entry.toString());
      }
      return ResponseParser.asString(entry);
    }).where((s) => s.isNotEmpty).toList();

    if (list.isNotEmpty) return list;

    // Fallback to precomputed lists
    return specifications.isNotEmpty ? specifications : details;
  }
}
