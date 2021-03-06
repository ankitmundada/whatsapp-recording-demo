import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:whatsappaudio/commons/base/base_exception.dart';

enum Status {
  UNKNOWN,
  LOADING,
  SUCCESS,
  FAILURE,
}

@immutable
abstract class BaseState extends Equatable {
  final Status status;
  final BaseException exception;

  const BaseState(this.status, [this.exception]);

  @override
  List<Status> get props => [status];
}
