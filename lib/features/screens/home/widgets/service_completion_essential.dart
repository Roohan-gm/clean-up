import 'package:clean_up/features/screens/available_cleaners/available_cleaner.dart';
import 'package:clean_up/features/screens/home/widgets/map_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/colors.dart';

class ServiceCompletionEssential extends StatelessWidget {
  const ServiceCompletionEssential({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: RColors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: RColors.darkGrey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 5)
          ]),
      child: Column(
        children: [
          ElevatedButton(
              onPressed: () => Get.to(() => const MapScreen()),
              style: ElevatedButton.styleFrom(
                backgroundColor: RColors.darkGrey,
                side: const BorderSide(color: RColors.darkGrey),
                foregroundColor: RColors.white,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 10),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    CupertinoIcons.search,
                    color: RColors.white,
                  ),
                  Text(
                    "Location of Service?",
                    style: TextStyle(fontSize: 20),
                  ),
                  Icon(
                    CupertinoIcons.arrow_right,
                    color: RColors.white,
                  ),
                ],
              )),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            maxLines: 2,
            decoration: const InputDecoration(
                alignLabelWithHint: true,

                prefixIcon: Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Icon(CupertinoIcons.news),
                ),
                labelText: "Notes",
                labelStyle: TextStyle(color: RColors.darkGrey)),
          ),
          const SizedBox(
            height: 10,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Cost:",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: RColors.darkGrey),
              ),
              Text(
                "\$55",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: RColors.darkGrey),
              )
            ],
          ),
          const Divider(
            height: 20,
            thickness: 0.5,
            color: RColors.darkGrey,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.to(() => const AvailableCleaner()),
              style: ElevatedButton.styleFrom(
                backgroundColor: RColors.primary,
                foregroundColor: RColors.white,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 10),
              ),
              child: const Text(
                "Find Cleaner",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
