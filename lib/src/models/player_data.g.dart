// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlayerStatus _$_PlayerStatusFromJson(Map<String, dynamic> json) {
  return _PlayerStatus(
    _secondsToDuration(json['duration'] as int),
    (json['playSpeed'] as num).toDouble(),
  );
}

Map<String, dynamic> _$_PlayerStatusToJson(_PlayerStatus instance) =>
    <String, dynamic>{
      'duration': _durationToSeconds(instance.duration),
      'playSpeed': instance.playSpeed,
    };

_PlayerControls _$_PlayerControlsFromJson(Map<String, dynamic> json) {
  return _PlayerControls(
    json['pause'] as bool,
    json['next_'] as bool,
    json['previous'] as bool,
    json['playMode'] as Map<String, dynamic>,
  );
}

Map<String, dynamic> _$_PlayerControlsToJson(_PlayerControls instance) =>
    <String, dynamic>{
      'pause': instance.pause,
      'next_': instance.next_,
      'previous': instance.previous,
      'playMode': instance.playMode,
    };

_PlayId _$_PlayIdFromJson(Map<String, dynamic> json) {
  return _PlayId(
    json['timestamp'] as int,
    json['systemMemberId'] as String,
  );
}

Map<String, dynamic> _$_PlayIdToJson(_PlayId instance) => <String, dynamic>{
      'timestamp': instance.timestamp,
      'systemMemberId': instance.systemMemberId,
    };

_MetaData _$_MetaDataFromJson(Map<String, dynamic> json) {
  return _MetaData(
    json['album'] as String,
    json['albumArtist'] as String,
    json['artist'] as String,
    json['composer'] as String,
    json['externalAppName'] as String,
    json['originalTrackNumber'] as int,
    json['serviceNameOverride'] as String,
  );
}

Map<String, dynamic> _$_MetaDataToJson(_MetaData instance) => <String, dynamic>{
      'serviceNameOverride': instance.serviceNameOverride,
      'artist': instance.artist,
      'album': instance.album,
      'albumArtist': instance.albumArtist,
      'externalAppName': instance.externalAppName,
      'composer': instance.composer,
      'originalTrackNumber': instance.originalTrackNumber,
    };

_MediaData _$_MediaDataFromJson(Map<String, dynamic> json) {
  return _MediaData(
    _MetaData.fromJson(json['metaData'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$_MediaDataToJson(_MediaData instance) =>
    <String, dynamic>{
      'metaData': instance.metaData.toJson(),
    };

_TrackRoles _$_TrackRolesFromJson(Map<String, dynamic> json) {
  return _TrackRoles(
    json['title'] as String,
    json['audioType'] as String,
    json['icon'] as String,
    json['description'] as String,
    _MediaData.fromJson(json['mediaData'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$_TrackRolesToJson(_TrackRoles instance) =>
    <String, dynamic>{
      'title': instance.title,
      'audioType': instance.audioType,
      'icon': instance.icon,
      'description': instance.description,
      'mediaData': instance.mediaData.toJson(),
    };

_MediaRoles _$_MediaRolesFromJson(Map<String, dynamic> json) {
  return _MediaRoles(
    json['title'] as String,
    json['audioType'] as String,
    json['icon'] as String,
    json['description'] as String,
    json['doNotTrack'] as bool,
    json['path'] as String,
    json['timestamp'] as int,
    json['type'] as String,
  );
}

Map<String, dynamic> _$_MediaRolesToJson(_MediaRoles instance) =>
    <String, dynamic>{
      'title': instance.title,
      'type': instance.type,
      'path': instance.path,
      'timestamp': instance.timestamp,
      'audioType': instance.audioType,
      'doNotTrack': instance.doNotTrack,
      'icon': instance.icon,
      'description': instance.description,
    };

ActivePlayerData _$ActivePlayerDataFromJson(Map<String, dynamic> json) {
  return ActivePlayerData(
    _PlayerStatus.fromJson(json['status'] as Map<String, dynamic>),
    _PlayerControls.fromJson(json['controls'] as Map<String, dynamic>),
    _PlayId.fromJson(json['playId'] as Map<String, dynamic>),
    _$enumDecode(_$PlayerStateEnumMap, json['state']),
    _TrackRoles.fromJson(json['trackRoles'] as Map<String, dynamic>),
    _MediaRoles.fromJson(json['mediaRoles'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ActivePlayerDataToJson(ActivePlayerData instance) =>
    <String, dynamic>{
      'status': instance.status.toJson(),
      'controls': instance.controls.toJson(),
      'playId': instance.playId.toJson(),
      'trackRoles': instance.trackRoles.toJson(),
      'mediaRoles': instance.mediaRoles.toJson(),
      'state': _$PlayerStateEnumMap[instance.state],
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$PlayerStateEnumMap = {
  PlayerState.playing: 'playing',
  PlayerState.paused: 'paused',
  PlayerState.transitioning: 'transitioning',
  PlayerState.stopped: 'stopped',
};

InactivePlayerData _$InactivePlayerDataFromJson(Map<String, dynamic> json) {
  return InactivePlayerData(
    _PlayId.fromJson(json['playId'] as Map<String, dynamic>),
    _$enumDecode(_$PlayerStateEnumMap, json['state']),
    json['error'] as String,
    json['error2'] as Map<String, dynamic>,
    json['keepActive'] as bool,
  );
}

Map<String, dynamic> _$InactivePlayerDataToJson(InactivePlayerData instance) =>
    <String, dynamic>{
      'playId': instance.playId.toJson(),
      'error': instance.error,
      'error2': instance.error2,
      'keepActive': instance.keepActive,
      'state': _$PlayerStateEnumMap[instance.state],
    };
