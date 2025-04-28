import 'package:flutter/material.dart';
import 'package:flutter_liyana/models/product.dart';
import 'package:flutter_liyana/services/product_service.dart';
import 'package:flutter_liyana/constants/colors.dart';
import 'package:intl/intl.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  String formattedPrice(double price) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(decimalDigits: 2);
    return formatter.format(price);
  }

  Widget buildStarRating(double rating) {
    List<Widget> stars = [];
    int fullStars = rating.floor();
    double remainder = rating - fullStars;
    
    for (int i = 0; i < 5; i++) {
      if (i < fullStars) {
        stars.add(Icon(Icons.star, color: Colors.deepOrange, size: 20.0)); 
      } else if (i == fullStars && remainder >= 0.5) {
        stars.add(Icon(Icons.star_half, color: Colors.deepOrange, size: 20.0)); 
      } else {
        stars.add(Icon(Icons.star_border, color: Colors.deepOrange, size: 20.0)); 
      }
    }
    
    return Row(children: stars);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text(
        'Product List',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
        backgroundColor: AppColors.primaryColor, 
      ),
      body: FutureBuilder<List<Product>>(
        future: ProductService.fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products available'));
          }

          final products = snapshot.data!;

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var product in products)
                  Card(
                    elevation: 3.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    margin: EdgeInsets.only(bottom: 16.0),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(12.0),
                      title: Text(
                        product.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.black,  
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              buildStarRating(product.rating), 
                              Container(
                                width: 100,
                                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
                                decoration: BoxDecoration(
                                  color: Colors.red, // Background color for the box
                                  borderRadius: BorderRadius.circular(8.0), // Optional: adds rounded corners
                                ),
                                child: Center(
                                  child: Text(
                                    formattedPrice(product.price), // Format the price as currency
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white, // White color for the price text
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center, // Ensure the text is centered
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16.0,
                        color: Colors.grey, 
                      ),
                      onTap: () {},
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
