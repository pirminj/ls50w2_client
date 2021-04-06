import 'dart:convert';

import 'package:http/http.dart';

import 'enums.dart';
import 'models/player_data.dart';

/// A client for the KEF LS50 Wireless 2
///
/// This client exposes methods for media controls, player data and more
class KefClient {
  KefClient(this.host)
      : _client = Client(),
        _getDataUri = Uri.parse('http://$host/api/getData'),
        _setDataUri = Uri.parse('http://$host/api/setData');

  final Client _client;

  final Uri _getDataUri;
  final Uri _setDataUri;

  /// The IP address in the local network
  final String host;

  Future<SpeakerStatus> getStatus() async {
    var response = await _client.get(
      _getDataUri.replace(
        queryParameters: {
          'path': 'settings:/kef/host/speakerStatus',
          'roles': 'value',
        },
      ),
    );

    return toSpeakerStatus(jsonDecode(response.body)[0]['kefSpeakerStatus']);
  }

  // doesn't work
  Future<bool> setStatus(SpeakerStatus status) async {
    final params = {
      'path': 'settings:/kef/play/physicalSource',
      'roles': 'value',
      'value':
          '{"type":"kefSpeakerStatus","kefSpeakerStatus":"${status.name()}"}',
    };

    var response = await _client.get(
      _getDataUri.replace(queryParameters: params),
    );

    if (response.statusCode != 200) {
      return false;
    }

    return true;
  }

  Future<SpeakerSource> getSource() async {
    var response = await _client.get(
      _getDataUri.replace(
        queryParameters: {
          'path': 'settings:/kef/play/physicalSource',
          'roles': 'value',
        },
      ),
    );

    return toSpeakerSource(jsonDecode(response.body)[0]['kefPhysicalSource']);
  }

  Future<bool> setSource(SpeakerSource source) async {
    final params = {
      'path': 'settings:/kef/play/physicalSource',
      'roles': 'value',
      'value':
          '{"type":"kefPhysicalSource","kefPhysicalSource":"${source.name()}"}',
    };
    var response = await _client.get(
      _setDataUri.replace(queryParameters: params),
    );

    if (response.statusCode != 200) {
      return false;
    } else {
      return true;
    }
  }

  Future<int> getVolume() async {
    final params = {
      'path': 'player:volume',
      'roles': 'value',
    };
    var response = await _client.get(
      _getDataUri.replace(queryParameters: params),
    );

    return jsonDecode(response.body)[0]['i32_'] as int;
  }

  Future<bool> setVolume(int volume) async {
    final params = {
      'path': 'player:volume',
      'roles': 'value',
      'value': '{"type":"i32_","i32_":$volume}',
    };
    final response = await _client.get(
      _setDataUri.replace(queryParameters: params),
    );

    if (response.statusCode != 200) {
      return false;
    } else {
      return true;
    }
  }

  Future<PlayerData> getPlayerData() async {
    final params = {
      'path': 'player:player/data',
      'roles': 'value',
    };

    final response = await _client.get(
      _getDataUri.replace(queryParameters: params),
    );

    final json = jsonDecode(response.body)[0] as Map<String, dynamic>;

    // dispatch the json. This may be done with the `status` field
    if (json.length > 5) {
      return ActivePlayerData.fromJson(json);
    } else {
      return InactivePlayerData.fromJson(json);
    }
  }

  Future<int> getSongPlaytime() async {
    final params = {
      'path': 'player:player/data/playTime',
      'roles': 'value',
    };

    final response = await _client.get(
      _getDataUri.replace(queryParameters: params),
    );

    return jsonDecode(response.body)[0]['i64_'] as int;
  }

  Future<bool> _playerControl(PlayerControl control) async {
    final params = {
      'path': 'player:player/control',
      'roles': 'activate',
      'value': '{"control":"${control.name()}"}',
    };

    final response = await _client.get(
      _setDataUri.replace(queryParameters: params),
    );

    if (response.statusCode != 200) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> nextTrack() => _playerControl(PlayerControl.next);
  Future<bool> togglePlayPause() => _playerControl(PlayerControl.pause);
  Future<bool> previousTrack() => _playerControl(PlayerControl.previous);
}
