// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EntryInfoAdapter extends TypeAdapter<EntryInfo> {
  @override
  final int typeId = 0;

  @override
  EntryInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EntryInfo()
      ..id = fields[0] as String?
      ..name = fields[1] as String?
      ..link = fields[2] as String?
      ..coverImage = fields[3] as String?
      ..description = fields[4] as String?
      ..releaseDate = fields[5] as String?
      ..provider = fields[6] as String
      ..favorite = fields[7] as bool
      ..episodes = (fields[8] as List).cast<Episode>();
  }

  @override
  void write(BinaryWriter writer, EntryInfo obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.link)
      ..writeByte(3)
      ..write(obj.coverImage)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.releaseDate)
      ..writeByte(6)
      ..write(obj.provider)
      ..writeByte(7)
      ..write(obj.favorite)
      ..writeByte(8)
      ..write(obj.episodes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EntryInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EpisodeAdapter extends TypeAdapter<Episode> {
  @override
  final int typeId = 1;

  @override
  Episode read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Episode(
      link: fields[1] as String,
      name: fields[0] as String,
    )..read = fields[2] as bool;
  }

  @override
  void write(BinaryWriter writer, Episode obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.link)
      ..writeByte(2)
      ..write(obj.read);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EpisodeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
