// To parse this JSON data, do
//
//     final producto = productoFromJson(jsonString);
import 'dart:convert';

import 'package:control_kuv/data/api_repository_impl.dart';

import 'impuesto_producto.dart';

Producto productoFromJson(String str) => Producto.fromJson(json.decode(str));

String productoToJson(Producto data) => json.encode(data.toJson());

class Producto {
  Producto({
    this.id,
    required this.nombre,
    required this.codigo,
    this.descripcion = 'Sin descripción',
    required this.preciocompra,
    required this.precioventa,
    this.imagen,
    required this.stock,
    this.stockminimo,
    required this.impuestoProductos,
  });

  int? id;
  String nombre;
  String codigo;
  String descripcion;
  int preciocompra;
  int precioventa;
  String? imagen;
  int stock;
  int? stockminimo;
  List<ImpuestoProducto>? impuestoProductos;

  factory Producto.fromJson(Map<String, dynamic> json) => Producto(
        id: json['id'],
        codigo: json['codigo'],
        descripcion: json['descripcion'],
        imagen: json['imagen'] != null
            ? ApiRepositoryImpl.urlProductImage + json['imagen']
            : '',
        nombre: json['nombre'],
        preciocompra: json['preciocompra'],
        precioventa: json['precioventa'],
        stock: json['stock'],
        stockminimo: json['stockminimo'],
        impuestoProductos: List<ImpuestoProducto>.from(
            json['impuestoProductos'].map((x) => ImpuestoProducto.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'codigo': codigo,
        'descripcion': descripcion,
        'imagen': imagen,
        'nombre': nombre,
        'preciocompra': preciocompra,
        'precioventa': precioventa,
        'stock': stock,
        'stockminimo': stockminimo,
        'impuestoProductos':
            List<dynamic>.from(impuestoProductos!.map((x) => x.toJson())),
        'precioVentaFinal': precioVentaFinal
      };

  int get precioVentaFinal {
    var totalImpuestos;
    if (impuestoProductos != null || impuestoProductos!.isEmpty) {
      return precioventa;
    }
    impuestoProductos!.forEach((element) {
      totalImpuestos += element.impuestos.porcentaje;
    });
    return (precioventa + (precioventa * totalImpuestos) / 100).round();
  }

  @override
  String toString() {
    return 'Instancia de Producto: $nombre - \nImpuestos: $impuestoProductos - Stock: $stock';
  }
}
