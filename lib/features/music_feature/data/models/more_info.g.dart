// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'more_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MoreInfoAdapter extends TypeAdapter<MoreInfo> {
  @override
  final int typeId = 1;

  @override
  MoreInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MoreInfo(
      primaryArtists: fields[0] as String?,
      singers: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MoreInfo obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.primaryArtists)
      ..writeByte(1)
      ..write(obj.singers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoreInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
