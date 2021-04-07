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

extension ConvertSpeakerStatus on SpeakerStatus {
  String name() => toString().split('.').last;
}

extension ConvertSpeakerSource on SpeakerSource {
  String name() => toString().split('.').last;
}

extension ConvertPlayerControl on PlayerControl {
  String name() => toString().split('.').last;
}

SpeakerStatus toSpeakerStatus(String string) => SpeakerStatus.values
    .where((element) => element.toString().contains(string))
    .single;

SpeakerSource toSpeakerSource(String string) => SpeakerSource.values
    .where((element) => element.toString().contains(string))
    .single;
