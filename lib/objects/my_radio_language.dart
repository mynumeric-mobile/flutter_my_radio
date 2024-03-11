import 'package:flutter_my_radio/objects/my_generic_object.dart';

class RadioLanguage extends MyGenericObject {
  String? iso;

  static RadioLanguage build(Map<String, dynamic> ds, {bool forceHttps = false}) {
    return RadioLanguage()..fromJson(ds);
  }

  @override
  fromJson(Map<String, dynamic> ds, {bool forceHttps = false}) {
    super.fromJson(ds);
    iso = ds["iso_639"];
  }
}
