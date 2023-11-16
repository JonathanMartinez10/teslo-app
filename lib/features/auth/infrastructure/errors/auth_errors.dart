
class ConnectionTimeout implements Exception{}
class WrongCredentials implements Exception{}
class InvalidToken implements Exception{}

class CustomError implements Exception{

  // final int errorCode;
  final String message;

  CustomError(this.message);
}