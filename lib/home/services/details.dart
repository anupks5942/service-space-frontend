import 'package:flutter/material.dart';
import 'package:frontend/home/models/home_model.dart';
import 'package:frontend/home/providers/home_provider.dart';
import 'package:provider/provider.dart';

class ServiceDetailsScreen extends StatelessWidget {
  final HomeModel homeModel;

  const ServiceDetailsScreen({super.key, required this.homeModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          homeModel.name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Image
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  homeModel.image,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error, size: 50);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Description Section
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              homeModel.skill,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            Text(
              homeModel.location,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            Text(
              homeModel.contact,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            // Add/Remove from Cart Button
            Consumer<HomeProvider>(
              builder: (context, provider, child) {
                final isInCart = provider.isInCart(homeModel);
                return Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (isInCart) {
                        provider.removeFromCart(homeModel);
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Removed from Cart!'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else {
                        provider.addToCart(homeModel);
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Added to Cart!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isInCart ? Colors.red : Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      isInCart ? 'REMOVE FROM CART' : 'ADD TO CART',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
