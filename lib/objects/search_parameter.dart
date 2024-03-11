import 'station_filter_types.dart';

enum OrderType {
  name,
  url,
  homepage,
  favicon,
  tags,
  country,
  state,
  language,
  votes,
  codec,
  bitrate,
  lastcheckok,
  lastchecktime,
  clicktimestamp,
  clickcount,
  clicktrend,
  changetimestamp,
  random
}

class SearchParameters {
  /// name of the attribute the result list will be sorted by
  OrderType order = OrderType.name;

  /// reverse the result list if set to true
  bool reverse = false;

  /// starting value of the result list from the database. For example, if you want to do paging on the server side.
  int offset = 0;

  /// number of returned datarows (stations) starting with offset
  int limit = 100000;

  /// do list/not list broken stations
  bool hidebroken = false;

  Map<String, dynamic> get json {
    return {
      "order": order.name,
      "reverse": reverse.toString(),
      "offset": offset.toString(),
      "limit": limit.toString(),
      "hidebroken": hidebroken.toString()
    };
  }

  String get request {
    var param = [];

    for (MapEntry e in json.entries) {
      param.add("${e.key}=${e.value}");
    }

    return param.join("&");
  }
}

extension FilterTypesExt on StationFilterTypes {
  SearchParameters get getParameters {
    switch (this) {
      default:
        return SearchParameters();
    }
  }
}
