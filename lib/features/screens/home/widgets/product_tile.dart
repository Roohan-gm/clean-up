import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../models/service_model.dart';
import '../../../controllers/services_cart/services_cart_controller.dart';

class ProductTile extends StatelessWidget {
  final ServicesModel service;
  final String cartItemId;

  const ProductTile({super.key, required this.service, required this.cartItemId});

  @override
  Widget build(BuildContext context) {
    final ServicesCartController servicesCartController = Get.find();
    final screenWidth = MediaQuery.of(context).size.width;

    // Define dynamic font and icon sizes
    final double fontSize = screenWidth * 0.045;
    final double smallFontSize = screenWidth * 0.04;
    final double iconSize = screenWidth * 0.06;
    final double largeIconSize = screenWidth * 0.08;
    final double imageSize = screenWidth * 0.18;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: RColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: RColors.darkGrey.withOpacity(0.15),
            blurRadius: 10,
            spreadRadius: 3,
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service Image Section
          _buildServiceImage(service.image, imageSize),

          // Product Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    service.name,
                    style: TextStyle(
                      color: RColors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: fontSize,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 10),

                  // Quantity Adjuster
                  Row(
                    children: [
                      _buildQuantityButton(
                        onPressed: () {
                          servicesCartController.decreaseCartItemQuantity(cartItemId, service.id);
                        },
                        icon: CupertinoIcons.minus,
                        iconSize: iconSize,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "${service.quantity}",
                          style: TextStyle(
                            color: RColors.black,
                            fontSize: fontSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      _buildQuantityButton(
                        onPressed: () {
                          servicesCartController.increaseCartItemQuantity(cartItemId, service.id);
                        },
                        icon: CupertinoIcons.add,
                        iconSize: iconSize,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Price & Delete Button Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Delete Button
              _buildDeleteButton(servicesCartController, cartItemId, service.id, largeIconSize),

              const SizedBox(height: 12), // Spacing between delete button and price

              // Price Label
              Text(
                "Rs. ${service.price.toStringAsFixed(2)}",
                style: TextStyle(
                  color: RColors.darkGrey,
                  fontWeight: FontWeight.w600,
                  fontSize: smallFontSize,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method to build the service image section
  Widget _buildServiceImage(String imageUrl, double size) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8, right: 30),
          height: size,
          width: size,
          decoration: BoxDecoration(
            color: RColors.darkGrey,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            imageUrl,
            height: size + 10,
            width: size + 10,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 80),
          ),
        ),
      ],
    );
  }

  // Helper method to build the quantity buttons
  Widget _buildQuantityButton({required VoidCallback onPressed, required IconData icon, required double iconSize}) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: RColors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: RColors.darkGrey.withOpacity(0.1),
              blurRadius: 6,
              spreadRadius: 1,
            )
          ],
        ),
        child: Icon(
          icon,
          size: iconSize,
          color: RColors.primary,
        ),
      ),
    );
  }

  // Helper method to build the delete button
  Widget _buildDeleteButton(
      ServicesCartController servicesCartController, String cartItemId, String serviceId, double iconSize) {
    return InkWell(
      onTap: () {
        servicesCartController.removeServiceFromCart(cartItemId, serviceId);
      },
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: RColors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: RColors.darkGrey.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 3,
            )
          ],
        ),
        child: Icon(
          Icons.delete_outline,
          color: RColors.primary,
          size: iconSize,
        ),
      ),
    );
  }
}
