// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_music_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MyMusicModelAdapter extends TypeAdapter<MyMusicModel> {
  @override
  final int typeId = 0;

  @override
  MyMusicModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MyMusicModel(
      id: fields[0] as int?,
      ytid: fields[1] as String?,
      title: fields[2] as String?,
      image: fields[3] as String?,
      lowResImage: fields[4] as String?,
      highResImage: fields[5] as String?,
      album: fields[6] as String?,
      type: fields[7] as String?,
      moreInfo: fields[8] as MoreInfo?,
      songUrl: fields[9] as String?,
      duration: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MyMusicModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.ytid)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.lowResImage)
      ..writeByte(5)
      ..write(obj.highResImage)
      ..writeByte(6)
      ..write(obj.album)
      ..writeByte(7)
      ..write(obj.type)
      ..writeByte(8)
      ..write(obj.moreInfo)
      ..writeByte(9)
      ..write(obj.songUrl)
      ..writeByte(10)
      ..write(obj.duration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyMusicModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
