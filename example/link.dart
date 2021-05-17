import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import 'package:kef_ls50w2_client/kef_ls50w2_client.dart';

void main() async {
  final speaker = KefClient('192.168.0.149');

  final data = await speaker.playerData.get();

  // final title = data['trackRoles']['title'];
  // final id = data['trackRoles']['id'];
  // final uri = data['trackRoles']['mediaData']['resources'][0]['uri'];

  // print(uri);

  // final response = await Client().get(Uri.parse(uri));

  // await File('M:\\Music\\Greta Van Fleet\\${id}_$title.flac')
  //     .writeAsBytes(response.bodyBytes);
}
