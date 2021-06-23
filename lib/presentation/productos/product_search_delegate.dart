import 'dart:ui';
import 'dart:io';
import 'package:control_kuv/presentation/common/custom_number_input.dart';
import 'package:control_kuv/presentation/common/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:control_kuv/domain/models/product.dart';
import 'package:control_kuv/presentation/common/alert_dialog.dart';
import 'package:control_kuv/presentation/preventas/preventas_bloc.dart';
import 'package:control_kuv/presentation/productos/productos_bloc.dart';
import 'package:intl/intl.dart';

class ProductSearchDelegate extends SearchDelegate<Producto> {
  final ProductosBLoC productosBLoC;
  final PreSaleBLoC preSaleBLoC;

  @override
  final String searchFieldLabel;
  @override
  final TextStyle? searchFieldStyle;

  ProductSearchDelegate(this.searchFieldLabel, this.searchFieldStyle,
      {required this.productosBLoC, required this.preSaleBLoC});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        splashColor: Colors.transparent,
        onPressed: () => query = '',
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
      splashColor: Colors.transparent,
      onPressed: () async {
        FocusScope.of(context).unfocus();
        await Future.delayed(Duration(milliseconds: 200));
        close(
          context,
          Producto(
              id: 0,
              nombre: '',
              codigo: '',
              preciocompra: 0,
              precioventa: 0,
              stock: 0,
              impuestoProductos: []),
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.trim().isEmpty) {
      return Center(
          child: Text(
        'Ingrese un producto',
        style: TextStyle(
          fontSize: 20.0,
          color: KuveColors.kuveMorado,
          fontWeight: FontWeight.w500,
        ),
      ));
    }
    return FutureBuilder(
      future: productosBLoC.getProductsByNameCode(query),
      builder: (_, AsyncSnapshot snapshot) {
        return snapshot.connectionState == ConnectionState.done
            ? productosBLoC.productsByName.isEmpty
                ? Center(
                    child: Text(
                      'Producto no encontrado',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                        color: KuveColors.kuveMorado,
                      ),
                    ),
                  )
                : _showProducts(productosBLoC.productsByName)
            : Center(child: CircularProgressIndicator(strokeWidth: 8.0));
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _showProducts(productosBLoC.historial);
  }

  Widget _showProducts(List<Producto> productos) {
    var format =
        NumberFormat.currency(decimalDigits: 0, locale: 'es_CL', name: '');
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: productos.length,
      itemBuilder: (context, index) {
        final product = productos[index];
        return ListTile(
          leading: product.imagen.isNotEmpty
              ? Image(
                  width: 35.0,
                  image: NetworkImage(product.imagen),
                )
              : ClipOval(
                  child: SvgPicture.asset(
                    'assets/icons/product-cart.svg',
                    height: 35.0,
                    width: 25.0,
                    color: KuveColors.kuveMorado,
                  ),
                ),
          title: Text(
            product.nombre,
            maxLines: 1,
            style: TextStyle(fontSize: 16.5, color: KuveColors.kuveMorado),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            'Código: ' + product.codigo,
            maxLines: 1,
            style: TextStyle(
              fontSize: 13.5,
              color: KuveColors.kuveMorado,
              letterSpacing: 1.0,
            ),
          ),
          trailing: Text(
            '\$' + format.format(product.precioventa),
            style: TextStyle(
              fontSize: 18.5,
              color: KuveColors.kuveMorado,
            ),
          ),
          onTap: () async =>
              _addProduct(product, context, productosBLoC, preSaleBLoC),
        );
      },
    );
  }

  Future<dynamic> _addProduct(Producto product, BuildContext context,
      ProductosBLoC productsBloc, PreSaleBLoC preSaleBLoC) async {
    if (product.stock == 0) {
      return showDialog(
        context: context,
        builder: (_) => AlertDialogPage(
          oldContext: _,
          title: Center(
            child: Text(
              'Alerta',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
            ),
          ),
          content: Text(
            'El producto se encuentra SIN STOCK. Por favor, notifique a su administrador.',
            style: TextStyle(fontSize: 18.5),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Aceptar',
                style: TextStyle(fontSize: 17.0),
              ),
            ),
          ],
        ),
      );
    }
    if (product.stockminimo != null) {
      if (product.stock <= product.stockminimo!) {
        return showDialog(
          context: context,
          builder: (_) => AlertDialogPage(
            oldContext: _,
            title: Center(
              child: Text(
                'Advertencia',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
              ),
            ),
            content: Text(
              'El producto se encuentra con Stock Mínimo. Por favor, notifique a su administrador',
              style: TextStyle(fontSize: 18.5),
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(StadiumBorder())),
                onPressed: () {
                  Navigator.of(context).pop();
                  _showNumberPicker(
                      context, product, productsBloc, preSaleBLoC);
                },
                child: Text(
                  'Seguir...',
                  style: TextStyle(fontSize: 17.0),
                ),
              ),
              TextButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(StadiumBorder())),
                onPressed: () async => Navigator.of(context).pop(),
                child: Text(
                  'Volver',
                  style: TextStyle(fontSize: 17.0),
                ),
              ),
            ],
          ),
        );
      }
    }
    return await _showNumberPicker(context, product, productsBloc, preSaleBLoC);
  }

  Future _showNumberPicker(BuildContext context, Producto product,
      ProductosBLoC productsBLoC, PreSaleBLoC preSaleBLoC) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialogPage(
        oldContext: _,
        content: Form(
          key: productsBLoC.formKey,
          child: CustomNumberInput(
            minValue: 1,
            maxValue: product.stock,
            bloc: productsBLoC,
            focusNode: productsBLoC.editCantidadFocusNode,
            textEditingController: productsBLoC.editCantidadController,
            onChangeInputCantidad: null,
            textInputAction: TextInputAction.done,
            hint: 'Ingrese Cantidad',
            label: 'Cantidad',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width >= 600.0
                  ? MediaQuery.of(context).size.width * 0.025
                  : 15.0,
            ),
            labelTextStyle: TextStyle(
              fontSize: MediaQuery.of(context).size.width >= 600.0
                  ? MediaQuery.of(context).size.width * 0.025
                  : 15.0,
            ),
          ),
        ),
        actions: [
          TextButton(
            style:
                ButtonStyle(shape: MaterialStateProperty.all(StadiumBorder())),
            onPressed: () async {
              print('Cantidad:  ${productsBLoC.cantidadProducto}');
              print(
                  'Validado: ${productsBLoC.formKey.currentState!.validate()}');
              if (productsBLoC.formKey.currentState!.validate()) {
                preSaleBLoC.add(
                    product,
                    int.parse(productsBLoC.editCantidadController.text
                        .replaceAll(',', '')));
                productsBLoC.editCantidadController.text = '1';
                Navigator.of(context).pop();
              }
              productsBLoC.editCantidadFocusNode.unfocus();
            },
            child: Text(
              'Agregar',
              style: TextStyle(fontSize: 17.0),
            ),
          ),
          TextButton(
            style:
                ButtonStyle(shape: MaterialStateProperty.all(StadiumBorder())),
            onPressed: () {
              productsBLoC.cantidadProducto = 1;
              productsBLoC.editCantidadController.text = 1.toString();
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancelar',
              style: TextStyle(fontSize: 17.0),
            ),
          ),
        ],
      ),
    );
  }
}
