import 'package:clean_up/utils/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../utils/constants/image_strings.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true, // Ensures layout adjusts for keyboard
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Icon(
                    CupertinoIcons.arrow_left,
                    size: 35,
                    color: RColors.secondary,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Rate your Cleaner",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                ),
                const SizedBox(height: 20),
                const CircleAvatar(
                  backgroundImage: AssetImage(RImages.avatar),
                  radius: 50,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Jamal",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total",
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        "\$100",
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Time",
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        "25 min",
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star_rate_rounded,
                      size: 30,
                      color: RColors.secondary,
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.star_rate_rounded,
                      size: 30,
                      color: RColors.secondary,
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.star_rate_rounded,
                      size: 30,
                      color: RColors.secondary,
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.star_rate_rounded,
                      size: 30,
                      color: RColors.secondary,
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.star_rate_rounded,
                      size: 30,
                      color: RColors.secondary,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    textAlign: TextAlign.start,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Comment",
                      hintStyle: TextStyle(
                        fontSize: 20,
                        color: RColors.secondary,
                      ),
                      border: OutlineInputBorder(), // Added border for clarity
                    ),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 80),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text(
                      "Done",
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
