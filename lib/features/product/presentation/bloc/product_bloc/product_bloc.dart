import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:sellphy/features/product/domain/entities/product.dart';

import 'package:sellphy/features/product/domain/usecases/get_favourite_products_id_usecase.dart';
import 'package:sellphy/features/product/domain/usecases/get_products_usecase.dart';
import 'package:sellphy/features/product/domain/usecases/toggle_favourite_usecase.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUsecase getProductsUsecase;
  final GetFavouriteProductsIdUsecase getFavouriteProductsIdUsecase;
  final ToggleFavouriteUsecase toggleFavouriteUsecase;

  List<ProductModel> _products = [];

  ProductBloc({
    required this.getProductsUsecase,
      required this.toggleFavouriteUsecase,
      required this.getFavouriteProductsIdUsecase
  }) : super(ProductInitial()) {
    on<GetProductEvent>(_onGetProducts);
    on<ToggleFavoriteEvent>(_toggleFavoriteEvent);
    on<LoadFavoriteProductsIdEvent>(_loadFavouriteProductIdEvent);
    on<ClearProductListEvent>(_clearProductList);

  }

 
  Future<void> _onGetProducts(GetProductEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    print("gettting products...........");
      if (_products.isNotEmpty) {
      print("not calledd at firsttttt");
      emit(ProductLoaded(_products));
      return;
    }

    final response = await getProductsUsecase.call();
    response.fold(
      (failure) {
        emit(ProductError(failure.message));
      },
      (products) {
        _products = products;
        add(LoadFavoriteProductsIdEvent());
      },
    );
  }


    Future<void> _loadFavouriteProductIdEvent(
      LoadFavoriteProductsIdEvent event, Emitter<ProductState> emit) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final favouriteIdsResponse =
        await getFavouriteProductsIdUsecase.call(userId);

    favouriteIdsResponse.fold((failure) {
      emit(ProductLoaded(_products));
    }, (favoriteIds) {
      for (var product in _products) {
        product.isFavorite = favoriteIds.contains(product.id);
      }

      emit(ProductLoaded(_products));
    });
  }

  Future<void> _toggleFavoriteEvent(
      ToggleFavoriteEvent event, Emitter<ProductState> emit) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final product = _products.firstWhere((p) => p.id == event.productId);

    final newIsFavorite = !product.isFavorite;

    final result = await toggleFavouriteUsecase.call(
        userId, event.productId, newIsFavorite);

    result.fold(
      (failure) {
        emit(ProductError(failure.message));
      },
      (_) {
        product.isFavorite = newIsFavorite;
        emit(ProductLoaded(_products));
      },
    );
  }


  Future<void> _clearProductList(ClearProductListEvent event, Emitter<ProductState> emit) async {
    _products = [];
    emit(ProductInitial());
  }

 


}
