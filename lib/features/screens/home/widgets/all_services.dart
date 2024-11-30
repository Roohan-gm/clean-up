import 'package:clean_up/utils/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/constants/text_strings.dart';

class AllServices extends StatelessWidget {
  const AllServices({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 0.68,
      physics:const AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        for (int i = 1; i < 4; i++)
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: RColors.lightGrey,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                      color: RColors.darkGrey, blurRadius: 5, spreadRadius: 1)
                ]),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    "assets/images/services/$i.png",
                    height: 130,
                    width: 130,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      RTexts.roomTitle,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: RColors.black),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    RTexts.roomSubtitle,
                    style: TextStyle(fontSize: 15, color: RColors.darkGrey),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          RTexts.amount,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: RColors.primary,
                          ),
                        ),
                        InkWell(
                          onTap: (){},
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                color: RColors.primary,
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: [
                                  BoxShadow(
                                      color: RColors.black.withOpacity(0.2),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: const Offset(2, 2))
                                ]),
                            child: const Icon(
                              CupertinoIcons.plus_app,
                              color: RColors.white,
                              size: 25,
                            ),
                          ),
                        )
                      ]),
                ),
              ],
            ),
          )
      ],
    );
  }
}
