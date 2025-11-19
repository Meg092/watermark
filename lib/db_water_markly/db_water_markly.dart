import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'db_water_markly_entity.dart';

class WaterMarklyDB {
  static Database? _database;
  static final WaterMarklyDB _instance = WaterMarklyDB._internal();

  factory WaterMarklyDB() => _instance;

  WaterMarklyDB._internal();

  Future<WaterMarklyDB> init() async {
    if (_database != null) {
      return this;
    }

    final String path = join(await getDatabasesPath(), 'water_markly.db');
    _database = await openDatabase(path, version: 1, onCreate: _onCreate);
    return this;
  }

  Future<void> _onCreate(Database db, int version) async {
    
    await db.execute('''
      CREATE TABLE IF NOT EXISTS media_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        file_path TEXT NOT NULL,
        thumbnail_path TEXT,
        timestamp TEXT NOT NULL,
        watermark_id INTEGER NOT NULL,
        watermark_name TEXT NOT NULL,
        location_address TEXT,
        location_latitude REAL,
        location_longitude REAL,
        custom_fields TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    
    await db.execute('''
      CREATE TABLE IF NOT EXISTS watermark_templates (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        fields_config TEXT NOT NULL,
        is_favorite INTEGER NOT NULL DEFAULT 0,
        sort_order INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL
      )
    ''');

    
    await _insertDefaultTemplates(db);
  }

  Future<void> _insertDefaultTemplates(Database db) async {
    final now = DateTime.now().toIso8601String();

    final List<Map<String, dynamic>> defaultTemplates = [
      {
        'name': 'Attendance Check-in',
        'category': 'work',
        'fields_config': '[]',
        'is_favorite': 0,
        'sort_order': 1,
        'created_at': now,
      },
      {
        'name': 'Construction Record',
        'category': 'work',
        'fields_config':
            '[{"name":"area","label":"Area","type":"text","maxLength":50},{"name":"content","label":"Content","type":"textarea","maxLength":200}]',
        'is_favorite': 0,
        'sort_order': 2,
        'created_at': now,
      },
      {
        'name': 'Patrol Duty',
        'category': 'work',
        'fields_config': '[]',
        'is_favorite': 0,
        'sort_order': 3,
        'created_at': now,
      },
      {
        'name': 'Sales',
        'category': 'work',
        'fields_config':
            '[{"name":"product","label":"Product","type":"text","maxLength":100},{"name":"contact","label":"Contact","type":"text","maxLength":50}]',
        'is_favorite': 0,
        'sort_order': 4,
        'created_at': now,
      },
      {
        'name': 'Quick Note',
        'category': 'work',
        'fields_config':
            '[{"name":"note","label":"Note","type":"textarea","maxLength":200}]',
        'is_favorite': 0,
        'sort_order': 5,
        'created_at': now,
      },
      {
        'name': 'Digital Clock',
        'category': 'work',
        'fields_config': '[]',
        'is_favorite': 0,
        'sort_order': 6,
        'created_at': now,
      },
      {
        'name': 'Travel',
        'category': 'work',
        'fields_config':
            '[{"name":"travel_note","label":"Travel Note","type":"textarea","maxLength":200}]',
        'is_favorite': 0,
        'sort_order': 7,
        'created_at': now,
      },
      {
        'name': 'Inbound',
        'category': 'work',
        'fields_config':
            '[{"name":"goods","label":"Goods","type":"text","maxLength":100},{"name":"quantity","label":"Quantity","type":"text","maxLength":20}]',
        'is_favorite': 0,
        'sort_order': 8,
        'created_at': now,
      },
      {
        'name': 'Outbound',
        'category': 'work',
        'fields_config':
            '[{"name":"goods","label":"Goods","type":"text","maxLength":100},{"name":"quantity","label":"Quantity","type":"text","maxLength":20}]',
        'is_favorite': 0,
        'sort_order': 9,
        'created_at': now,
      },
    ];

    for (final template in defaultTemplates) {
      await db.insert('watermark_templates', template);
    }
  }

  Database get database {
    if (_database == null) {
      throw Exception('Database not initialized. Call init() first.');
    }
    return _database!;
  }

  

  
  Future<int> insertMediaRecord(MediaRecord record) async {
    final db = database;
    return await db.insert('media_records', record.toMap());
  }

  
  Future<List<MediaRecord>> getAllMediaRecords() async {
    final db = database;
    final List<Map<String, dynamic>> maps = await db.query(
      'media_records',
      orderBy: 'timestamp DESC',
    );
    return List.generate(maps.length, (i) => MediaRecord.fromMap(maps[i]));
  }

  
  Future<MediaRecord?> getMediaRecordById(int id) async {
    final db = database;
    final List<Map<String, dynamic>> maps = await db.query(
      'media_records',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) {
      return null;
    }
    return MediaRecord.fromMap(maps.first);
  }

  
  Future<List<MediaRecord>> getMediaRecordsByType(String type) async {
    final db = database;
    final List<Map<String, dynamic>> maps = await db.query(
      'media_records',
      where: 'type = ?',
      whereArgs: [type],
      orderBy: 'timestamp DESC',
    );
    return List.generate(maps.length, (i) => MediaRecord.fromMap(maps[i]));
  }

  
  Future<List<MediaRecord>> getMediaRecordsByWatermarkId(
      int watermarkId) async {
    final db = database;
    final List<Map<String, dynamic>> maps = await db.query(
      'media_records',
      where: 'watermark_id = ?',
      whereArgs: [watermarkId],
      orderBy: 'timestamp DESC',
    );
    return List.generate(maps.length, (i) => MediaRecord.fromMap(maps[i]));
  }

  
  Future<int> updateMediaRecord(MediaRecord record) async {
    final db = database;
    return await db.update(
      'media_records',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  
  Future<int> deleteMediaRecord(int id) async {
    final db = database;
    return await db.delete('media_records', where: 'id = ?', whereArgs: [id]);
  }

  
  Future<int> deleteAllMediaRecords() async {
    final db = database;
    return await db.delete('media_records');
  }

  

  
  Future<int> insertWatermarkTemplate(WatermarkTemplate template) async {
    final db = database;
    return await db.insert('watermark_templates', template.toMap());
  }

  
  Future<List<WatermarkTemplate>> getAllWatermarkTemplates() async {
    final db = database;
    final List<Map<String, dynamic>> maps = await db.query(
      'watermark_templates',
      orderBy: 'sort_order ASC',
    );
    return List.generate(
        maps.length, (i) => WatermarkTemplate.fromMap(maps[i]));
  }

  
  Future<List<WatermarkTemplate>> getWatermarkTemplatesByCategory(
      String category) async {
    final db = database;
    final List<Map<String, dynamic>> maps = await db.query(
      'watermark_templates',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'sort_order ASC',
    );
    return List.generate(
        maps.length, (i) => WatermarkTemplate.fromMap(maps[i]));
  }

  
  Future<List<WatermarkTemplate>> getFavoriteWatermarkTemplates() async {
    final db = database;
    final List<Map<String, dynamic>> maps = await db.query(
      'watermark_templates',
      where: 'is_favorite = ?',
      whereArgs: [1],
      orderBy: 'sort_order ASC',
    );
    return List.generate(
        maps.length, (i) => WatermarkTemplate.fromMap(maps[i]));
  }

  
  Future<WatermarkTemplate?> getWatermarkTemplateById(int id) async {
    final db = database;
    final List<Map<String, dynamic>> maps = await db.query(
      'watermark_templates',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) {
      return null;
    }
    return WatermarkTemplate.fromMap(maps.first);
  }

  
  Future<int> updateWatermarkTemplate(WatermarkTemplate template) async {
    final db = database;
    return await db.update(
      'watermark_templates',
      template.toMap(),
      where: 'id = ?',
      whereArgs: [template.id],
    );
  }

  
  Future<int> toggleWatermarkTemplateFavorite(int id, bool isFavorite) async {
    final db = database;
    return await db.update(
      'watermark_templates',
      {'is_favorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  
  Future<int> deleteWatermarkTemplate(int id) async {
    final db = database;
    return await db
        .delete('watermark_templates', where: 'id = ?', whereArgs: [id]);
  }

  
  Future<int> deleteAllWatermarkTemplates() async {
    final db = database;
    return await db.delete('watermark_templates');
  }

  

  
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}

