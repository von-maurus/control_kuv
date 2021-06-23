import 'package:control_kuv/domain/exceptions/client_exception.dart';
import 'package:control_kuv/domain/models/cliente.dart';
import 'package:control_kuv/domain/models/validation_item.dart';
import 'package:control_kuv/domain/repository/api_repository.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

enum ClientsState {
  loading,
  initial,
}

class ClientesBLoC extends ChangeNotifier {
  final ApiRepositoryInterface apiRepositoryInterface;

  //ClientBloc Variables
  Map<String, dynamic> complexErrorMsg = {};
  String simpleErrorMsg = '';
  Cliente client =
      Cliente(id: 0, nombre: '', rut: '', correo: '', estado: 1, tipo: 1);
  List<Cliente> clientList = <Cliente>[];
  List<Cliente> clientsByName = <Cliente>[];
  List<Cliente> historial = [];

  ClientsState clientsState = ClientsState.initial;
  MaskTextInputFormatter maskFormatter = MaskTextInputFormatter(
      mask: '##.###.###-#', filter: {'#': RegExp(r'[0-9]|k')});
  var response;
  double cardHeight = 180;
  int numDiasCuota = 4;
  int clientType = 3;
  bool isSelectedType = true;
  bool isSelectedPayDays = true;

  ClientesBLoC({required this.apiRepositoryInterface});

  //Form Variables
  ValidationItem _nombre = ValidationItem('', '');
  ValidationItem _rut = ValidationItem('', '');
  ValidationItem _correo = ValidationItem('', '');
  ValidationItem _direccion = ValidationItem('', '');
  ValidationItem _fono = ValidationItem('', '');
  ValidationItem _tipoPago = ValidationItem('1', '');
  ValidationItem _numCuotas = ValidationItem('', '');
  ValidationItem _tipo = ValidationItem('', '');

  //Getters
  ValidationItem get nombre => _nombre;

  ValidationItem get rut => _rut;

  ValidationItem get correo => _correo;

  ValidationItem get direccion => _direccion;

  ValidationItem get fono => _fono;

  ValidationItem get tipoPago => _tipoPago;

  ValidationItem get numCuotas => _numCuotas;

  ValidationItem get tipo => _tipo;

  bool get isValid {
    if (_tipoPago.value == '1') {
      if (_nombre.value.isNotEmpty &&
          _rut.value.isNotEmpty &&
          _correo.value.isNotEmpty &&
          _direccion.value.isNotEmpty &&
          _fono.value.isNotEmpty &&
          _tipo.value.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } else {
      if (_nombre.value != '' &&
          _rut.value != '' &&
          _correo.value != '' &&
          _direccion.value != '' &&
          _fono.value != '' &&
          _numCuotas.value != '' &&
          _tipo.value != '') {
        return true;
      } else {
        return false;
      }
    }
  }

  void clearFields() {
    _nombre = ValidationItem('', '');
    _rut = ValidationItem('', '');
    _correo = ValidationItem('', '');
    _direccion = ValidationItem('', '');
    _fono = ValidationItem('', '');
    _tipoPago = ValidationItem('1', '');
    _numCuotas = ValidationItem('', '');
    _tipo = ValidationItem('', '');
    maskFormatter.clear();
    numDiasCuota = 4;
    clientType = 3;
    isSelectedType = true;
    isSelectedPayDays = true;
    notifyListeners();
  }

  void changeType(String type) {
    if (type == '3') {
      clientType = 3;
      isSelectedType = false;
      _tipo = ValidationItem('', 'Error que no se mostrará');
    } else {
      isSelectedType = true;
      _tipo = ValidationItem(type, '');
      clientType = int.parse(type);
    }
    notifyListeners();
  }

  void changeName(String name) {
    if (name.trim().isEmpty) {
      _nombre = ValidationItem('', 'Este campo es obligatorio.');
    } else if (name.length < 4) {
      _nombre = ValidationItem('', 'Debe contener al menos 4 caractéres.');
    } else {
      _nombre = ValidationItem(name, '');
    }
    notifyListeners();
  }

  void changeRUN(String run) {
    run = maskFormatter.getUnmaskedText();
    if (run.isEmpty) {
      _rut = ValidationItem('', 'Este campo es obligatorio.');
    } else if (run.length < 8) {
      _rut = ValidationItem('', 'El RUT es incorrecto.');
    } else {
      if (validateRUT(run)) {
        _rut = ValidationItem(run, '');
      } else {
        _rut = ValidationItem('', 'RUT incorrecto, vuelva a intentar.');
      }
    }
    notifyListeners();
  }

  bool validateRUT(String run) {
    // Aislar Cuerpo y Dígito Verificador
    String body;
    var dv;
    if (run.length == 8) {
      body = run.substring(0, 7);
      dv = run.substring(7).toUpperCase();
    } else {
      body = run.substring(0, 8);
      dv = run.substring(8).toUpperCase();
    }

    //Calcular DV
    var suma = 0;
    var multiple = 2;

    // Para cada dígito del Cuerpo
    for (var i = 1; i <= body.length; i++) {
      // Obtener su Producto con el Múltiplo Correspondiente
      var index = multiple * int.parse(run[body.length - i]);
      // Sumar al Contador General
      suma = suma + index;

      // Consolidar Múltiplo dentro del rango [2,7]
      if (multiple < 7) {
        multiple = multiple + 1;
      } else {
        multiple = 2;
      }
    }
    // Calcular Dígito Verificador en base al Módulo 11
    var dvEsperado = 11 - (suma % 11);
    // Casos Especiales (0 y K)
    dv = (dv == 'K') ? 10 : dv;
    dv = (dv == '0') ? 11 : dv;

    // Validar que el Cuerpo coincide con su Dígito Verificador
    if (dvEsperado.toString() != dv.toString()) {
      return false;
    } else {
      return true;
    }
  }

  void changeEmail(String email) {
    Pattern pattern =
        (r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
            r'{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]'
            r'{0,253}[a-zA-Z0-9])?)*$');
    var regex = RegExp(pattern.toString());
    if (email.isEmpty) {
      _correo = ValidationItem('', 'Este campo es obligatorio.');
    } else if (!regex.hasMatch(email)) {
      _correo = ValidationItem('', 'E-mail no válido.');
    } else {
      _correo = ValidationItem(email, '');
    }
    notifyListeners();
  }

  void changeAddress(String address) {
    if (address.trim().isEmpty) {
      _direccion = ValidationItem('', 'Este campo es obligatorio.');
    } else {
      _direccion = ValidationItem(address, '');
    }
    notifyListeners();
  }

  void changePhone(String phone) {
    Pattern pattern = r'[0-9]$';
    var regex = RegExp(pattern.toString());
    if (phone.trim().isEmpty) {
      _fono = ValidationItem('', 'Este campo es obligatorio.');
    } else if (!regex.hasMatch(phone) ||
        phone.length < 9 ||
        phone.length > 11) {
      _fono = ValidationItem('', 'Ingrese un telefono válido.');
    } else {
      _fono = ValidationItem(phone, '');
    }
    notifyListeners();
  }

  void changeNumCuotas(String numCuotas) {
    print(numCuotas);
    if (numCuotas.isNotEmpty) {
      if (numCuotas == '4') {
        isSelectedPayDays = false;
        numDiasCuota = 4;
        _numCuotas = ValidationItem('', 'Error que no aparecerá.');
      } else {
        isSelectedPayDays = true;
        numDiasCuota = int.parse(numCuotas);
        _numCuotas = ValidationItem(numCuotas, '');
      }
    }

    notifyListeners();
  }

  void changePayType(dynamic clientPayType) {
    _tipoPago = ValidationItem(clientPayType, '');
    if (clientPayType == '2') {
      _numCuotas = ValidationItem('1', '');
    } else {
      numDiasCuota = 4;
      isSelectedPayDays = true;
      _numCuotas = ValidationItem('', '');
    }
    notifyListeners();
  }

  Future<bool> submitData() async {
    if (_tipo.value.isEmpty) {
      isSelectedType = false;
      notifyListeners();
      return false;
    }
    if (_tipoPago.value == '2' && _numCuotas.value.isEmpty) {
      isSelectedPayDays = false;
      notifyListeners();
    }
    if (isValid) {
      isSelectedType = true;
      notifyListeners();
      try {
        //  Crear un objeto Cliente
        var client =
            Cliente(nombre: '', rut: '', correo: '', estado: 0, tipo: 0);
        client.nombre = _nombre.value;
        client.rut = _rut.value.toString();
        client.correo = _correo.value;
        client.direccion = _direccion.value;
        client.fono = _fono.value;
        client.numerocuotas =
            _tipoPago.value == '1' ? null : int.parse(_numCuotas.value);
        client.tipopago = int.parse(_tipoPago.value);
        client.tipo = int.parse(_tipo.value);
        clientsState = ClientsState.loading;
        notifyListeners();
        final result = await apiRepositoryInterface.createCliente(client);
        print('resultado de create $result');
        if (result.id != null) {
          clientList.insert(0, result);
        }
        clientsState = ClientsState.initial;
        notifyListeners();
        return true;
      } on ClientException catch (e) {
        print('ClientException: ${e.getMessage()}');
        complexErrorMsg = e.getMessage();
        simpleErrorMsg = '';
        clientsState = ClientsState.initial;
        notifyListeners();
        return false;
      } on Exception catch (e) {
        print('Exception TIMEOUT $e');
        simpleErrorMsg = e.toString().replaceAll('TimeoutException: ', '');
        complexErrorMsg = {};
        clientsState = ClientsState.initial;
        notifyListeners();
        return false;
      }
    } else {
      return false;
    }
  }

  Future<void> loadClients() async {
    try {
      clientsState = ClientsState.loading;
      notifyListeners();
      final result = await apiRepositoryInterface.getClientes();
      clientList = result;
      print('Clientes: ${clientList.length}');
      clientsState = ClientsState.initial;
      notifyListeners();
    } on ClientException catch (_) {
      clientsState = ClientsState.initial;
      notifyListeners();
    }
    notifyListeners();
  }

  Future<void> getClientByNameRunEmail(String query) async {
    try {
      final result =
          await apiRepositoryInterface.getClientByNameRunEmail(query);
      clientsByName = result;
    } on ClientException catch (e) {
      print(e);
    }
  }

  Future<void> insertClient(Cliente client) async {
    try {
      clientsState = ClientsState.loading;
      notifyListeners();
      final result = await apiRepositoryInterface.createCliente(client);
      print('resultado de create $result');
      print('LISTA ANTES ${clientList.length}');
      if (result.id != null) {
        clientList.insert(0, result);
      }
      print('LISTA DESPUES ${clientList.length}');
      clientsState = ClientsState.initial;
      notifyListeners();
    } on ClientException catch (_) {
      clientsState = ClientsState.initial;
      notifyListeners();
    }
  }
}
