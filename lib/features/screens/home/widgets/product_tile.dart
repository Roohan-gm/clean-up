import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../models/service_model.dart';
import '../../../controllers/services_cart/services_cart_controller.dart';

class ProductTile extends StatelessWidget {
  final ServicesModel service;
  final String cartItemId;

  const ProductTile(
      {super.key, required this.service, required this.cartItemId});

  @override
  Widget build(BuildContext context) {
    final ServicesCartController servicesCartController = Get.find();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: RColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: RColors.darkGrey.withOpacity(0.3),
            blurRadius: 5,
            spreadRadius: 1,
          )
        ],
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, right: 60),
                height: 90,
                width: 100,
                decoration: BoxDecoration(
                  color: RColors.darkGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Image.network(
                service.image,
                height: 130,
                width: 130,
                fit: BoxFit.contain,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Ensuring minimal vertical size
              children: [
                Text(
                  service.name,
                  style: const TextStyle(
                    color: RColors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        servicesCartController.decreaseCartItemQuantity(
                            cartItemId, service.id);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: RColors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: RColors.darkGrey.withOpacity(0.3),
                              blurRadius: 5,
                              spreadRadius: 1,
                            )
                          ],
                        ),
                        child: const Icon(
                          CupertinoIcons.minus,
                          size: 18,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "${service.quantity}",
                        style: const TextStyle(
                          color: RColors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        servicesCartController.increaseCartItemQuantity(
                            cartItemId, service.id);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: RColors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: RColors.darkGrey.withOpacity(0.3),
                              blurRadius: 5,
                              spreadRadius: 1,
                            )
                          ],
                        ),
                        child: const Icon(
                          CupertinoIcons.add,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min, // Important for shrinking to fit
              children: [
                InkWell(
                  onTap: () {
                    servicesCartController.removeServiceFromCart(
                        cartItemId, service.id);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: RColors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: RColors.darkGrey.withOpacity(0.4),
                          blurRadius: 5,
                          spreadRadius: 1,
                        )
                      ],
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: RColors.primary,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Replaces Spacer
                Text(
                  "\$${service.price.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: RColors.darkGrey,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
