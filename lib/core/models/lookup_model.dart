/// A single dashboard-managed lookup entry (bilingual dropdown value).
///
/// Returned by `GET /v1/lookups?type=...` as:
/// ```json
/// { "_id": "...", "type": "event_category", "value": "Race",
///   "label": "Race", "labelAr": "سباق", "parentValue": null,
///   "icon": "...", "order": 0, "active": true }
/// ```
class LookupModel {
  final String id;
  final String type;
  final String value;
  final String label;
  final String labelAr;
  final String? parentValue;
  final String? icon;
  final int order;
  final bool active;

  const LookupModel({
    required this.id,
    required this.type,
    required this.value,
    required this.label,
    required this.labelAr,
    this.parentValue,
    this.icon,
    required this.order,
    required this.active,
  });

  static String _normalizeLookupText(String? value) {
    if (value == null) return '';
    final text = value.trim();
    if (text.isEmpty || text.startsWith('#sym:')) return '';
    return text;
  }

  factory LookupModel.fromJson(Map<String, dynamic> json) {
    final rawValue = _normalizeLookupText(json['value']?.toString() ?? json['label']?.toString());
    final rawLabel = _normalizeLookupText(json['label']?.toString());
    final rawLabelAr = _normalizeLookupText(json['labelAr']?.toString());

    return LookupModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      value: rawValue,
      label: rawLabel,
      labelAr: rawLabelAr,
      parentValue: _normalizeLookupText(json['parentValue']?.toString()),
      icon: json['icon']?.toString(),
      order: (json['order'] as num?)?.toInt() ?? 0,
      active: json['active'] as bool? ?? true,
    );
  }

  static String _cleanDisplayValue(String? value) {
    if (value == null) return '';
    final text = value.trim();
    if (text.isEmpty || text.startsWith('#sym:')) {
      return '';
    }
    return text;
  }

  /// Display label for a given locale ('ar' → Arabic, otherwise English).
  String displayFor(String? localeCode) {
    final localized = _cleanDisplayValue(
      localeCode != null &&
              localeCode.trim().toLowerCase().startsWith('ar')
          ? labelAr
          : label,
    );
    if (localized.isNotEmpty) return localized;

    final fallback = _cleanDisplayValue(label);
    if (fallback.isNotEmpty) return fallback;

    return _cleanDisplayValue(labelAr);
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'type': type,
        'value': value,
        'label': label,
        'labelAr': labelAr,
        'parentValue': parentValue,
        'icon': icon,
        'order': order,
        'active': active,
      };
}
