import 'package:control_kuv/domain/models/user.dart';

class LoginResponse {
  const LoginResponse(this.token, this.usuario);

  final String token;
  final Usuario usuario;
}
