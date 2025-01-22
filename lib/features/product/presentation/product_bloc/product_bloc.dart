import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sellphy/features/product/domain/entities/cart.dart';
import 'package:sellphy/features/product/domain/entities/product.dart';
import 'package:sellphy/features/product/domain/usecases/add_item_to_cart.dart';
import 'package:sellphy/features/product/domain/usecases/get_cart_items.dart';
import 'package:sellphy/features/product/domain/usecases/get_products_usecase.dart';
import 'package:sellphy/features/product/domain/usecases/remove_item_from_cart.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUsecase getProductsUsecase;
  

  List<ProductModel> _products = [];

  ProductBloc({
    required this.getProductsUsecase,
    
  }) : super(ProductInitial()) {
    on<GetProductEvent>(_onGetProducts);

  }

  // Fetch products
  Future<void> _onGetProducts(GetProductEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final response = await getProductsUsecase.call();
    response.fold(
      (failure) {
        emit(ProductError(failure.message));
      },
      (products) {
        _products = products;
        emit(ProductLoaded(products));
      },
    );
  }

 


}
