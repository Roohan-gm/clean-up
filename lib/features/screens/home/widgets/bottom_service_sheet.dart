import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clean_up/features/controllers/services_cart/services_cart_controller.dart';
import 'package:clean_up/features/screens/home/widgets/product_tile.dart';
import 'package:clean_up/features/screens/home/widgets/service_completion_essential.dart';
import '../../../../../utils/constants/colors.dart';

class BottomServiceSheet extends StatelessWidget {
  final ServicesCartController servicesCartController;

  const BottomServiceSheet({super.key, required this.servicesCartController});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 800, // Maximum height
        ),
        child: Container(
          padding: const EdgeInsets.only(top: 20),
          color: RColors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min, // Adjust height to content
            children: [
              // Cart Items List
              Obx(() {
                if (servicesCartController.cartItems.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        "Your cart is empty",
                        style: TextStyle(
                          fontSize: 18,
                          color: RColors.darkGrey,
                        ),
                      ),
                    ),
                  );
                }

                // Flatten the services from all cart items into a single list
                final servicesList = servicesCartController.cartItems
                    .expand((cartItem) => cartItem.servicesModel)
                    .toList();

                return ListView.builder(
                  shrinkWrap: true, // Wrap content
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: servicesList.length,
                  itemBuilder: (context, index) {
                    final service = servicesList[index];
                    final cartItem = servicesCartController.cartItems.firstWhere(
                          (cartItem) => cartItem.servicesModel.contains(service),
                    );
                    return ProductTile(
                      service: service,
                      cartItemId: cartItem.id,
                    );
                  },
                );
              }),

              // Service Completion Section
              ServiceCompletionEssential(
                servicesCartController: servicesCartController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
