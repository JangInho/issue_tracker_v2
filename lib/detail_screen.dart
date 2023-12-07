import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:issue_tracker_v2/model/related_search_term.dart';

enum TendencyType {
  red('보수', Color(0xFFF8462F), Color(0xFFFBC4BD)),
  blue('진보', Color(0xFF305FF2), Color(0xFFD2E7FA));

  const TendencyType(this.text, this.startColor, this.endColor);

  final String text;
  final Color startColor;
  final Color endColor;
}

class DetailScreen extends StatefulWidget {
  String term;
  DetailScreen({super.key, required this.term});

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
    _getRelatedSearchTerms();
  }

  @override
  Widget build(BuildContext context) {

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
                    Text(
                      widget.term,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 32, color: Colors.black),
                    ),
                    const SizedBox(height: 12),
                    Text(
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
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: TendencyType.blue.startColor),
                        ),
                        const Spacer(),
                        const SizedBox(
                          width: 64,
                        ),
                        const Spacer(),
                        Text('보수', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: TendencyType.red.startColor)),
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
                            height: 40,
                            width: double.infinity,
                            child: Row(
                              children: [
                                _buildLinearGraphCell(
                                    index: index,
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
                                    index: index,
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

  Expanded _buildLinearGraphCell(
      {required int index, required TendencyType type, required String title, required double percent}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: type == TendencyType.blue ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: type.startColor)),
          Container(
            height: 15,
            decoration: BoxDecoration(
              color: _getColorAtStep(type.startColor, type.endColor, index + 1),
              borderRadius: BorderRadius.circular(4),
            ),
            width: (MediaQuery.of(context).size.width / 2 - 80) * percent,
          ),
        ],
      ),
    );
  }

  Color _getColorAtStep(Color startColor, Color endColor, int selectedStep) {
    double ratio = selectedStep / 10;
    Color selectedColor = Color.lerp(startColor, endColor, ratio)!;

    return selectedColor;
  }

  Future<void> _getRelatedSearchTerms() async {
    Uri relatedSearchTermsUrl = Uri.parse('https://ow3gdfmu6zikegskhm6wozyobm0ylczz.lambda-url.ap-northeast-2.on.aws/');
    Response response = await http.get(relatedSearchTermsUrl, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    String cacheTimeString = jsonDecode(response.body)['cache_time'];
    cacheTime = DateTime.parse(cacheTimeString);
    cacheTimeMinus4days = cacheTime.subtract(const Duration(days: 4));
    relatedSearchTerm = RelatedSearchTerm.fromJson(jsonDecode(response.body)[widget.term]);

    if (response.statusCode == 200) {
    } else {}

    setState(() {
      isLoading = false;
    });
  }
}
