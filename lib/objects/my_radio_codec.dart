import 'package:flutter_my_radio/objects/my_generic_object.dart';

class RadioCodec extends MyGenericObject {
  static RadioCodec build(Map<String, dynamic> ds, {bool forceHttps = false}) {
    return RadioCodec()..fromJson(ds);
  }

  @override
  fromJson(Map<String, dynamic> ds, {bool forceHttps = false}) {
    return super.fromJson(ds) as RadioCodec;
  }
}
