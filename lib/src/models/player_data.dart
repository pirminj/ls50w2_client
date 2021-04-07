import 'package:json_annotation/json_annotation.dart';

part 'player_data.g.dart';

enum PlayerState {
  playing,
  paused,
  transitioning,
  stopped,
}

Duration _secondsToDuration(int seconds) => Duration(seconds: seconds);

int _durationToSeconds(Duration duration) => duration.inSeconds;

@JsonSerializable()
class _PlayerStatus {
  _PlayerStatus(
    this.duration,
    this.playSpeed,
  );

  @JsonKey(fromJson: _secondsToDuration, toJson: _durationToSeconds)
  Duration duration;
  double playSpeed;

  factory _PlayerStatus.fromJson(Map<String, dynamic> json) =>
      _$_PlayerStatusFromJson(json);

  Map<String, dynamic> toJson() => _$_PlayerStatusToJson(this);
}

@JsonSerializable()
class _PlayerControls {
  _PlayerControls(
    this.pause,
    this.next_,
    this.previous,
    this.playMode,
  );

  bool pause;
  bool next_;
  bool previous;
  Map playMode;

  factory _PlayerControls.fromJson(Map<String, dynamic> json) =>
      _$_PlayerControlsFromJson(json);

  Map<String, dynamic> toJson() => _$_PlayerControlsToJson(this);
}

@JsonSerializable()
class _PlayId {
  _PlayId(
    this.timestamp,
    this.systemMemberId,
  );

  int timestamp;
  String systemMemberId;

  factory _PlayId.fromJson(Map<String, dynamic> json) =>
      _$_PlayIdFromJson(json);

  Map<String, dynamic> toJson() => _$_PlayIdToJson(this);
}

@JsonSerializable()
class _MetaData {
  _MetaData(
    this.album,
    this.albumArtist,
    this.artist,
    this.composer,
    this.externalAppName,
    this.originalTrackNumber,
    this.serviceNameOverride,
  );

  String serviceNameOverride;
  String artist;
  String album;
  String albumArtist;
  String externalAppName;
  String composer;
  int originalTrackNumber;

  factory _MetaData.fromJson(Map<String, dynamic> json) =>
      _$_MetaDataFromJson(json);

  Map<String, dynamic> toJson() => _$_MetaDataToJson(this);
}

@JsonSerializable()
class _MediaData {
  _MediaData(
    this.metaData,
  );

  _MetaData metaData;

  factory _MediaData.fromJson(Map<String, dynamic> json) =>
      _$_MediaDataFromJson(json);

  Map<String, dynamic> toJson() => _$_MediaDataToJson(this);
}

@JsonSerializable()
class _TrackRoles {
  _TrackRoles(
    this.title,
    this.audioType,
    this.icon,
    this.description,
    this.mediaData,
  );

  String title;
  String audioType;
  String icon;
  String description;
  _MediaData mediaData;

  factory _TrackRoles.fromJson(Map<String, dynamic> json) =>
      _$_TrackRolesFromJson(json);

  Map<String, dynamic> toJson() => _$_TrackRolesToJson(this);
}

@JsonSerializable()
class _MediaRoles {
  _MediaRoles(
    this.title,
    this.audioType,
    this.icon,
    this.description,
    this.doNotTrack,
    this.path,
    this.timestamp,
    this.type,
  );

  // TODO: mediaData for more info
  // _MetaData
  String title;
  String type;
  String path;
  int timestamp;
  String audioType;
  bool doNotTrack;
  String icon;
  String description;

  factory _MediaRoles.fromJson(Map<String, dynamic> json) =>
      _$_MediaRolesFromJson(json);

  Map<String, dynamic> toJson() => _$_MediaRolesToJson(this);
}

abstract class PlayerData {
  abstract PlayerState state;
}

@JsonSerializable()
class ActivePlayerData implements PlayerData {
  ActivePlayerData(
    this.status,
    this.controls,
    this.playId,
    this.state,
    this.trackRoles,
    this.mediaRoles,
  );

  _PlayerStatus status;
  _PlayerControls controls;
  _PlayId playId;
  _TrackRoles trackRoles;
  _MediaRoles mediaRoles;

  @override
  PlayerState state;

  factory ActivePlayerData.fromJson(Map<String, dynamic> json) =>
      _$ActivePlayerDataFromJson(json);

  Map<String, dynamic> toJson() => _$ActivePlayerDataToJson(this);
}

@JsonSerializable()
class InactivePlayerData implements PlayerData {
  InactivePlayerData(
    this.playId,
    this.state,
    this.error,
    this.error2,
    this.keepActive,
  );

  _PlayId playId;
  String error;
  Map error2;
  bool keepActive;

  @override
  PlayerState state;

  factory InactivePlayerData.fromJson(Map<String, dynamic> json) =>
      _$InactivePlayerDataFromJson(json);

  Map<String, dynamic> toJson() => _$InactivePlayerDataToJson(this);
}
