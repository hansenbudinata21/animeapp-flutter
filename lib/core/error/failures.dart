import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object?> get props => [];

  String get failureMessage;
}

class ServerFailure extends Failure {
  final String message;
  ServerFailure({required this.message});

  @override
  String get failureMessage => message;
}

class CacheFailure extends Failure {
  @override
  String get failureMessage => "No Cache Data Available";
}
