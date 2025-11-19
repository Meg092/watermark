import 'dart:convert';


class MediaRecord {
  int? id;

  
  String type;

  
  String filePath;

  
  String? thumbnailPath;

  
  DateTime timestamp;

  
  int watermarkId;

  
  String watermarkName;

  
  String? locationAddress;

  
  double? locationLatitude;

  
  double? locationLongitude;

  
  Map<String, dynamic>? customFields;

  
  DateTime createdAt;

  MediaRecord({
    this.id,
    required this.type,
    required this.filePath,
    this.thumbnailPath,
    required this.timestamp,
    required this.watermarkId,
    required this.watermarkName,
    this.locationAddress,
    this.locationLatitude,
    this.locationLongitude,
    this.customFields,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'file_path': filePath,
      'thumbnail_path': thumbnailPath,
      'timestamp': timestamp.toIso8601String(),
      'watermark_id': watermarkId,
      'watermark_name': watermarkName,
      'location_address': locationAddress,
      'location_latitude': locationLatitude,
      'location_longitude': locationLongitude,
      'custom_fields': customFields != null ? jsonEncode(customFields) : null,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory MediaRecord.fromMap(Map<String, dynamic> map) {
    return MediaRecord(
      id: map['id'] as int?,
      type: map['type'] as String,
      filePath: map['file_path'] as String,
      thumbnailPath: map['thumbnail_path'] as String?,
      timestamp: DateTime.parse(map['timestamp'] as String),
      watermarkId: map['watermark_id'] as int,
      watermarkName: map['watermark_name'] as String,
      locationAddress: map['location_address'] as String?,
      locationLatitude: map['location_latitude'] as double?,
      locationLongitude: map['location_longitude'] as double?,
      customFields: map['custom_fields'] != null
          ? jsonDecode(map['custom_fields'] as String)
          : null,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}


class WatermarkTemplate {
  int? id;

  
  String name;

  
  String category;

  
  
  List<Map<String, dynamic>> fieldsConfig;

  
  bool isFavorite;

  
  int sortOrder;

  
  DateTime createdAt;

  WatermarkTemplate({
    this.id,
    required this.name,
    required this.category,
    required this.fieldsConfig,
    this.isFavorite = false,
    this.sortOrder = 0,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'fields_config': jsonEncode(fieldsConfig),
      'is_favorite': isFavorite ? 1 : 0,
      'sort_order': sortOrder,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory WatermarkTemplate.fromMap(Map<String, dynamic> map) {
    return WatermarkTemplate(
      id: map['id'] as int?,
      name: map['name'] as String,
      category: map['category'] as String,
      fieldsConfig: List<Map<String, dynamic>>.from(
        jsonDecode(map['fields_config'] as String),
      ),
      isFavorite: map['is_favorite'] == 1,
      sortOrder: map['sort_order'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  WatermarkTemplate copyWith({
    int? id,
    String? name,
    String? category,
    List<Map<String, dynamic>>? fieldsConfig,
    bool? isFavorite,
    int? sortOrder,
    DateTime? createdAt,
  }) {
    return WatermarkTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      fieldsConfig: fieldsConfig ?? this.fieldsConfig,
      isFavorite: isFavorite ?? this.isFavorite,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
