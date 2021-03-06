import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:control_kuv/domain/models/product.dart';
import 'package:control_kuv/domain/repository/api_repository.dart';
import 'package:control_kuv/presentation/common/alert_dialog.dart';
import 'package:control_kuv/presentation/common/theme.dart';
import 'package:control_kuv/presentation/common/custom_number_input.dart';
import 'package:control_kuv/presentation/preventas/preventas_bloc.dart';
import 'package:control_kuv/presentation/productos/product_search_delegate.dart';
import 'package:control_kuv/presentation/productos/productos_bloc.dart';
import 'item-product.dart';

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
                        : 0.45 / MediaQuery.textScaleFactorOf(context),
                    crossAxisSpacing: 30.0,
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
                        return await _addProduct(
                            product, context, productsBloc, preSaleBLoC);
                      },
                    );
                  },
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                    backgroundColor: KuveColors.kuveMorado),
              ),
      ),
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
              'El producto se encuentra con Stock M??nimo. Por favor, notifique a su administrador',
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

  AppBar buildAppBarProducts(BuildContext context, ProductosBLoC productsBloc,
      PreSaleBLoC preSaleBLoC) {
    return AppBar(
      toolbarHeight: 42.0,
      title: Text('Productos'),
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
              delegate: ProductSearchDelegate(
                  'Nombre y C??digo', TextStyle(fontSize: 14.0),
                  productosBLoC: productsBloc, preSaleBLoC: preSaleBLoC),
            );
            if (product!.id != 0) {
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
            hint: 'Ingrese cantidad',
            label: 'Cantidad',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width >= 600.0
                  ? MediaQuery.of(context).size.width * 0.025
                  : 15.0,
              color: KuveColors.kuveMorado,
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
