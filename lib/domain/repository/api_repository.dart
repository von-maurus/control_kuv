import 'package:control_kuv/domain/models/cliente.dart';
import 'package:control_kuv/domain/models/preventa_cart.dart';
import 'package:control_kuv/domain/models/product.dart';
import 'package:control_kuv/domain/models/user.dart';
import 'package:control_kuv/domain/requests/login_request.dart';
import 'package:control_kuv/domain/responses/login_response.dart';

abstract class ApiRepositoryInterface {
  Future<Usuario> getUserFromToken(String token);

  Future<LoginResponse> login(LoginRequest login);

  Future<List<Producto>> getProducts();

  Future<List<Producto>> getProductByName(String query);

  Future<List<Cliente>> getClientes();

  Future<List<Cliente>> getClientByNameRunEmail(String query);

  Future<Cliente> createCliente(Cliente cliente);

  Future<dynamic> createPreSale(List<PreSaleCart> preSaleList, int clientId,
      int payType, int total, String? token, int diasCuota);
}
