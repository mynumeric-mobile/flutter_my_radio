import 'package:flutter/material.dart';
import 'package:flutter_minimalist_audio_player/flutter_minimalist_audio_player.dart';
import 'package:flutter_my_radio/objects/my_generic_object.dart';

import '../widget/radio_widget.dart';

class MyRadio extends MyGenericObject {
  //String? name;
  // ignore: non_constant_identifier_names
  String? URL;
  String? stream;
  String? iconURL;
  String? stationUUID;

  ///Languages that are spoken in this stream by code ISO 639-2/B
  List<String> langages = [];
  List<String> tags = [];
  String? country;

  static MyRadio build(Map<String, dynamic> ds, {bool forceHttps = false}) {
    return MyRadio()..fromJson(ds, forceHttps: forceHttps);
  }

  @override
  fromJson(Map<String, dynamic> ds, {bool forceHttps = false}) {
    name = ds["name"];
    URL = ds["homepage"];
    stream = forceHttps ? _forceHTTPS(ds["url_resolved"]) : ds["url_resolved"];
    iconURL = ds["favicon"];
    langages = ds["language"]?.split(",");
    tags = ds["tags"]?.split(",");
    country = ds["country"];
    stationUUID = ds["stationuuid"];
  }

  Widget widget({Function(RadioPlayer)? onStart, Function(RadioPlayer)? onStop}) {
    return RadioWidget(radio: this, onStart: onStart, onStop: onStop);
  }

  /// change http to https
  /// use for old URL correction
  static _forceHTTPS(String? url) {
    if (url == null) return null;
    return url.toLowerCase().replaceAll("http:", "https:");
  }
}

class RadioPlayer extends MiniPlayer {
  MiniPlayer player;

  RadioPlayer(this.player);
}
