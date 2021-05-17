import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import 'enums.dart';

// Paths to be used as parameters for the `/api/setData` and `/api/getData`
// URI
//
// See https://community.roonlabs.com/t/ls50-wireless-ii-home-automation/154388/11
//
// class _ApiPath {
//   static String playTime = 'player:player/data/playTime';
//   static String pqGetitems = 'playlists:pq/getitems';
//   static String queue = 'notifications:/display/queue';
//   static String subwooferOutLowpassFrequency = 'settings:/kef/dsp/subOutLPFreq';
// }

/// A client for the KEF LS50 Wireless 2
///
/// API Endpoints are called directly from the client via `set()` and `get()`
/// methods. For example, to reduce the volume by 20 percent, do
///
/// ```dart
/// speaker = KefClient('192.168.0.149');
/// final current = await speaker.volume.get();
/// await speaker.volume.set((current * 0.75).toInt());
/// ```
class KefClient {
  KefClient(this.host)
      : _client = Client(),
        // _eventUri = Uri.parse('http://$host/api/event'),
        _getDataUri = Uri.parse('http://$host/api/getData'),
        _setDataUri = Uri.parse('http://$host/api/setData');

  /// The IP address in the local network
  final String host;

  /// Internal HTTP client
  final Client _client;

  final Uri _getDataUri;
  final Uri _setDataUri;
  // final Uri _eventUri;

  // General API Endpoints

  /// The current [SpeakerStatus]
  late final ValueEndpoint<SpeakerStatus> status = ValueEndpoint(
    this,
    'settings:/kef/host/speakerStatus',
    'kefSpeakerStatus',
    fromString: enumFromString(SpeakerStatus.values),
  );

  /// The current [SpeakerSource] input
  late final ValueEndpoint<SpeakerSource> source = ValueEndpoint(
    this,
    'settings:/kef/play/physicalSource',
    'kefPhysicalSource',
    fromString: enumFromString(SpeakerSource.values),
  );

  /// Firmware update status infos
  late final InfoEndpoint firmwareUpdateInfo = InfoEndpoint(
    this,
    'kef:fwupgrade/info',
    'kefFirmwareUpgradeInfo',
  );

  /// Player data
  late final InfoEndpoint playerData = InfoEndpoint(
    this,
    'player:player/data',
  );

  /// Player volume between 0 and 100
  late final ValueEndpoint<int> volume = ValueEndpoint(
    this,
    'player:volume',
    'i32_',
  );

  /// Volume step
  late final ValueEndpoint<int> volumeStep = ValueEndpoint(
    this,
    'settings:/kef/host/volumeStep',
    'i32_',
  );

  /// Toggle maximum volume limit. See [maximumVolume] to set the value
  late final ValueEndpoint<bool> volumeLimit = ValueEndpoint(
    this,
    'settings:/kef/host/volumeLimit',
    'bool_',
  );

  /// Volume limit between 0 and 100
  late final ValueEndpoint<int> maximumVolume = ValueEndpoint(
    this,
    'settings:/kef/host/maximumVolume',
    'i32_',
  );

  late final ValueEndpoint playMode = ValueEndpoint(
    this,
    'settings:/mediaPlayer/playMode',
    'string_',
  );

  late final ValueEndpoint<bool> mutePlayer = ValueEndpoint(
    this,
    'settings:/mediaPlayer/mute',
    'bool_',
  );

  /// [MasterChannelMode] selects which speaker acts as the main speaker. The
  /// default is [MasterChannelMode.right], but if your primary speaker is on
  /// the left, make sure to set it to [MasterChannelMode.left].
  late final ValueEndpoint<MasterChannelMode> masterChannelMode = ValueEndpoint(
    this,
    'settings:/kef/host/masterChannelMode',
    'kefMasterChannelMode',
    fromString: enumFromString(MasterChannelMode.values),
  );

  /// Personalized speaker name. Mine is "Apollo", the greek god for music and
  /// dance :)
  late final ValueEndpoint<String> deviceName = ValueEndpoint(
    this,
    'settings:/deviceName',
    'string_',
  );

  // DSP and Equalizer API Endpoints

  /// Boolean switch for wall mode
  late final ValueEndpoint<bool> wallMode = ValueEndpoint(
    this,
    'settings:/kef/dsp/wallMode',
    'bool_',
  );

  /// Value for wall mode between 0 (-10 dB) and 20 (-0 dB)
  late final ValueEndpoint<int> wallModeSetting = ValueEndpoint(
    this,
    'settings:/kef/dsp/wallModeSetting',
    'i16_',
  );

  /// Boolean switch for desk mode
  late final ValueEndpoint<bool> deskMode = ValueEndpoint(
    this,
    'settings:/kef/dsp/deskMode',
    'bool_',
  );

  /// Value for desk mode between 0 (-10 dB) and 20 (-0 dB)
  late final ValueEndpoint<int> deskModeSetting = ValueEndpoint(
    this,
    'settings:/kef/dsp/deskModeSetting',
    'i16_',
  );

  /// Value for treble adjustment between 0 (-3 dB) and 16 (+3 dB)
  late final ValueEndpoint<int> trebleTrim = ValueEndpoint(
    this,
    'settings:/kef/dsp/trebleAmount',
    'i16_',
  );

  /// Turn phase correction on/off
  late final ValueEndpoint<bool> phaseCorrection = ValueEndpoint(
    this,
    'settings:/kef/dsp/phaseCorrection',
    'bool_',
  );

  /// Set your preferred [BassExtension]
  late final ValueEndpoint<BassExtension> bassExtension = ValueEndpoint(
    this,
    'settings:/kef/dsp/bassExtension',
    'kefBassExtension',
    fromString: enumFromString(BassExtension.values),
  );

  late final ValueEndpoint<int> subwooferOutLowpassFrequency = ValueEndpoint(
    this,
    'settings:/kef/dsp/subOutLPFreq',
    'i16_',
  );

  // Shortcut methods

  /// Turn the speaker on
  Future<void> turnOn() => status.set(SpeakerStatus.powerOn);

  /// Turn the speaker off
  Future<void> turnOff() => status.set(SpeakerStatus.standby);

  /// Mute the speaker
  Future<void> mute() => mutePlayer.set(true);

  /// Unmute the speaker.
  Future<void> unmute() => mutePlayer.set(false);

  /// Skip to next track. Shortcut for [controlPlayer]
  Future<void> nextTrack() => controlPlayer(PlayerControl.next);

  /// Toggle play/pause. Shortcut for [controlPlayer]
  Future<void> togglePlayPause() => controlPlayer(PlayerControl.pause);

  /// Play the previous track. Shortcut for [controlPlayer]
  Future<void> previousTrack() => controlPlayer(PlayerControl.previous);

  Future<T> getApiValue<T>(ApiEndpoint endpoint) async {
    final uri = _getDataUri.replace(queryParameters: endpoint.parameters());
    final response = await _makeRequest(uri);
    return endpoint.parseGetData(response.body);
  }

  Future<T> setApiValue<T>(ValueEndpoint<T> endpoint, T value) async {
    final parameters = endpoint.parameters(value);
    final uri = _setDataUri.replace(queryParameters: parameters);
    final response = await _makeRequest(uri);
    return endpoint.parseSetData(response.body);
  }

  /// Send a [PlayerControl] command to the `player:player/control` path
  Future<void> controlPlayer(PlayerControl control) async {
    final queryParameters = {
      'path': 'player:player/control',
      'roles': 'activate',
      'value': '{"control":"${control.name}"}',
    };
    final uri = _setDataUri.replace(queryParameters: queryParameters);
    await _makeRequest(uri);
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

/// Abstract API Endpoint class
abstract class ApiEndpoint<T> {
  Map<String, Object?> parameters();
  T parseGetData(String string);
  Future get();
}

/// A read-only API endpoint
class InfoEndpoint extends ApiEndpoint {
  InfoEndpoint(
    KefClient client,
    this.path, [
    this.kefType,
  ]) : _client = client;

  final KefClient _client;
  final String path;
  final String? kefType;

  @override
  Map<String, Object?> parameters() {
    return {
      'path': path,
      'roles': 'value',
    };
  }

  @override
  Future<Map<String, Object?>> get() {
    return _client.getApiValue(this);
  }

  @override
  Map<String, Object?> parseGetData(String string) {
    return kefType != null
        ? jsonDecode(string)[0][kefType]
        : jsonDecode(string)[0];
  }
}

/// API Endpoint to read and write values
class ValueEndpoint<T> extends ApiEndpoint {
  ValueEndpoint(
    KefClient client,
    this.path,
    this.kefType, {
    this.fromString,
  }) : _client = client;

  final KefClient _client;
  final String kefType;
  final String path;
  final T Function(String)? fromString;

  @override
  Map<String, dynamic> parameters([T? value]) {
    return {
      'path': path,
      'roles': 'value',
      if (value != null)
        'value': json.encode(
          {
            'type': kefType,
            kefType:
                fromString != null ? value.toString().split('.').last : value,
          },
        )
    };
  }

  @override
  T parseGetData(String jsonString) {
    var value;

    switch (kefType) {
      case 'string_':
        value = jsonDecode(jsonString)['value'][kefType];
        break;
      default:
        value = jsonDecode(jsonString)[0][kefType];
    }

    if (fromString != null) {
      return fromString!(value);
    } else {
      return value as T;
    }
  }

  T parseSetData(String jsonString) {
    final value = jsonDecode(jsonString)['value'][kefType];
    if (fromString != null) {
      return fromString!(value);
    } else {
      return value as T;
    }
  }

  @override
  Future<T> get() {
    return _client.getApiValue(this);
  }

  Future<T> set(T value) {
    return _client.setApiValue(this, value);
  }
}
