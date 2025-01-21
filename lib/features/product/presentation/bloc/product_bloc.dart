import 'package:bloc/bloc.dart';
import 'package:sellphy/features/product/domain/entities/product.dart';
import 'package:sellphy/features/product/domain/usecases/get_products_usecase.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUsecase getProductsUsecase;
  ProductBloc({required this.getProductsUsecase}) : super(ProductInitial()) {
    on<GetProductEvent>(_onGetProducts);
  }

  List<ProductModel> _products = [];
  Future<void> _onGetProducts(GetProductEvent event, Emitter<ProductState> emit)
  async {
    emit(ProductLoading());
    final response = await getProductsUsecase.call();
    response.fold(
      (failure){
        emit(ProductError(failure.message));
      }, 
      (products){
        _products = products;
        emit(ProductLoaded(products));
      });

  }
}
