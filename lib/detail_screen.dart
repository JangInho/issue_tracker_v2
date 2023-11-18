import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

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
          ],
        ),
      ),
    ));
  }
}
