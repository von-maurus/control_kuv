import 'package:shared_preferences/shared_preferences.dart';
import 'package:control_kuv/domain/models/user.dart';
import 'package:control_kuv/domain/repository/local_storage_repository.dart';

const _prefToken = 'TOKEN';
const _prefId = 'ID';
const _prefNombre = 'NOMBRE';
const _prefUsername = 'USERNAME';
const _prefTipo = 'TIPO';
const _prefFono = 'FONO';
const _prefComision = 'COMISION';
const _prefImage = 'IMAGE';
const _prefEmail = 'CORREO';
const _prefEstado = 'ESTADO';
const _prefTheme = 'THEME';

class LocalRepositoryImpl extends LocalRepositoryInterface {
  @override
  Future<void> clearData() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
  }

  @override
  Future<String?> getToken() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(_prefToken);
  }

  @override
  Future<String> saveToken(String token) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_prefToken, token);
    return token;
  }

  @override
  Future<Usuario> getUser() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    final id = sharedPreferences.getInt(_prefId);
    final nombre = sharedPreferences.getString(_prefNombre);
    final username = sharedPreferences.getString(_prefUsername);
    final tipo = sharedPreferences.getInt(_prefTipo);
    final fono = sharedPreferences.getString(_prefFono);
    final comision = sharedPreferences.getInt(_prefComision);
    var imagen = sharedPreferences.getString(_prefImage);
    if (imagen != null) {
      imagen = sharedPreferences.getString(_prefImage);
    } else {
      imagen = null;
    }
    print('Imagen: ${imagen.toString()}');
    final correo = sharedPreferences.getString(_prefEmail);
    final estado = sharedPreferences.getInt(_prefEstado);
    final usuario = Usuario(
      id: id,
      nombre: nombre!,
      username: username!,
      tipo: tipo!,
      fono: fono!,
      comision: comision!,
      imagen: imagen!,
      correo: correo!,
      estado: estado!,
    );
    print('USER!!! $usuario');
    return usuario;
  }

  @override
  Future<Usuario> saveUser(Usuario usuario) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setInt(_prefId, usuario.id!);
    await sharedPreferences.setString(_prefNombre, usuario.nombre);
    await sharedPreferences.setString(_prefUsername, usuario.username);
    await sharedPreferences.setInt(_prefTipo, usuario.tipo);
    await sharedPreferences.setString(_prefFono, usuario.fono!);
    await sharedPreferences.setInt(_prefComision, usuario.comision!);
    await sharedPreferences.setString(_prefImage, usuario.imagen);
    await sharedPreferences.setString(_prefEmail, usuario.correo);
    await sharedPreferences.setInt(_prefEstado, usuario.estado);
    return usuario;
  }

  @override
  Future<bool?> getTheme() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(_prefTheme);
  }

  @override
  Future<bool> saveTheme(bool theme) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setBool(_prefTheme, theme);
  }
}
