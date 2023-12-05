import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:issue_tracker_v2/detail_screen.dart';
import 'package:http/http.dart' as http;

class _Top10Model {
  final String cacheTime;
  final List<String> keywords;

  _Top10Model(this.cacheTime, this.keywords);

  _Top10Model.fromJson(Map<String, dynamic> json)
      : cacheTime = json['cache_time'] as String,
        keywords = List<String>.from(json['keywords'].map((x) => x as String));

  Map<String, dynamic> toJson() => {
        'cache_time': cacheTime,
        'keywords': keywords,
      };
}

class IssueTrackerMain extends StatefulWidget {
  const IssueTrackerMain({super.key});

  @override
  State<IssueTrackerMain> createState() => _IssueTrackerMainState();
}

class _IssueTrackerMainState extends State<IssueTrackerMain> {
  _Top10Model? _data;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final response = await http.get(
        Uri.parse(
            'https://4hthfqzswiu4gm5f462wcuuuuy0mdjef.lambda-url.ap-northeast-2.on.aws/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        });
    setState(() {
      _data = _Top10Model.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _data == null
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          DateFormat('yyyy.M.d.(E)', 'ko_KR')
                              .format(DateTime.now()),
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 36,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      '${DateFormat('M.d').format(DateTime.parse(_data!.cacheTime))} ~ ${DateFormat('M.d').format(DateTime.now())}의 트렌드',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    const Divider(
                      thickness: 2,
                      color: Color(0xFFCCCCCC),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: _data!.keywords.length,
                        itemBuilder: (context, index) {
                          final keyword = _data!.keywords[index];
                          return RankingCell(index: index, keyword: keyword);
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 20);
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class RankingCell extends StatefulWidget {
  final String keyword;
  final int index;

  const RankingCell({
    required this.keyword,
    required this.index,
    super.key,
  });

  @override
  State<RankingCell> createState() => _RankingCellState();
}

class _RankingCellState extends State<RankingCell> {
  bool isTapDown = false;
  // get ranking list box
  late Box box;

  @override
  void initState() {
    super.initState();
    Hive.openBox('RankingList').then((value) {
      setState(() {
        box = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const DetailScreen(),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isTapDown ? Colors.grey.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40,
              alignment: Alignment.center,
              child: Text(
                '${widget.index + 1}',
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(width: 20),
            Row(
              children: [
                Text(
                  widget.keyword,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 10),
                _randomWidget(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _randomWidget() {
    final random = Random();
    final randomInt = random.nextInt(100);
    // divide 5 sections
    if (randomInt < 20) {
      return const SizedBox();
    } else if (randomInt < 40) {
      return Row(
        children: [
          const Icon(
            Icons.arrow_upward,
            color: Colors.red,
          ),
          Text(
            '${random.nextInt(7) + 1}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
        ],
      );
    } else if (randomInt < 60) {
      return Row(
        children: [
          const Icon(
            Icons.arrow_downward,
            color: Colors.blue,
          ),
          Text(
            '${random.nextInt(7) + 1}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.blue,
            ),
          ),
        ],
      );
    } else if (randomInt < 80) {
      return const SizedBox();
    } else {
      return const Text(
        "NEW",
        style: TextStyle(
          color: Colors.red,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      );
    }
  }
}
