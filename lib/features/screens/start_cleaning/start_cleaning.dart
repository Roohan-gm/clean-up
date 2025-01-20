import 'dart:async';

import 'package:clean_up/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class StartCleaning extends StatefulWidget {
  const StartCleaning({super.key});

  @override
  State<StartCleaning> createState() => _StartCleaningState();
}

class _StartCleaningState extends State<StartCleaning> {
  Duration duration = const Duration();
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void addTime() {
    const addSeconds = 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      duration = Duration(seconds: seconds);
    });
  }
  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            Center(child: buildTime()),
            const Spacer(),
            const Column(
              children: [
                // ServiceCostCard(),
                // SizedBox(height: 10),
                // CleanerInfoContactCard(),
                SizedBox(height: 20),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final hours = twoDigits(duration.inHours.remainder(60));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildTimeCard(time: hours, header: 'HOURS'),
        const SizedBox(width: 8,),
        buildTimeCard(time: minutes, header: 'MINUTES'),
        const SizedBox(width: 8,),
        buildTimeCard(time: seconds, header: 'SECONDS'),
      ],
    );
  }

  buildTimeCard({required String time, required String header}) =>
      Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Material(elevation: 5,color: RColors.white,
          borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(time,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: RColors.black,
                        fontSize: 72),),
                ),
              ),
            const SizedBox(height: 24,),
            Text(header)
          ]
      );
}
