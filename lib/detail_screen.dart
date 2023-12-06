import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:issue_tracker_v2/model/related_search_term.dart';

enum TendencyType {
  red('보수', Color(0xFFF8462F)),
  blue('진보', Color(0xFF305FF2));

  const TendencyType(this.text, this.color);

  final String text;
  final Color color;
}

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isLoading = true;
  late DateTime cacheTime;
  late DateTime cacheTimeMinus4days;
  late RelatedSearchTerm relatedSearchTerm;

  @override
  void initState() {
    super.initState();

    getRelatedSearchTerms();
  }

  @override
  Widget build(BuildContext context) {
    Color blue = const Color(0xFF305FF2);
    Color red = const Color(0xFFF8462F);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        extendBodyBehindAppBar: false,
        backgroundColor: Colors.white,
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '탄핵',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 32, color: Colors.black),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      // '11.2 ~ 11.6 트렌드',
                      '${DateFormat('M.d').format(cacheTimeMinus4days)} ~ ${DateFormat('M.d').format(cacheTime)} 트렌드',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        '연관 검색어',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        Text(
                          '진보',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: blue),
                        ),
                        const Spacer(),
                        const SizedBox(
                          width: 64,
                        ),
                        const Spacer(),
                        Text('보수', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: red)),
                        const Spacer(),
                      ],
                    ),
                    const Divider(
                      thickness: 1,
                      color: Color(0xFFCCCCCC),
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          return SizedBox(
                            height: 35,
                            width: double.infinity,
                            child: Row(
                              children: [
                                _buildLinearGraphCell(
                                    type: TendencyType.blue,
                                    title: '${relatedSearchTerm.liberal[index][0]}',
                                    percent: relatedSearchTerm.liberal[index][1]),
                                SizedBox(
                                  width: 40,
                                  child: Center(
                                      child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                  )),
                                ),
                                _buildLinearGraphCell(
                                    type: TendencyType.red,
                                    title: '${relatedSearchTerm.conservative[index][0]}',
                                    percent: relatedSearchTerm.conservative[index][1]),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 10);
                        },
                        itemCount: relatedSearchTerm.liberal.length,
                      ),
                    ),
                  ],
                ),
              ));
  }

  Expanded _buildLinearGraphCell({required TendencyType type, required String title, required double percent}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: type == TendencyType.blue ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: type.color)),
          Container(
            height: 10,
            width: (MediaQuery.of(context).size.width / 2 - 80) * percent,
            color: type.color,
          ),
        ],
      ),
    );
  }

  Future<void> getRelatedSearchTerms() async {
    Uri relatedSearchTermsUrl = Uri.parse('https://ow3gdfmu6zikegskhm6wozyobm0ylczz.lambda-url.ap-northeast-2.on.aws/');
    Response response = await http.get(relatedSearchTermsUrl, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    String cacheTimeString = jsonDecode(response.body)['cache_time'];
    cacheTime = DateTime.parse(cacheTimeString);
    cacheTimeMinus4days = cacheTime.subtract(const Duration(days: 4));
    relatedSearchTerm = RelatedSearchTerm.fromJson(jsonDecode(response.body)['탄핵']);

    if (response.statusCode == 200) {
    } else {}

    setState(() {
      isLoading = false;
    });
  }

}
