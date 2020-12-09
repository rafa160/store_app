import 'dart:io';

import 'package:dio/dio.dart';
import 'package:storeapp/models/address/address_api_cep_aberto.dart';

const token = '05cb2442d983918bf1706f597ec60e2a';

class CepApi {

  final url = "https://www.cepaberto.com/api/v3/cep?cep=";

  Future<Address> getAddressFromCep(String cep) async {
    final cleanCep = cep.replaceAll('.', '').replaceAll('-', '');
    final url = "https://www.cepaberto.com/api/v3/cep?cep=$cleanCep";

    final Dio dio = Dio();
    dio.options.headers[HttpHeaders.authorizationHeader] = 'Token token=$token';

    try{
      final response = await dio.get<Map<String, dynamic>>(url);

      if(response.data.isEmpty){
        return Future.error('Cep inválido');
      }

      final Address address = Address.fromMap(response.data);

      return address;
    } on DioError {
      return Future.error('erro ao buscar endereço');
    }

  }
  
}