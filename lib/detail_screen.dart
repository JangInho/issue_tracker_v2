import 'package:flutter/material.dart';

enum TendencyType {
  red('보수', Color(0xFFF8462F)),
  blue('진보', Color(0xFF305FF2));

  const TendencyType(this.text, this.color);

  final String text;
  final Color color;
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

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
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '장인호 new',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 32, color: Colors.black),
              ),
              const SizedBox(height: 12),
              const Text(
                '11.2 ~ 11.6 트렌드',
                style: TextStyle(
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
                          _buildLinearGraphCell(type: TendencyType.blue, title: '진보!!!!'),
                          SizedBox(
                            width: 40,
                            child: Center(
                                child: Text(
                              '${index + 1}',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            )),
                          ),
                          _buildLinearGraphCell(type: TendencyType.red, title: '보수!!!'),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 10);
                  },
                  itemCount: 10,
                ),
              ),
            ],
          ),
        ));
  }

  Expanded _buildLinearGraphCell({required TendencyType type, required String title}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: type == TendencyType.blue ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: type.color)),
          Container(
            height: 10,
            width: 60,
            color: type.color,
          ),
        ],
      ),
    );
  }
}
