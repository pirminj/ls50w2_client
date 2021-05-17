/// The speakers power status
enum SpeakerStatus {
  standby,
  powerOn,
}

/// The speakers input source
enum SpeakerSource {
  standby,
  wifi,
  bluetooth,
  tv,
  optic,
  coaxial,
  analog,
}

/// Controls for the music player
enum PlayerControl {
  pause, // play/pause toggle
  next,
  previous,
}

enum BassExtension {
  less,
  standard,
  extra,
}

enum MasterChannelMode {
  left,
  right,
}

extension ConvertSpeakerStatus on SpeakerStatus {
  String get name => toString().split('.').last;
}

extension ConvertSpeakerSource on SpeakerSource {
  String get name {
    switch (this) {
      case SpeakerSource.standby:
        return 'Standby';
      case SpeakerSource.wifi:
        return 'Wi-Fi';
      case SpeakerSource.bluetooth:
        return 'Bluetooth';
      case SpeakerSource.tv:
        return 'TV';
      case SpeakerSource.optic:
        return 'Optical';
      case SpeakerSource.coaxial:
        return 'COAX';
      case SpeakerSource.analog:
        return 'AUX';
    }
  }
}

extension ConvertPlayerControl on PlayerControl {
  String get name => toString().split('.').last;
}

extension ConvertBassExtension on BassExtension {
  String get name => toString().split('.').last;
}

/// Helper function to get enum values from a string.
///
/// Returns a function which takes a string and returns one corresponding enum
/// value from [options]
///
/// ```
/// enumFromString(SpeakerSource.values)('wifi') // returns SpeakerSource.wifi
/// ```
T Function(String) enumFromString<T>(List<T> options) =>
    (string) => options.singleWhere(
          (option) => option.toString().contains(string),
        );
