import 'package:clean_up/features/screens/offer_accepted/offer_accepted.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';

class OnlineScreen extends StatefulWidget {
  const OnlineScreen({super.key});

  @override
  State<OnlineScreen> createState() => _OnlineScreenState();
}

class _OnlineScreenState extends State<OnlineScreen> {
  bool _hasOffers = false; // Track whether offers are available

  // Mock function to simulate fetching offers after a delay
  void _fetchOffers() async {
    await Future.delayed(
        const Duration(seconds: 5)); // simulate a 5-second wait
    setState(() {
      _hasOffers = true; // Update the state to show offers
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchOffers(); // start searching for offers when the screen loads
  }

  @override
  Widget build(BuildContext context) {
    return _hasOffers ? _OfferList() : const _SearchingOfferScreen();
  }
}

class _OfferList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Available Offers",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 3,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => Get.to(() => const OfferAccepted()),
            child: Card(
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
            ),
          );
        },
      ),
    );
  }
}

class _SearchingOfferScreen extends StatelessWidget {
  const _SearchingOfferScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Searching for available cleaning services...",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: RColors.black),
          ),
          Text(
            "Distance: 15 Km",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: RColors.secondary),
          ),
        ],
      ),
    );
  }
}
