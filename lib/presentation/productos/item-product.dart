import 'package:control_kuv/domain/models/product.dart';
import 'package:control_kuv/presentation/common/kuve_button.dart';
import 'package:control_kuv/presentation/common/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class ItemProduct extends StatelessWidget {
  ItemProduct({required this.product, required this.onTap, required this.size});

  final Producto product;
  final Function() onTap;
  final formatter =
      NumberFormat.currency(locale: 'es', decimalDigits: 0, symbol: '');
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(
        right: MediaQuery.of(context).orientation == Orientation.portrait
            ? MediaQuery.of(context).size.width * 0.01
            : MediaQuery.of(context).size.width * 0.0001,
        left: MediaQuery.of(context).orientation == Orientation.portrait
            ? MediaQuery.of(context).size.width * 0.01
            : MediaQuery.of(context).size.width * 0.0001,
        top: 25,
      ),
      elevation: 10.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      color: Theme.of(context).canvasColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            buildProductInfo(context, size),
            buildStockViewer(context),
          ],
        ),
      ),
    );
  }

  Widget buildProductInfo(BuildContext context, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 3,
          child: product.imagen.isEmpty
              ? Container(
                  padding: EdgeInsets.all(size.width >= 750.0 ? 10.0 : 20.0),
                  child: SvgPicture.asset(
                    'assets/icons/product-cart.svg',
                    color: Colors.blue,
                  ),
                )
              : Container(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Image.network(
                      product.imagen,
                      fit: BoxFit.fitHeight,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            color: KuveColors.kuveVerde,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                product.nombre,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: TextStyle(
                  color: KuveColors.kuveMorado,
                  fontSize:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? size.width >= 600
                              ? 19.5
                              : 13.0
                          : size.width >= 750
                              ? 18.0
                              : 14.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                product.descripcion,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: KuveColors.darkGrey,
                    fontSize: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? size.width >= 600
                            ? 16.5
                            : 10.5
                        : size.width >= 750
                            ? 19.0
                            : 12.5),
              ),
              Text(
                '\$${formatter.format(product.precioVentaFinal)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: KuveColors.purple,
                  fontSize:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? size.width >= 600
                              ? 26.5
                              : 18.0
                          : size.width >= 750
                              ? 26.0
                              : 19.0,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          child: KuveButton(
            onTap: onTap,
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            text: 'A??adir',
            fontSize: MediaQuery.of(context).orientation == Orientation.portrait
                ? 16.0
                : 20.0,
          ),
        )
      ],
    );
  }

  Widget buildStockViewer(BuildContext context) {
    return Positioned(
      right: 0,
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: product.stockminimo != null &&
                  product.stock < product.stockminimo!
              ? Colors.red
              : Colors.green,
          borderRadius: BorderRadius.circular(60),
        ),
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.width * 0.088
              : MediaQuery.of(context).size.width * 0.045,
          minHeight: MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.width * 0.088
              : MediaQuery.of(context).size.width * 0.045,
        ),
        child: Center(
          child: Text(
            product.stock.toString(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize:
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? MediaQuery.of(context).size.width * 0.04
                      : MediaQuery.of(context).size.width * 0.024,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
