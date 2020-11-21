library item;

import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'item.g.dart';

@HiveType(typeId: 0)
class Item extends HiveObject {
  @HiveField(0)
  String uuid = Uuid().v4();

  @HiveField(1)
  int timestamp = DateTime.now().millisecondsSinceEpoch;

  @HiveField(2)
  String text;

}