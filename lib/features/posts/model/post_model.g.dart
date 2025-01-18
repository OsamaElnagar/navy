// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PostResponseAdapter extends TypeAdapter<PostResponse> {
  @override
  final int typeId = 2;

  @override
  PostResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PostResponse(
      responseCode: fields[0] as String,
      message: fields[1] as String,
      content: (fields[2] as List).cast<Post>(),
      errors: (fields[3] as List).cast<dynamic>(),
      pagination: fields[4] as Pagination,
    );
  }

  @override
  void write(BinaryWriter writer, PostResponse obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.responseCode)
      ..writeByte(1)
      ..write(obj.message)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.errors)
      ..writeByte(4)
      ..write(obj.pagination);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PostAdapter extends TypeAdapter<Post> {
  @override
  final int typeId = 3;

  @override
  Post read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Post(
      id: fields[0] as int,
      content: fields[1] as String,
      visibility: fields[2] as String,
      location: fields[3] as String,
      createdAt: fields[4] as String,
      updatedAt: fields[5] as String,
      reactionsCount: fields[6] as int,
      commentsCount: fields[7] as int,
      sharesCount: fields[8] as int,
      selfReacted: fields[9] as bool,
      selfReactionType: fields[10] as String?,
      media: (fields[11] as List).cast<String>(),
      owner: fields[12] as Owner,
    );
  }

  @override
  void write(BinaryWriter writer, Post obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.visibility)
      ..writeByte(3)
      ..write(obj.location)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.reactionsCount)
      ..writeByte(7)
      ..write(obj.commentsCount)
      ..writeByte(8)
      ..write(obj.sharesCount)
      ..writeByte(9)
      ..write(obj.selfReacted)
      ..writeByte(10)
      ..write(obj.selfReactionType)
      ..writeByte(11)
      ..write(obj.media)
      ..writeByte(12)
      ..write(obj.owner);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OwnerAdapter extends TypeAdapter<Owner> {
  @override
  final int typeId = 4;

  @override
  Owner read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Owner(
      id: fields[0] as int,
      name: fields[1] as String,
      avatar: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Owner obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.avatar);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OwnerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PaginationAdapter extends TypeAdapter<Pagination> {
  @override
  final int typeId = 5;

  @override
  Pagination read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Pagination(
      currentPage: fields[0] as int,
      lastPage: fields[1] as int,
      perPage: fields[2] as int,
      total: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Pagination obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.currentPage)
      ..writeByte(1)
      ..write(obj.lastPage)
      ..writeByte(2)
      ..write(obj.perPage)
      ..writeByte(3)
      ..write(obj.total);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaginationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
