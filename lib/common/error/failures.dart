
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final String title;
  const Failure({
    this.message = 'Unexpected Error',
    this.title = 'Default Error'
});

  @override
  List<Object> get props => [];
}

//General Failures
class ServerFailure extends Failure {
  const ServerFailure({message = 'Unexpected Error', title = 'Server Failure'}): super(message: message, title: title);
}
class TimeOutFailure extends Failure {
  const TimeOutFailure({message = 'La aplicación no responde, por favor intentelo más tarde', title = 'Timeout'}): super(message: message, title: title);
}
class LoginFailure extends Failure {
  const LoginFailure({message = 'Unexpected Error', title = 'Login Error'}): super(message: message, title: title);
}
class CodeEmptyFailure extends Failure {
  const CodeEmptyFailure({message = 'Unexpected Error', title = 'Code Empty'}): super(message: message, title: title);
}
class CodeFailure extends Failure {
  const CodeFailure({message = 'Unexpected Error', title = 'Code Error'}): super(message: message, title: title);
}
class LoginEmptyFailure extends Failure {
  const LoginEmptyFailure({message = 'Unexpected Error', title = 'Login Empty'}): super(message: message, title: title);
}
class CacheFailure extends Failure {
  const CacheFailure({message = 'Unexpected Error', title = 'Cache Failure'}): super(message: message, title: title);
}
class PasswordEmpty extends Failure {
  const PasswordEmpty({message = 'Unexpected Error', title = 'Password Empty'}): super(message: message, title: title);
}
