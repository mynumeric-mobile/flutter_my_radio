import 'package:flutter_my_radio/objects/my_generic_object.dart';

class RadioTag extends MyGenericObject {
  static RadioTag build(Map<String, dynamic> ds, {bool forceHttps = false}) {
    return RadioTag()..fromJson(ds);
  }

  @override
  fromJson(Map<String, dynamic> ds, {bool forceHttps = false}) {
    return super.fromJson(ds) as RadioTag;
  }
}
