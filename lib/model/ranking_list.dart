// ignore_for_file: non_constant_identifier_names

import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class RankingList extends HiveObject {
  @HiveField(0)
  final DateTime cache_time;
  @HiveField(1)
  final List<String> keyword;

  RankingList(this.cache_time, this.keyword);
}
