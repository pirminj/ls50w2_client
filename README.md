Connect to and control your KEF LS50 Wireless 2 from Dart and Flutter

> For now, this package is just an experiment and under heavy development. Feel free to discuss and contribute!

> Heavily inspired by [pykefcontrol](https://github.com/rodupont/pykefcontrol) and this post in the [Roon community forum](https://community.roonlabs.com/t/ls50-wireless-ii-home-automation/154388/11?u=pirminj), since there's now official API from KEF (yet ✌)

## Usage

A simple usage example:

```dart
import 'package:kef_ls50w2_client/kef_ls50w2_client.dart';

main() async {
  final speaker = KefClient('192.168.0.149');

  // Select an input source
  await speaker.setSource(SpeakerSource.optic);
  print('The speaker volume is at ${await speaker.getVolume()}');
  await speaker.nextTrack();
  sleep(Duration(seconds: 5));
  await speaker.togglePlayPause();
}
```

## Features and bugs

Please file feature requests and bugs at the issue tracker

## License

This project is licensed under the terms of the MIT license found in the `LICENSE.md` file
