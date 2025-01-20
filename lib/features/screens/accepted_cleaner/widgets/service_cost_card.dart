import 'package:flutter/material.dart';
import '../../../../../utils/constants/colors.dart';

class ServiceCostCard extends StatelessWidget {
  final List<dynamic> servicesCart;
  final String cost;

  const ServiceCostCard({
    super.key,
    required this.servicesCart,
    required this.cost,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: RColors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Services",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: RColors.black,
              ),
            ),
            const SizedBox(height: 10),
            ...servicesCart[0]['services_model'].map<Widget>((service) {
              return Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${service['name']} (${service['quantity']})",
                        style: const TextStyle(
                            color: RColors.secondary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  )
              );
            }).toList(),
            const Divider(),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Total: Rs.$cost",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: RColors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
