import 'package:calendar/core/extensions/date_format.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../features/data/models/event_model.dart';

class EventService {
  static final EventService instance = EventService._constructor();
  static const id = "id";
  static const eventName = "eventName";
  static const eventDescription = "eventDescription";
  static const color = "color";
  static const eventStartTime = "eventStartTime";
  static const eventFinishTime = "eventFinishTime";
  static const createdAt = "createdAt";
  static const eventTable = "events";
  static Database? _db;

  EventService._constructor();

  Future<Database> getDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, '$eventTable.db');

    return await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute('''
  CREATE TABLE $eventTable(
  $id INTEGER PRIMARY KEY AUTOINCREMENT, 
  $eventStartTime TEXT,
  $eventFinishTime TEXT,
  $eventName  TEXT NOT NULL,
  $eventDescription TEXT NOT NULL,
  $color  TEXT NOT NULL,
  $createdAt TEXT NOT NULL
  )''');
    });
  }

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<void> addEvent(EventModel eventModel) async {
    final db = await database;
    await db.insert(eventTable, eventModel.toJson());
  }

  Future<void> updateEvent(EventModel eventModel) async {
    final db = await database;
    await db.update(
      eventTable,
      eventModel.toJson(),
      where: "id = ?",
      whereArgs: [eventModel.id],
    );
  }

  Future<void> deleteEvent(int id) async {
    final db = await database;
    await db.delete(
      eventTable,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<List<EventModel>> getAllEvents(DateTime date) async {
    final db = await database;
    final List<Map<String, Object?>> maps = await db.query(
      eventTable,
      where: 'createdAt = ?',
      whereArgs: [
        date.dateFormat(),
      ],
    );
    print(maps);
    final result = List.generate(maps.length, (i) {
      return EventModel.fromJson(maps[i]);
    });
    print(result);
    return result;
  }
}
