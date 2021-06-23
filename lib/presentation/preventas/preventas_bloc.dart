import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:control_kuv/domain/exceptions/preventa_exception.dart';
import 'package:control_kuv/domain/models/cliente.dart';
import 'package:control_kuv/domain/models/preventa_cart.dart';
import 'package:control_kuv/domain/models/product.dart';
import 'package:control_kuv/domain/repository/api_repository.dart';
import 'package:control_kuv/domain/repository/local_storage_repository.dart';

enum PreSaleState {
  loading,
  stable,
}

class PreSaleBLoC extends ChangeNotifier {
  final ApiRepositoryInterface apiRepositoryInterface;
  final LocalRepositoryInterface localRepositoryInterface;

  int payType = 0;
  List<PreSaleCart> preSaleList = <PreSaleCart>[];
  int totalItems = 0;
  int totalPrice = 0;
  int productsCount = 0;
  var preSaleState = PreSaleState.stable;
  int diasCuota = 0;
  MaskTextInputFormatter maskTextInputFormatter =
      MaskTextInputFormatter(mask: '##.###.###-#');
  bool isStockError = false;
  bool isAnyError = false;
  Cliente client =
      Cliente(id: 0, nombre: '', rut: '', correo: '', estado: 0, tipo: 0);

  PreSaleBLoC({required this.apiRepositoryInterface, required this.localRepositoryInterface});

  int get numDias {
    switch (diasCuota) {
      case 1:
        return 7;
      case 2:
        return 15;
      case 3:
        return 30;
      default:
        return 7;
    }
  }

  void changePayType(int clientPayType, int dayOptions) {
    if (clientPayType != 1) {
      payType = clientPayType;
      diasCuota = dayOptions;
      notifyListeners();
    } else {
      payType = clientPayType;
      diasCuota = dayOptions;
      notifyListeners();
    }
  }

  void cleanSalesCart() {
    preSaleList.clear();
    calculateTotals(preSaleList);
    // client = new Cliente();
    totalItems = 0;
    totalPrice = 0;
    productsCount = 0;
    // diasCuota = 0;
    // payType = null;
    notifyListeners();
  }

  void add(Producto product, int quantity) {
    final tempList = List<PreSaleCart>.from(preSaleList);
    var found = false;
    PreSaleCart p;
    for (p in tempList) {
      if (p.product.id == product.id) {
        p.quantity = quantity;
        p.precioLinea = quantity * p.product.precioVentaFinal;
        found = true;
        break;
      }
    }
    if (!found) {
      productsCount = productsCount + 1;
      notifyListeners();
      tempList.add(PreSaleCart(
        product: product,
        quantity: quantity,
        precioLinea: product.precioVentaFinal * quantity,
      ));
    }
    preSaleList = List<PreSaleCart>.from(tempList);
    calculateTotals(tempList);
  }

  Future<bool> addClient(Cliente newClient) async {
    //Añadir un nuevo cliente
    if (client.id == 0) {
      return false;
    } else {
      client = newClient;
      payType = newClient.tipopago;
      if (newClient.numerocuotas == null) {
        diasCuota = 1;
      } else {
        diasCuota = newClient.numerocuotas!;
      }
      client.rut = maskTextInputFormatter.maskText(client.rut);
      notifyListeners();
      return true;
    }
  }

  void updateClient(Cliente newClient) {
    client = newClient;
    payType = newClient.tipopago;
    if (newClient.numerocuotas == null) {
      diasCuota = 1;
    } else {
      diasCuota = newClient.numerocuotas!;
    }
    client.rut = maskTextInputFormatter.maskText(client.rut);
    notifyListeners();
  }

  void increment(PreSaleCart productCart) {
    if (productCart.quantity < productCart.product.stock) {
      productCart.quantity += 1;
      productCart.precioLinea += productCart.product.precioVentaFinal;
      notifyListeners();
      preSaleList = List<PreSaleCart>.from(preSaleList);
      calculateTotals(preSaleList);
    }
  }

  void decrement(PreSaleCart productCart) {
    if (productCart.quantity > 1) {
      productCart.quantity -= 1;
      productCart.precioLinea -= productCart.product.precioVentaFinal;
      preSaleList = List<PreSaleCart>.from(preSaleList);
      calculateTotals(preSaleList);
    }
  }

  void calculateTotals(List<PreSaleCart> temp) {
    final total = temp.fold(
        0,
        (previousValue, element) =>
            element.quantity + int.parse(previousValue.toString()));
    totalItems = total;
    final totalCost = temp.fold(
        0,
        (previousValue, element) =>
            (element.quantity * element.product.precioVentaFinal) +
            int.parse(previousValue.toString()));
    totalPrice = totalCost;
    notifyListeners();
  }

  void deleteProduct(PreSaleCart productCart) {
    productsCount -= 1;
    notifyListeners();
    preSaleList.remove(productCart);
    calculateTotals(preSaleList);
  }

  Future<dynamic> checkOut() async {
    isAnyError = false;
    isStockError = false;
    preSaleState = PreSaleState.loading;
    notifyListeners();
    if (client.id == null) {
      preSaleState = PreSaleState.stable;
      notifyListeners();
      return 'Por favor, ingrese un cliente a su venta.';
    }
    try {
      //API request
      final token = await localRepositoryInterface.getToken();
      final response = await apiRepositoryInterface.createPreSale(
          preSaleList, client.id!, payType, totalPrice, token, diasCuota);
      preSaleState = PreSaleState.stable;
      notifyListeners();
      return response;
    } on PreSaleException catch (e) {
      isStockError = true;
      print(e.getMessage());
      preSaleState = PreSaleState.stable;
      notifyListeners();
      return 'Ocurrio un error: \n${e.getMessage()}';
    } on TimeoutException catch (e) {
      isAnyError = true;
      print(e);
      preSaleState = PreSaleState.stable;
      notifyListeners();
      return 'Conexión perdida, por favor vuelva a intentarlo.';
    } on Exception catch (e) {
      isAnyError = true;
      print(e);
      preSaleState = PreSaleState.stable;
      notifyListeners();
      return 'Ocurrio un error inesperado: $e';
    }
  }
}
