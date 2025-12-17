import 'package:equatable/equatable.dart';

class SampleUser extends Equatable {
  final int id;
  final String name;
  final String email;

  const SampleUser({required this.id, required this.name, required this.email});

  @override
  List<Object?> get props => [id, name, email];
}
