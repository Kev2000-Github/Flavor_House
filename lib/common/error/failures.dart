
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

//General Failures
class ServerFailure extends Failure {}
class LoginFailure extends Failure {}
class CodeEmptyFailure extends Failure {}
class CodeFailure extends Failure {}
class LoginEmptyFailure extends Failure {}
class CacheFailure extends Failure {}
class PasswordEmpty extends Failure {}
