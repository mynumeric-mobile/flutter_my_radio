import 'package:flutter/material.dart';
import 'package:flutter_minimalist_audio_player/flutter_minimalist_audio_player.dart';
import 'package:url_launcher/url_launcher.dart';
import '../objects/my_radio.dart';

class RadioWidget extends StatelessWidget {
  const RadioWidget({super.key, required this.radio, this.onStart, this.onStop, this.beforeStart});
  final MyRadio radio;
  final Function(RadioPlayer)? onStart;
  final Function(RadioPlayer)? onStop;
  final Function(RadioPlayer)? beforeStart;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(radio.name ?? "inconnu")),
          MinimalistAudioPlayer(
              media: radio.stream,
              beforeStart: (p) {
                return beforeStart?.call(RadioPlayer(p));
              },
              onStart: (p) {
                onStart?.call(RadioPlayer(p));
              },
              onStop: (p) {
                onStop?.call(RadioPlayer(p));
              }),
        ],
      ),
      minLeadingWidth: 0,
      isThreeLine: true,
      minVerticalPadding: 0,
      contentPadding: EdgeInsets.zero,
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
              width: 40,
              height: 40,
              child: radio.iconURL == null
                  ? const Icon(Icons.radio)
                  : GestureDetector(
                      onTap: () {
                        if (radio.URL != null) _launchInBrowser(Uri.parse(radio.URL!));
                      },
                      child: Image.network(
                        headers: const {"accept": "*/*"},
                        radio.iconURL!,
                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                          return const Icon(Icons.radio);
                        },
                      ),
                    )),
        ],
      ),
      subtitle: Text(radio.tags.join(", "), style: const TextStyle().copyWith(color: Theme.of(context).colorScheme.primary)),
    );
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }
}
