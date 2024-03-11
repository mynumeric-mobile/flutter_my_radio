import 'package:flutter_my_radio/objects/my_generic_object.dart';

class RadioState extends MyGenericObject {
  String? country;

  static RadioState build(Map<String, dynamic> ds, {bool forceHttps = false}) {
    return RadioState()..fromJson(ds);
  }

  @override
  fromJson(Map<String, dynamic> ds, {bool forceHttps = false}) {
    var o = super.fromJson(ds) as RadioState;

    o.country = ds["country"];

    return o;
  }
}
