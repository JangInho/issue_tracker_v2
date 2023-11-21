import 'package:flutter/material.dart';
import 'package:issue_tracker_v2/detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const IssueTrackerMain(),
    );
  }
}

class IssueTrackerMain extends StatefulWidget {
  const IssueTrackerMain({super.key});

  @override
  State<IssueTrackerMain> createState() => _IssueTrackerMainState();
}

class _IssueTrackerMainState extends State<IssueTrackerMain> {
  double translationValue = 0.0;

  Map<String, dynamic> dummy = {
    'data': [
      {'rank': 1, 'key_word': '장인호', 'up': 3},
      {'rank': 1, 'key_word': '장인호', 'up': 3},
      {'rank': 1, 'key_word': '장인호', 'up': 3},
      {'rank': 1, 'key_word': '장인호', 'up': 3},
      {'rank': 1, 'key_word': '장인호', 'up': 3},
      {'rank': 1, 'key_word': '장인호', 'up': 3},
      {'rank': 1, 'key_word': '장인호', 'up': 3},
      {'rank': 1, 'key_word': '장인호', 'up': 3},
    ]
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  Row(
                    children: [
                      const Text(
                        '2023.11.06.(금)',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 32, color: Colors.black),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        children: [
                          Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationZ(90 * 3.1415926535 / 180),
                              child: const Icon(Icons.arrow_back_ios_rounded)),
                          Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationZ(270 * 3.1415926535 / 180),
                              child: const Icon(Icons.arrow_back_ios_rounded)),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    '11.2 ~ 11.6 트렌드',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  const SizedBox(
                    width: 150,
                    child: Divider(
                      thickness: 2,
                      color: Color(0xFFCCCCCC),
                    ),
                  ),
                  const SizedBox(
                    height: 26,
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return RankingCell(index: index);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                          height: 10,
                        );
                      },
                    ),
                  ),
                ],
              ),
            )));
  }
}

class RankingCell extends StatefulWidget {
  int index;

  RankingCell({
    super.key,
    required this.index,
  });

  @override
  State<RankingCell> createState() => _RankingCellState();
}

class _RankingCellState extends State<RankingCell> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  bool isTapDown = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _animation = Tween<double>(begin: 1, end: 0.96).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapCancel: () async {
        print('tap cancel');
        setState(() {
          isTapDown = false;
        });
        await _animationController.animateBack(0);
      },
      onTapDown: (TapDownDetails details) async {
        print('tap down');
        await _animationController.forward();
        setState(() {
          isTapDown = true;
        });
      },
      onTapUp: (TapUpDetails details) async {
        print('tap up');
        setState(() {
          isTapDown = false;
        });
        await _animationController.animateBack(0);
      },
      onTap: () async {
        print('onTap');
        await Future.delayed(const Duration(milliseconds: 30));
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DetailScreen()));
      },
      child: ScaleTransition(
        scale: _animation,
        child: Container(
          decoration: BoxDecoration(
            color: isTapDown ? Colors.grey.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Row(
              children: [
                const SizedBox(width: 8),
                SizedBox(
                    width: 40,
                    child:
                        Text('${widget.index + 1}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800))),
                const Row(
                  children: [
                    Text('장인호', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'new',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.red),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
