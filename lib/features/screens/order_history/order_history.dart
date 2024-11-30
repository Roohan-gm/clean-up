import 'package:clean_up/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';

class OrderHistory extends StatelessWidget {
  const OrderHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Order History",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: 3,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 3),
              elevation: 4,
              child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  subtitleTextStyle: const TextStyle(color: RColors.secondary),
                  tileColor: RColors.white,
                  leading: const Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(RImages.avatar),
                        radius: 18,
                      ),
                      Text(
                        "Jamal",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  title: const Text("703 Windfall Rd. Park Ridge, IL 60068"),
                  subtitle: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "\$20",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        Text(
                          "1 km",
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          "5 min",
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          "2 beds, 1 bath",
                          style: TextStyle(fontSize: 14),
                        ),
                      ])),
            );
          },
        ));
  }
}
