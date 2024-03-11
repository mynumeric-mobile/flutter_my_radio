import 'dart:convert';
import 'package:basic_utils/basic_utils.dart';
import 'package:flutter_my_radio/objects/my_generic_object.dart';
import 'package:flutter_my_radio/objects/my_radio_codec.dart';
import 'package:flutter_my_radio/objects/my_radio_state.dart';
import 'package:flutter_my_radio/objects/my_radio_tag.dart';
import 'package:http/http.dart' as http;
import '../objects/my_radio.dart';
import '../objects/my_radio_country.dart';
import '../objects/my_radio_language.dart';
import '../objects/search_parameter.dart';

enum RadioListTypes { countries, codec, state, languages, tags, stations }

enum StationFilterTypes {
  byuuid,
  byname,
  bynameexact,
  bycodec,
  bycodecexact,
  bycountry,
  bycountryexact,
  bycountrycodeexact,
  bystate,
  bystateexact,
  bylanguage,
  bylanguageexact,
  bytag,
  bytagexact
}

class MyRadioTools {
  /// Radio browser API
  /// https://api.radio-browser.info/
  ///

  List<String> apiUrls = ["nl1.api.radio-browser.info", "de1.api.radio-browser.info", "al1.api.radio-browser.info"];

  int serverIndex = 0;

  int retryLimit = 3;

  final String clientName = "flutter_my_radio/1.0";
  final String outputType = "json";

  Future<List<String>> updateRadioBrowserApiUrls() async {
    // Get fastest ip of dns
    String baseUrl = "all.api.radio-browser.info";

    List<RRecord>? aRecs = await DnsUtils.lookupRecord(baseUrl, RRecordType.A, dnssec: false, provider: DnsApiProvider.GOOGLE);

    if (aRecs == null) return [];

    List<String> result = [];

    for (var a in aRecs) {
      var name = await DnsUtils.reverseDns(a.data);

      if (name != null) {
        var url = name.first.data;
        result.add(url.substring(0, url.length - 1)); //remove end point
      }
    }

    apiUrls = result;

    return result;
  }

  String get srvUrl {
    serverIndex++;
    if (serverIndex == apiUrls.length) serverIndex = 0;
    return "https://${apiUrls[serverIndex]}/$outputType";
  }

  Future<List<MyRadio>> findRadio(String keyword, StationFilterTypes filterType,
      {bool forceHttps = false, SearchParameters? parameters, int retryAttempt = 0}) async {
    String strUrl = "$srvUrl/stations/${filterType.name}/$keyword?${parameters?.request ?? ""}";

    var url = Uri.parse(strUrl);

    try {
      http.Response response = await http.get(url, headers: {"User-Agent": clientName});
      var ds = json.decode(response.body);
      List<MyRadio> radios = [];
      for (var r in ds) {
        radios.add(MyRadio.build(r, forceHttps: forceHttps));
      }

      return radios;
    } catch (e) {
      retryAttempt++;
      if (retryAttempt == retryLimit) rethrow;

      return findRadio(keyword, filterType, forceHttps: forceHttps, parameters: parameters, retryAttempt: retryAttempt);
    }
  }

  Future<List<MyGenericObject>> getList(String keyword, RadioListTypes listType,
      {bool forceHttps = false, SearchParameters? filter, int retryAttempt = 0}) async {
    String strUrl = "$srvUrl/${listType.name}/$keyword?${filter?.request ?? ""}";

    var url = Uri.parse(strUrl);

    try {
      http.Response response = await http.get(url, headers: {"User-Agent": clientName});
      var ds = json.decode(response.body);
      List<MyGenericObject> oList = [];
      for (var r in ds) {
        oList.add(listType.toObject(r));
      }
      return oList;
    } catch (e) {
      retryAttempt++;
      if (retryAttempt == retryLimit) rethrow;

      return getList(keyword, listType, forceHttps: forceHttps, filter: filter, retryAttempt: retryAttempt);
    }
  }

  /// Increase the click count of a station by one.
  /// This should be called everytime when a user starts playing a stream to mark the stream more popular than others.
  ///  Every call to this endpoint from the same IP address and for the same station only gets counted once per day.
  ///  The call will return detailed information about the stream, supported output formats: JSON, XML ,PLS ,M3U
  ///
  Future<bool> addClick(String stationUUID) async {
    var url = Uri.parse("$srvUrl/url/$stationUUID");

    http.Response response = await http.get(url, headers: {"User-Agent": clientName});
    var ds = json.decode(response.body);
    return ds["ok"] == "true";
  }
}

extension ListTypesExtension on RadioListTypes {
  MyGenericObject toObject(ds) {
    switch (this) {
      case RadioListTypes.countries:
        return RadioCountry.build(ds);
      case RadioListTypes.codec:
        return RadioCodec.build(ds);
      case RadioListTypes.state:
        return RadioState.build(ds);
      case RadioListTypes.languages:
        return RadioLanguage.build(ds);
      case RadioListTypes.tags:
        return RadioTag.build(ds);
      case RadioListTypes.stations:
        return MyRadio.build(ds);
    }
  }
}
