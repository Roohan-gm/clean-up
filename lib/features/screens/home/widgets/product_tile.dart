import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/text_strings.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({
    super.key,
    required this.i,
  });

  final int i;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
          vertical: 10, horizontal: 15),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 140,
      decoration: BoxDecoration(
          color: RColors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: RColors.darkGrey.withOpacity(0.3),
              blurRadius: 5,
              spreadRadius: 1,
            )
          ]),
      child: Row(
        children: [
          InkWell(
            onTap: () {},
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                      top: 10, right: 60),
                  height: 90,
                  width: 100,
                  decoration: BoxDecoration(
                      color: RColors.darkGrey,
                      borderRadius:
                      BorderRadius.circular(10)),
                ),
                Image.asset(
                  "assets/images/services/$i.png",
                  height: 130,
                  width: 130,
                  fit: BoxFit.contain,
                )
              ],
            ),
          ),
          Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  RTexts.roomTitle,
                  style: TextStyle(
                      color: RColors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 23),
                ),
                Row(children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: RColors.white,
                        borderRadius:
                        BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: RColors.darkGrey
                                .withOpacity(0.3),
                            blurRadius: 5,
                            spreadRadius: 1,
                          )
                        ]),
                    child: const Icon(
                      CupertinoIcons.minus,
                      size: 18,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10),
                    child: const Text(
                      "2",
                      style: TextStyle(
                          color: RColors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: RColors.white,
                        borderRadius:
                        BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: RColors.darkGrey
                                .withOpacity(0.3),
                            blurRadius: 5,
                            spreadRadius: 1,
                          )
                        ]),
                    child: const Icon(
                      CupertinoIcons.add,
                      size: 18,
                    ),
                  ),
                ])
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 25),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: RColors.white,
                      borderRadius:
                      BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: RColors.darkGrey
                              .withOpacity(0.4),
                          blurRadius: 5,
                          spreadRadius: 1,
                        )
                      ]),
                  child: const Icon(
                    Icons.delete,
                    color: RColors.primary,
                    size: 20,
                  ),
                ),
                const Spacer(),
                const Text(
                  "\$50",
                  style: TextStyle(
                      color: RColors.darkGrey,
                      fontWeight: FontWeight.w500,
                      fontSize: 20),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}