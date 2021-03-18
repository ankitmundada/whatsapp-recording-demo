import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

enum Status {
  UNKNOWN,
  LOADING,
  SUCCESS,
  FAILURE,
}

@immutable
abstract class BaseState extends Equatable {
  final Status status;

  const BaseState(this.status);

  @override
  List<Status> get props => [status];
}
