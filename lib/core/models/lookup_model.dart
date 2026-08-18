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

  factory LookupModel.fromJson(Map<String, dynamic> json) {
    return LookupModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      value: json['value']?.toString() ?? json['label']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      labelAr: json['labelAr']?.toString() ?? '',
      parentValue: json['parentValue']?.toString(),
      icon: json['icon']?.toString(),
      order: (json['order'] as num?)?.toInt() ?? 0,
      active: json['active'] as bool? ?? true,
    );
  }

  /// Display label for a given locale ('ar' → Arabic, otherwise English).
  String displayFor(String? localeCode) {
    if (localeCode != null &&
        localeCode.trim().toLowerCase().startsWith('ar') &&
        labelAr.isNotEmpty) {
      return labelAr;
    }
    return label;
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
