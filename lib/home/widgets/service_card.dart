import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/home_model.dart';
import '../providers/home_provider.dart';
import '../services/details.dart';

class ServiceCard extends StatelessWidget {
  final HomeModel service;

  const ServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);
    final isInCart = provider.isInCart(service);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceDetailsScreen(homeModel: service),
          ),
        );
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  service.image, // Replace with actual image URL or asset path
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          Container(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 4),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      service.skill,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${service.price}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  if (!isInCart) {
                    provider.addToCart(service);
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${service.name} added to cart'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    provider.removeFromCart(service);
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${service.name} removed from cart'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                icon: Icon(
                  isInCart
                      ? Icons.remove_shopping_cart
                      : Icons.add_shopping_cart,
                  color: isInCart ? Colors.red : Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
