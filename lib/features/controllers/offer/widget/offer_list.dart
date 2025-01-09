import 'package:flutter/material.dart';
import '../../../models/order_details_model.dart';
import 'fetch_nearby_orders.dart';

class OfferList extends StatelessWidget {
  final double cleanerLatitude;
  final double cleanerLongitude;

  const OfferList({super.key, required this.cleanerLatitude, required this.cleanerLongitude});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OrderDetails>>(
      future: fetchNearbyOrderDetails(cleanerLatitude, cleanerLongitude, radius: 15.0),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No pending orders nearby."));
        } else {
          final orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return InkWell(
                onTap: () => _modifyOffer(context, order),
                child: Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(order.customerProfilePic),
                      radius: 20,
                    ),
                    title: Text(order.customerName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Address: ${order.address}"),
                        Text("Total: Rs.${order.totalPrice}"),
                        Text("Distance: ${order.distance} km"),
                        Text("Services: ${order.services.map((s) => '${s.name} (${s.quantity})').join(", ")}"),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}



  void _modifyOffer(BuildContext context, OrderDetails order) {
    double offerAmount = 0;
    int arrivalTime = 0;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Modify Offer"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Offer Amount"),
                onChanged: (value) => offerAmount = double.tryParse(value) ?? offerAmount,
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Arrival Time (minutes)"),
                onChanged: (value) => arrivalTime = int.tryParse(value) ?? arrivalTime,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (offerAmount > 0 && arrivalTime > 0) {
                  _submitOffer(order.id, offerAmount, arrivalTime);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Enter valid values")),
                  );
                }
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitOffer(String?  orderId, double offerAmount, int arrivalTime) async {
    try {
      await supabaseClient.from('offer').insert({
        'order_id': orderId,
        'offer_amount': offerAmount,
        'arrival_time': arrivalTime,
        'status': 'pending',
      });
    } catch (e) {
      throw Exception('Failed to submit offer: $e');
    }
  }

