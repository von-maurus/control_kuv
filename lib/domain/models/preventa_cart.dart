import 'package:control_kuv/domain/models/product.dart';

class PreSaleCart {
  final Producto product;
  int quantity = 1;
  int precioLinea = 0;

  PreSaleCart({
    required this.product,
    this.quantity = 1,
    required this.precioLinea,
  });

  @override
  String toString() {
    return 'Instancia de PreSaleCart: ${product.nombre + '-' + precioLinea.toString()}';
  }

  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'quantity': quantity,
        'precioLinea': precioLinea
      };
}
