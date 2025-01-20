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
        maxHeight: 600, // Maximum height
      ),
      child: Container(
        padding: const EdgeInsets.only(top: 16, left: 4, right: 4),
        color: RColors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min, // Adjust height to content
          children: [
            // Cart Items List
            Obx(() {
              if (servicesCartController.cartItems.isEmpty) {
                return _buildEmptyCart();
              }

              // Flatten the services from all cart items into a single list
              final servicesList = servicesCartController.cartItems
                  .expand((cartItem) => cartItem.servicesModel)
                  .toList();

              return _buildCartItemsList(servicesList);
            }),

            // Service Completion Section
            ServiceCompletionEssential(
              servicesCartController: servicesCartController,
            ),
          ],
        ),
      ),
    ));
  }

  // Build Empty Cart UI
  Widget _buildEmptyCart() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              color: RColors.darkGrey,
              size: 40,
            ),
            SizedBox(height: 10),
            Text(
              "Your cart is empty",
              style: TextStyle(
                fontSize: 18,
                color: RColors.darkGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build Cart Items List
  Widget _buildCartItemsList(List servicesList) {
    return Expanded(
      child: ListView.builder(
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
      ),
    );
  }
}
