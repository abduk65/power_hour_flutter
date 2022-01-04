// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AuthUserAdapter extends TypeAdapter<AuthUser> {
  @override
  final typeId = 3;

  @override
  AuthUser read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AuthUser(
      status: fields[0] as dynamic,
      userId: fields[1] as dynamic,
      email: fields[2] as dynamic,
      
      role: fields[3] as dynamic,
      is_profile_complete: fields[4] as dynamic,
      phone: fields[5] as dynamic,
      full_name: fields[6] as dynamic,
      token: fields[7] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, AuthUser obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.status)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.email)      
      ..writeByte(3)
      ..write(obj.role)
      ..writeByte(4)
      ..write(obj.is_profile_complete)
      ..writeByte(5)
      ..write(obj.phone)
      ..writeByte(6)
      ..write(obj.full_name)
      ..writeByte(7)
      ..write(obj.token);
      
  }
}
