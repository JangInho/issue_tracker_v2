// ignore_for_file: non_constant_identifier_names

import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class RankingDetail extends HiveObject {
  @HiveField(0)
  final String keyword;
  @HiveField(1)
  final Map<String, double> liberal;
  @HiveField(2)
  final Map<String, double> conservative;

  RankingDetail(
      {required this.keyword,
      required this.liberal,
      required this.conservative});
}
