import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sellphy/features/product/domain/entities/cart.dart';
import 'package:sellphy/features/product/domain/entities/product.dart';
import 'package:sellphy/features/product/domain/usecases/add_item_to_cart.dart';
import 'package:sellphy/features/product/domain/usecases/get_cart_items.dart';
import 'package:sellphy/features/product/domain/usecases/get_products_usecase.dart';
import 'package:sellphy/features/product/domain/usecases/remove_item_from_cart.dart';
import 'package:sellphy/features/product/presentation/cart_bloc/cart_event.dart';
import 'package:sellphy/features/product/presentation/cart_bloc/cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetProductsUsecase getProductsUsecase;
  final AddItemToCart addItemToCart;
  final GetCartItems getCartItems;
  final RemoveItemFromCart removeItemFromCart;

  Map<int, ProductModel> _productMap = {};
  List<Cart> _cartItems = [];

  CartBloc({
    required this.getProductsUsecase,
    required this.addItemToCart,
    required this.getCartItems,
    required this.removeItemFromCart,
  }) : super(CartInitial()) {
    on<GetProductEventForCart>(_onGetProducts);
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<GetCartEvent>(_onGetCartItems);
  }

  // Fetch products and store them in a map
  Future<void> _onGetProducts(GetProductEventForCart event, Emitter<CartState> emit) async {

    final response = await getProductsUsecase.call();
    response.fold(
      (failure) {
        emit(CartError(failure.message));
      },
      (products) {
        _productMap = {for (var product in products) product.id: product};
        print("product map.....");
        print(_productMap);
      },
    );
  }

  // Add item to cart
  Future<void> _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) async {
    print("is this adding");
    final userId = FirebaseAuth.instance.currentUser!.uid;
    try {
      if (_productMap.containsKey(event.productId)) {
        final product = _productMap[event.productId]!;
        final cartItem = Cart(productId: product.id, quantity: event.quantity);
        print("added cart item in bloc ${cartItem.quantity}");
        await addItemToCart(userId, cartItem);

        add(GetCartEvent()); // Reload cart after adding item
      } else {
        emit(CartError('Product not found.'));
      }
    } catch (e) {
      emit(CartError('Failed to add item to cart: $e'));
    }
  }

  // Remove item from cart
  Future<void> _onRemoveFromCart(RemoveFromCartEvent event, Emitter<CartState> emit) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    try {
      final cartItem = Cart(productId: event.productId, quantity: event.quantity);
      await removeItemFromCart(userId, cartItem);

      add(GetCartEvent()); // Reload cart after removing item
    } catch (e) {
      emit(CartError('Failed to remove item from cart: $e'));
    }
  }

  // Fetch cart items and populate product details
  Future<void> _onGetCartItems(GetCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoading());
    final userId = FirebaseAuth.instance.currentUser!.uid;
    try {
      final cartItems = await getCartItems.call(userId);

      // Populate product details in cart items
      final populatedCartItems = cartItems.map((cartItem) {
        final productId = cartItem.productId;
        return cartItem.copyWith(product: _productMap[productId]);
      }).toList();

      _cartItems = populatedCartItems;
      emit(CartLoaded(populatedCartItems));
    } catch (e) {
      emit(CartError('Failed to fetch cart items: $e'));
    }
  }
}
