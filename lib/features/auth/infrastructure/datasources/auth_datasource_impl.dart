import 'dart:math';

import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

class AuthDatasourceImpl extends AuthDatasource{

  final dio = Dio(
    BaseOptions(
      baseUrl: Enviroment.apiUrl,
    )
  );

  @override
  Future<User> checkAuthStatus(String token) {
    // TODO: implement checkAuthStatus
    throw UnimplementedError();
  }

  @override
  Future<User> login(String email, String password) async {
    
    try {
      final response = await dio.post('/auth/login', data: {
        'email' :  email,
        'password' : password
      });

      final User user = UserMapper.userJsontoEntity(response.data);

      return user;

    } on DioException catch(e) {      
      if(e.response?.statusCode == 401){
        throw CustomError(e.response?.data['message'] ?? 'Credenciales icorrectas' );
      }
      if(e.type == DioExceptionType.connectionTimeout){
        throw CustomError('Revise su conexion a internet');
      }
      throw Exception();
      
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> register(String email, String password, String fullName) async {
    
    try {

      final response = await dio.post('/auth/register', data: {
        'email' :  email,
        'password' : password,
        'fullName' : fullName,
      });

      final User user = UserMapper.userJsontoEntity(response.data);

      return user;

    } on DioException catch (e) {
 
      if(e.response?.statusCode == 400 ){
        // throw CustomError(e.response?.data['message'] ?? 'El correo electronico ya esta en uso');
        throw CustomError('El correo electronico ya esta en uso');
      }

      if(e.type == DioExceptionType.connectionTimeout){
        throw CustomError('Revise su conexion a internet');
      }

      if(e.error == 'Connection timed out'){
        throw CustomError('Revise su conexion a internet2');
      }

      throw Exception();
    }

  }

}