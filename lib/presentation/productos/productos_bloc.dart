import 'package:flutter/material.dart';
import 'package:control_kuv/domain/exceptions/product_exception.dart';
import 'package:control_kuv/domain/models/product.dart';
import 'package:control_kuv/domain/repository/api_repository.dart';
import 'package:control_kuv/domain/repository/local_storage_repository.dart';

enum ProductsState {
  loading,
  initial,
}

class ProductosBLoC extends ChangeNotifier {
  final ApiRepositoryInterface apiRepositoryInterface;
  final LocalRepositoryInterface? localRepositoryInterface;

  ProductosBLoC(
      {required this.apiRepositoryInterface, this.localRepositoryInterface});

  List<Producto> productList = <Producto>[];
  List<Producto> productsByName = <Producto>[];
  List<Producto> historial = [];
  var productsState = ProductsState.initial;
  int cantidadProducto = 1;
  final editCantidadController = TextEditingController(text: '1');
  final FocusNode editCantidadFocusNode = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> loadProducts() async {
    try {
      productsState = ProductsState.loading;
      notifyListeners();
      final result = await apiRepositoryInterface.getProducts();
      productList = result;
      print('Cantidad Productos: ${productList.length}');
      productsState = ProductsState.initial;
      notifyListeners();
    } on ProductException catch (_) {
      print(_);
      productsState = ProductsState.initial;
      notifyListeners();
    }
  }

  Future<void> getProductsByNameCode(String name) async {
    try {
      final result = await apiRepositoryInterface.getProductByName(name);
      productsByName = result;
    } on ProductException catch (e) {
      print(e);
    }
  }

  void updateNumberSelector(int cantidad) {
    cantidadProducto = cantidad;
    notifyListeners();
  }
}
