import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';

class CustomBottomSheetOffer extends StatelessWidget {
  const CustomBottomSheetOffer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 500,
      color: RColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 90,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(RImages.avatar),
                      radius: 28,
                    ),
                    Text(
                      "Jamal",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    Text(
                      "703 Windfall Rd. Park Ridge, IL 60068",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "2 beds, 1 bath",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: RColors.secondary),
                    ),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Column(children: [
                  Text(
                    "1 km",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: RColors.secondary),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "5 min",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: RColors.secondary),
                  ),
                ])
              ],
            ),
          ),
          const Text(
            "how long will it take?",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  style: const ButtonStyle(
                      side: WidgetStatePropertyAll(BorderSide.none),
                      backgroundColor:
                          WidgetStatePropertyAll(RColors.secondary),
                      padding: WidgetStatePropertyAll(
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10))),
                  onPressed: () {},
                  child: const Text(
                    "5 min",
                    style: TextStyle(fontSize: 20),
                  )),
              ElevatedButton(
                  style: const ButtonStyle(
                      side: WidgetStatePropertyAll(BorderSide.none),
                      backgroundColor:
                          WidgetStatePropertyAll(RColors.secondary),
                      padding: WidgetStatePropertyAll(
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10))),
                  onPressed: () {},
                  child: const Text(
                    "10 min",
                    style: TextStyle(fontSize: 20),
                  )),
              ElevatedButton(
                  style: const ButtonStyle(
                      side: WidgetStatePropertyAll(BorderSide.none),
                      backgroundColor:
                          WidgetStatePropertyAll(RColors.secondary),
                      padding: WidgetStatePropertyAll(
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10))),
                  onPressed: () {},
                  child: const Text(
                    "15 min",
                    style: TextStyle(fontSize: 20),
                  )),
              ElevatedButton(
                  style: const ButtonStyle(
                      side: WidgetStatePropertyAll(BorderSide.none),
                      backgroundColor:
                          WidgetStatePropertyAll(RColors.secondary),
                      padding: WidgetStatePropertyAll(
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10))),
                  onPressed: () {},
                  child: const Text(
                    "20 min",
                    style: TextStyle(fontSize: 20),
                  )),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "\$180",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: RColors.secondary),
              ),
              ElevatedButton(
                  style: const ButtonStyle(
                      padding: WidgetStatePropertyAll(
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20))),
                  onPressed: () {},
                  child: const Text(
                    "Your offer",
                    style: TextStyle(fontSize: 20),
                  )),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              style: const ButtonStyle(
                  padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20))),
              onPressed: () {},
              child: const Text(
                "Accept for \$180",
                style: TextStyle(fontSize: 20),
              )),
          const SizedBox(
            height: 20,
          ),
          TextButton(
              onPressed: () {},
              child: const Text(
                "Skip",
                style: TextStyle(
                    fontSize: 20,
                    color: RColors.secondary,
                    fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
  }
}
