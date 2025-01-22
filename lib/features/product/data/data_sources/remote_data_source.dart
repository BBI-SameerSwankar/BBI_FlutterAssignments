import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:sellphy/features/product/domain/entities/cart.dart';
import 'package:sellphy/features/product/domain/entities/product.dart';

abstract class RemoteDataSource {
  Future<List<ProductModel>> fetchProducts();
  Future<void> addItemToCart(String userId, Cart cartItem);
  Future<void> removeItemFromCart(String userId, Cart cartItem);
  Future<List<Cart>> getCartItems(String userId);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final http.Client client;
  final FirebaseFirestore _firestore;

  RemoteDataSourceImpl(this.client, this._firestore);

  @override
  Future<List<ProductModel>> fetchProducts() async {
    const String apiUrl = "https://dummyjson.com/products";

    final response = await client.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseMap = json.decode(response.body);
      final List<dynamic> data = responseMap["products"];
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch products. Status Code: ${response.statusCode}');
    }
  }

  @override
  Future<void> addItemToCart(String userId, Cart cartItem) async {
    final productId = cartItem.productId.toString(); // Convert productId to string for Firestore
    final quantity = cartItem.quantity;
    print("receiveed quant");
    print(quantity);
    final productRef = _firestore.collection('carts').doc(userId).collection('products').doc(productId);

    final productSnapshot = await productRef.get();

    if (productSnapshot.exists) {
      // If the product already exists, increment its quantity
      await productRef.update({
        'quantity': quantity,
      });
    } else {
      // If the product doesn't exist, create it with the initial quantity
      await productRef.set({
        'productId': cartItem.productId,
        'quantity': quantity,
      });
    }
  }

  @override
  Future<void> removeItemFromCart(String userId, Cart cartItem) async {
    final productId = cartItem.productId.toString(); // Convert productId to string for Firestore
    final quantity = cartItem.quantity;
    final productRef = _firestore.collection('carts').doc(userId).collection('products').doc(productId);

    final productSnapshot = await productRef.get();

    if (productSnapshot.exists) {
      final currentQuantity = productSnapshot.data()?['quantity'] as int;

      if (currentQuantity > quantity) {
        // Decrease the quantity
        await productRef.update({
          'quantity': FieldValue.increment(-quantity),
        });
      } else {
        // If quantity to remove is greater or equal, delete the product
        await productRef.delete();
      }
    }
  }

  @override
  Future<List<Cart>> getCartItems(String userId) async {
    final productsRef = _firestore.collection('carts').doc(userId).collection('products');
    final productsSnapshot = await productsRef.get();

    if (productsSnapshot.docs.isEmpty) {
      return [];
    }

    // Convert Firestore documents to Cart objects
    return productsSnapshot.docs.map((doc) {
      final data = doc.data();
      return Cart(
        productId: data['productId'] as int,
        quantity: data['quantity'] as int,
      );
    }).toList();
  }
}
