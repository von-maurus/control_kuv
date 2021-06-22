import 'package:control_kuv/presentation/common/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:numberpicker/numberpicker.dart';

import 'item-product.dart';
import 'package:control_kuv/domain/models/product.dart';
import 'package:control_kuv/domain/repository/api_repository.dart';
import 'package:control_kuv/presentation/common/alert_dialog.dart';
import 'package:control_kuv/presentation/preventas/preventas_bloc.dart';
import 'package:control_kuv/presentation/productos/product_search_delegate.dart';
import 'package:control_kuv/presentation/productos/productos_bloc.dart';

class ProductosScreen extends StatelessWidget {
  ProductosScreen._();

  static Widget init(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductosBLoC(
          apiRepositoryInterface: context.read<ApiRepositoryInterface>())
        ..loadProducts(),
      builder: (_, __) => ProductosScreen._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productsBloc = context.watch<ProductosBLoC>();
    final preSaleBLoC = context.watch<PreSaleBLoC>();
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white70,
        appBar: buildAppBarProducts(context, productsBloc, preSaleBLoC),
        body: productsBloc.productList.isNotEmpty
            ? RefreshIndicator(
                color: Colors.white,
                backgroundColor: KuveColors.kuveMorado,
                onRefresh: () async {
                  await productsBloc.loadProducts();
                },
                child: GridView.builder(
                  itemCount: productsBloc.productList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).orientation ==
                            Orientation.landscape
                        ? size.width >= 600
                            ? 4
                            : 3
                        : size.width >= 600
                            ? 3
                            : 2,
                    childAspectRatio: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? size.width >= 600.0
                            ? 0.5 / MediaQuery.textScaleFactorOf(context)
                            : 0.6 / MediaQuery.textScaleFactorOf(context)
                        : 0.4 / MediaQuery.textScaleFactorOf(context),
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 20.0,
                  ),
                  physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  itemBuilder: (context, index) {
                    final product = productsBloc.productList[index];
                    return ItemProduct(
                      size: size,
                      product: product,
                      onTap: () async {
                        if (product.stock == 0) {
                          return showDialog(
                            context: context,
                            builder: (_) => AlertDialogPage(
                              oldContext: _,
                              title: Center(
                                child: Text(
                                  'Alerta',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25.0),
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
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25.0),
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
                                              shape: MaterialStateProperty.all(
                                                  StadiumBorder())),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            _showNumberPicker(context, product,
                                                productsBloc, preSaleBLoC);
                                          },
                                          child: Text(
                                            'Seguir...',
                                            style: TextStyle(fontSize: 17.0),
                                          ),
                                        ),
                                        TextButton(
                                          style: ButtonStyle(
                                              shape: MaterialStateProperty.all(
                                                  StadiumBorder())),
                                          onPressed: () async =>
                                              Navigator.of(context).pop(),
                                          child: Text(
                                            'Volver',
                                            style: TextStyle(fontSize: 17.0),
                                          ),
                                        ),
                                      ],
                                    ));
                          }
                        }
                        return await _showNumberPicker(
                            context, product, productsBloc, preSaleBLoC);
                      },
                    );
                  },
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black45,
                ),
              ),
      ),
    );
  }

  AppBar buildAppBarProducts(BuildContext context, ProductosBLoC productsBloc,
      PreSaleBLoC preSaleBLoC) {
    return AppBar(
      centerTitle: true,
      elevation: 6.0,
      backgroundColor: KuveColors.kuveMorado,
      toolbarHeight: 42.0,
      title: Text(
        'Productos',
        style: TextStyle(
          fontSize: 25.0,
          color: Theme.of(context).canvasColor,
        ),
      ),
      actions: [
        IconButton(
          color: Theme.of(context).canvasColor,
          splashColor: Colors.transparent,
          icon: Icon(
            Icons.search,
            size: 30,
          ),
          onPressed: () async {
            final product = await showSearch(
              context: context,
              delegate: ProductSearchDelegate('Buscar producto',
                  productosBLoC: productsBloc, preSaleBLoC: preSaleBLoC),
            );
            if (product != null) {
              //TODO: Guardar historial de busqueda en SharedPreferences localmente
              if (!productsBloc.historial
                  .any((element) => element.id == product.id)) {
                if (productsBloc.historial.length >= 10) {
                  productsBloc.historial.removeLast();
                  productsBloc.historial.insert(0, product);
                } else {
                  productsBloc.historial.insert(0, product);
                }
              }
            }
          },
        )
      ],
    );
  }

  Future _showNumberPicker(BuildContext context, Producto product,
      ProductosBLoC productsBLoC, PreSaleBLoC preSaleBLoC) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialogPage(
        oldContext: _,
        title: Center(
          child: Text('Seleccione la cantidad'),
        ),
        content: NumberPicker(
          itemCount: 4,
          minValue: 1,
          value: productsBLoC.cantidadProducto,
          haptics: true,
          maxValue: product.stock,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            border: Border.all(
              color: Colors.blue,
              width: 2,
            ),
          ),
          onChanged: (newValue) {
            productsBLoC.cantidadProducto = newValue;
          },
        ),
        actions: [
          TextButton(
            style:
                ButtonStyle(shape: MaterialStateProperty.all(StadiumBorder())),
            onPressed: () async {
              print('Cantidad:  ${productsBLoC.cantidadProducto}');
              preSaleBLoC.add(product, productsBLoC.cantidadProducto);
              productsBLoC.cantidadProducto = 1;
              Navigator.of(context).pop();
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
