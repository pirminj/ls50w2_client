import 'package:kef_ls50w2_client/kef_ls50w2_client.dart';

void main() async {
  final speaker = KefClient('192.168.0.149');

  // // Select an input source
  // await speaker.setSource(SpeakerSource.optic);
  // print('The speaker volumne is at ${await speaker.getVolume()}');
  // await speaker.nextTrack();
  // sleep(Duration(seconds: 5));
  // await speaker.togglePlayPause();

  // final r = await speaker.wallMode.set(true);

  // print(r);
  // print(await speaker.bassExtension.get());

  // print(await speaker.masterChannelMode.get());
}
