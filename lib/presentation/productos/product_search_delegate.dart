import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:control_kuv/domain/models/product.dart';
import 'package:control_kuv/presentation/common/alert_dialog.dart';
import 'package:control_kuv/presentation/preventas/preventas_bloc.dart';
import 'package:control_kuv/presentation/productos/productos_bloc.dart';

class ProductSearchDelegate extends SearchDelegate<Producto> {
  final ProductosBLoC productosBLoC;
  final PreSaleBLoC preSaleBLoC;

  @override
  final String searchFieldLabel;

  ProductSearchDelegate(this.searchFieldLabel,
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
        await Future.delayed(Duration(milliseconds: 100));
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
          fontWeight: FontWeight.w500,
        ),
      ));
    }
    return FutureBuilder(
        future: productosBLoC.getProductsByNameCode(query),
        builder: (_, AsyncSnapshot snapshot) {
          if (productosBLoC.productsByName.isNotEmpty) {
            // Crear lista
            return _showProducts(productosBLoC.productsByName);
          } else if (snapshot.connectionState == ConnectionState.done &&
              productosBLoC.productsByName.isEmpty) {
            return Center(
              child: Text(
                'No se encontró el producto',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 8,
              ),
            );
          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _showProducts(productosBLoC.historial);
  }

  Widget _showProducts(List<Producto> productos) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: productos.length,
      itemBuilder: (context, index) {
        final product = productos[index];
        return ListTile(
          leading: product.imagen != null
              ? Image(
                  width: 45,
                  image: NetworkImage(product.imagen!),
                )
              : ClipOval(
                  child: SvgPicture.asset(
                    'assets/icons/product-cart.svg',
                    height: 45,
                    width: 45,
                    color: Colors.blue,
                  ),
                ),
          title: Text(
            product.nombre,
            maxLines: 1,
            style: TextStyle(fontSize: 16.5),
          ),
          subtitle: Text(
            'Código: ' + product.codigo,
            maxLines: 1,
            style: TextStyle(fontSize: 13.5),
          ),
          trailing: Text(
            '\$' + product.precioventa.toString(),
            style: TextStyle(fontSize: 18.5),
          ),
          onTap: () async {
            if (product.stock != 0) {
              if (product.stock <= product.stockminimo!) {
                return showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => AlertDialogPage(
                    oldContext: _,
                    title: Center(
                        child: Text(
                      'Advertencia',
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.bold),
                    )),
                    content: Text(
                      'El producto se encuentra con Stock Mínimo. Por favor, notifique a su administrador',
                      textAlign: TextAlign.center,
                    ),
                    actions: [
                      TextButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(StadiumBorder())),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await showSearchDialog(context, product);
                        },
                        child: Text(
                          'Seguir...',
                          style: TextStyle(fontSize: 17.0),
                        ),
                      ),
                      TextButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(StadiumBorder())),
                        onPressed: () {
                          Navigator.of(context).pop();
                          close(context, product);
                        },
                        child: Text(
                          'Cancelar',
                          style: TextStyle(fontSize: 17.0),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                await showSearchDialog(context, product);
              }
            } else {
              return showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => AlertDialogPage(
                  oldContext: _,
                  title: Center(
                      child: Text(
                    'Alerta',
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                  )),
                  content: Text(
                    'El producto se encuentra SIN STOCK. Por favor, notifique a su administrador',
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    TextButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(StadiumBorder())),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        close(context, product);
                      },
                      child: Text(
                        'Volver',
                        style: TextStyle(fontSize: 17.0),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        );
      },
    );
  }

  Future showSearchDialog(BuildContext context, Producto product) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialogPage(
        oldContext: _,
        title: Text('Cantidad'),
        content: NumberPicker(
          step: 1,
          minValue: 1,
          haptics: true,
          maxValue: product.stock,
          value: productosBLoC.cantidadProducto,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            border: Border.all(
              color: Colors.blue,
              width: 2,
            ),
          ),
          onChanged: (newValue) {
            productosBLoC.cantidadProducto = int.parse(newValue.toString());
          },
        ),
        actions: [
          TextButton(
            style:
                ButtonStyle(shape: MaterialStateProperty.all(StadiumBorder())),
            onPressed: () async {
              preSaleBLoC.add(product, productosBLoC.cantidadProducto);
              productosBLoC.cantidadProducto = 1;
              Navigator.of(context).pop();
              close(context, product);
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
              Navigator.of(context).pop();
              close(context, product);
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
