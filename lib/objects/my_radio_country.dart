import 'package:flutter_my_radio/objects/my_generic_object.dart';

class RadioCountry extends MyGenericObject {
  String? iso;

  static RadioCountry build(Map<String, dynamic> ds,
      {bool forceHttps = false}) {
    return RadioCountry()..fromJson(ds);
  }

  @override
  fromJson(Map<String, dynamic> ds, {bool forceHttps = false}) {
    var o = super.fromJson(ds) as RadioCountry;

    o.iso = ds["iso_3166_1"];

    return o;
  }
}
