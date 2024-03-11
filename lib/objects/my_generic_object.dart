class MyGenericObject {
  String? name;
  int? stationcount;

  fromJson(Map<String, dynamic> ds, {bool forceHttps = false}) {
    name = ds["name"];
    stationcount = ds["stationcount"];
  }
}
