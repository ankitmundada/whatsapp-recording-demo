import 'package:equatable/equatable.dart';

enum AudioSourceType {
  URL,
  ASSET,
  FILE,
}

class AudioSource extends Equatable {
  final String value;
  final AudioSourceType type;

  const AudioSource(this.value, this.type);

  @override
  List<Object> get props => [value, type];
}
