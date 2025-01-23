part of 'product_bloc.dart';

abstract class ProductEvent {}

class GetProductEvent extends ProductEvent {}
class ToggleFavoriteEvent extends ProductEvent {
  final int productId;

  ToggleFavoriteEvent(this.productId);
}

class LoadFavoriteProductsIdEvent extends ProductEvent {}

class ClearProductListEvent extends ProductEvent{}


class FavoriteProductsLoaded extends ProductState {
  final List<int> favoriteProductIds;

  FavoriteProductsLoaded(this.favoriteProductIds);
}