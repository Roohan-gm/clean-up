import 'package:clean_up/features/screens/accepted_cleaner/accepted_cleaner.dart';
import 'package:clean_up/utils/constants/colors.dart';
import 'package:clean_up/utils/constants/image_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AvailableCleaner extends StatelessWidget {
  const AvailableCleaner({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Text(
                "Available Cleaners",
                style: Theme.of(context).textTheme.headlineLarge
                // TextStyle(
                //   fontSize: 40,
                //   fontWeight: FontWeight.bold,
                //   color: RColors.black,
                // ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView.builder(
                  itemCount: 3, // Replace with your actual item count.
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      color: RColors.white,
                      elevation: 5,
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundImage: AssetImage(RImages.avatar),
                          maxRadius: 29,
                        ),
                        title: Text("Cleaner ${index + 1}"),
                        subtitle: const Row(
                          children: [
                            Icon(
                              CupertinoIcons.star_fill,
                              color: RColors.primary,
                              size: 15,
                            ),
                            SizedBox(width: 5),
                            Text(
                              "4.2",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: RColors.black,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "(2,342)",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: RColors.darkGrey,
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "\$200",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: RColors.black,
                                  ),
                                ),
                                Text(
                                  "5 min",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: RColors.black,
                                  ),
                                ),
                                Text(
                                  "2 km",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: RColors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: 23,
                                  child: ElevatedButton(
                                    onPressed: () => Get.off(()=> const AcceptedCleaner()),
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: RColors.white,
                                      textStyle: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      backgroundColor: RColors.primary,
                                      padding: EdgeInsets.zero,
                                      alignment: Alignment.center,
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    child: const Text(
                                      "Accept",
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  height: 23,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: RColors.white,
                                      backgroundColor: RColors.secondary,
                                      padding: EdgeInsets.zero,
                                      textStyle: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      alignment: Alignment.center,
                                      elevation: 5,
                                      side:
                                          const BorderSide(color: RColors.secondary),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    child: const Text(
                                      "Decline",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: RColors.white,
                  backgroundColor: RColors.secondary,
                  alignment: Alignment.center,
                  side: const BorderSide(color: RColors.secondary),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Get.back(),
                child: const Text(
                  "Cancel Order",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
