import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import 'enums.dart';

/// Paths to be used as parameters for the `/api/setData` and `/api/getData`
/// URI
///
/// See https://community.roonlabs.com/t/ls50-wireless-ii-home-automation/154388/11
class ApiPath {
  static String speakerStatus = 'settings:/kef/host/speakerStatus';
  static String volumeLimit = 'settings:/kef/host/volumeLimit';
  static String volumeStep = 'settings:/kef/host/volumeStep';
  static String maximumVolume = 'settings:/kef/host/maximumVolume';
  static String speakerSource = 'settings:/kef/play/physicalSource';
  static String playMode = 'settings:/mediaPlayer/playMode';
  static String mute = 'settings:/mediaPlayer/mute';
  static String volume = 'player:volume';
  static String playerData = 'player:player/data';
  static String playerControl = 'player:player/control';
  static String playTime = 'player:player/data/playTime';
  static String pqGetitems = 'playlists:pq/getitems';
  static String queue = 'notifications:/display/queue';
  static String firmwareInfo = 'kef:fwupgrade/info';
}

/// A client for the KEF LS50 Wireless 2
///
/// This client exposes methods for media controls, player data and more
class KefClient {
  KefClient(this.host)
      : _client = Client(),
        _getDataUri = Uri.parse('http://$host/api/getData'),
        _setDataUri = Uri.parse('http://$host/api/setData');

  /// The IP address in the local network
  final String host;
  final Client _client;

  final Uri _getDataUri;
  final Uri _setDataUri;

  /// Turn the speaker on. Shortcut for [setStatus]
  Future<void> turnOn() => setStatus(SpeakerStatus.powerOn);

  /// Turn the speaker off. Shortcut for [setStatus]
  Future<void> turnOff() => setStatus(SpeakerStatus.standby);

  /// Skip to next track. Shortcut for [controlPlayer]
  Future<void> nextTrack() => controlPlayer(PlayerControl.next);

  /// Toggle play/pause. Shortcut for [controlPlayer]
  Future<void> togglePlayPause() => controlPlayer(PlayerControl.pause);

  /// Play the previous track. Shortcut for [controlPlayer]
  Future<void> previousTrack() => controlPlayer(PlayerControl.previous);

  /// Fetch the raw json from the [ApiPath.playerData] path
  Future<Map<String, dynamic>> getPlayerData() async {
    final response = await getDataRequest(path: ApiPath.playerData);
    // data is nested in a list
    final data = json.decode(response.body) as List;
    return data[0] as Map<String, dynamic>;
  }

  Future<SpeakerStatus> getStatus() async {
    final response = await getDataRequest(path: ApiPath.speakerStatus);
    final String data = json.decode(response.body)[0]['kefSpeakerStatus'];
    return toSpeakerStatus(data);
  }

  /// Send a [SpeakerStatus] command to the `settings:/kef/host/speakerStatus`
  /// path
  Future<void> setStatus(SpeakerStatus status) {
    return _setDataRequest(
      path: ApiPath.speakerStatus,
      value: json.encode({
        'type': 'kefSpeakerStatus',
        'kefSpeakerStatus': status.name(),
      }),
    );
  }

  /// Get the [SpeakerSource]
  Future<SpeakerSource> getSource() async {
    final response = await getDataRequest(path: ApiPath.speakerSource);
    final String data = json.decode(response.body)[0]['kefPhysicalSource'];
    return toSpeakerSource(data);
  }

  /// Set the [SpeakerSource]
  Future<void> setSource(SpeakerSource source) async {
    return _setDataRequest(
      path: ApiPath.speakerSource,
      value: json.encode({
        'type': 'kefPhysicalSource',
        'kefPhysicalSource': source.name(),
      }),
    );
  }

  /// Get the volume level
  Future<int> getVolume() async {
    final response = await getDataRequest(path: ApiPath.volume);
    return json.decode(response.body)[0]['i32_'] as int;
  }

  /// Set the volume level.
  ///
  /// [volume] must be between 0 and 100
  Future<void> setVolume(int volume) async {
    assert(0 <= volume && volume <= 100, 'Volume has to be between 0 and 100');
    await _setDataRequest(
      path: ApiPath.volume,
      value: '{"type":"i32_","i32_":$volume}',
    );
  }

  /// Get the current song playtime
  Future<int> getSongPlaytime() async {
    final response = await getDataRequest(path: ApiPath.playTime);
    return json.decode(response.body)[0]['i64_'] as int;
  }

  /// Send a [PlayerControl] command to the `player:player/control` path
  Future<void> controlPlayer(PlayerControl control) async {
    await _setDataRequest(
      path: ApiPath.playerControl,
      value: '{"control":"${control.name()}"}',
      roles: 'activate',
    );
  }

  /// Modyfies the default [_getDataUri] with [path] and [roles] and calls
  /// [_makeRequest] to do the request.
  Future<Response> getDataRequest({
    required String path,
    String roles = 'value',
  }) {
    final queryParameters = {
      'path': path,
      'roles': roles,
    };
    final uri = _getDataUri.replace(queryParameters: queryParameters);
    return _makeRequest(uri);
  }

  /// Modyfies the default [_setDataUri] with [path], [value] and [roles]
  /// parameters and calls [_makeRequest] to do the request.
  Future<void> _setDataRequest({
    required String path,
    required String value,
    String roles = 'value',
  }) {
    final queryParameters = {
      'path': path,
      'roles': roles,
      'value': value,
    };
    final uri = _setDataUri.replace(queryParameters: queryParameters);
    return _makeRequest(uri);
  }

  /// Make a HTTP GET request to the given URI and throw a [HttpException] in
  /// case of a status code >= 300
  Future<Response> _makeRequest(Uri uri) async {
    final response = await _client.get(uri);
    if (response.statusCode >= 300) {
      throw HttpException(response.body, uri: uri);
    }
    return response;
  }
}
