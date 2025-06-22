import 'package:flutter/material.dart';
import 'package:frontend/auth/pages/login_or_register_screen.dart';
import 'package:frontend/cart/cart_screen.dart';
import 'package:frontend/home/models/home_model.dart';
import 'package:frontend/home/providers/home_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false).fetchServices().then((
        result,
      ) {
        result.match(
          (err) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $err'), backgroundColor: Colors.red),
          ),
          (services) => null,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Our Services'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginOrRegisterScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          if (provider.errorMessage.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  provider.errorMessage,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (provider.services.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: provider.services.length,
            itemBuilder: (context, index) {
              final service = provider.services[index];
              return ServiceCard(service: service);
            },
          );
        },
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final HomeModel service;

  const ServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);
    final isInCart = provider.isInCart(service);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    service.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[900],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isInCart
                        ? Icons.remove_shopping_cart
                        : Icons.add_shopping_cart,
                    color: isInCart ? Colors.red : Colors.green,
                  ),
                  onPressed: () {
                    if (isInCart) {
                      provider.removeFromCart(service);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${service.name} removed from cart'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      provider.addToCart(service);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${service.name} added to cart'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.build, 'Skill: ${service.skill}'),
            const SizedBox(height: 4),
            _buildInfoRow(Icons.location_on, 'Location: ${service.location}'),
            const SizedBox(height: 4),
            _buildInfoRow(Icons.phone, 'Contact: ${service.contact}'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.blue[700]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        ),
      ],
    );
  }
}
