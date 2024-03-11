import 'package:flutter/material.dart';
import 'package:flutter_my_radio/objects/my_radio.dart';
import 'package:flutter_my_radio/objects/search_parameter.dart';
import 'package:flutter_my_radio/helpers/my_radio_tools.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

enum FilterType { name, strictName, contry, language }

class _MyAppState extends State<MyApp> {
  List<MyRadio>? radios = [];
  var search = SearchController();
  String lastSearch = "";
  ValueNotifier<int?> countListener = ValueNotifier<int?>(null);
  MyRadioTools radioTools = MyRadioTools();
  RadioPlayer? _currentRadio;
  late FilterType filterType;

  @override
  void initState() {
    filterType = FilterType.name;
    radioTools.updateRadioBrowserApiUrls();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My Radio plug-in'),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // ElevatedButton(
              //     onPressed: () async {
              //       var lst = await radioTools.getList("", RadioListTypes.languages);
              //     },
              //     child: const Text("test")),
              Stack(alignment: AlignmentDirectional.topEnd, children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8, left: 8, bottom: 8, top: 13),
                  child: SizedBox(
                    height: 40,
                    child: SearchBar(
                      leading: const Icon(Icons.search),
                      trailing: [menu(context)],
                      controller: search,
                      onSubmitted: (v) {
                        setState(() {});
                      },
                    ),
                  ),
                ),
                countWidget,
              ]),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: FutureBuilder(
                  future: getRadios()..then((value) => countListener.value = value.length),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.deepPurpleAccent,
                        ),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'An ${snapshot.error} occurred',
                            style: const TextStyle(fontSize: 18, color: Colors.red),
                          ),
                        );
                      } else if (snapshot.hasData) {
                        radios = snapshot.data;

                        return radios == null
                            ? const Text("No result found")
                            : ListView.builder(
                                itemCount: radios!.length,
                                itemBuilder: (context, index) {
                                  return radios![index].widget(onStart: (p) {
                                    _currentRadio?.player.stop();
                                    _currentRadio = p;
                                    if (radios![index].stationUUID != null) radioTools.addClick(radios![index].stationUUID!);
                                  }, onStop: (p) {
                                    _currentRadio = null;
                                  });
                                });
                      }
                    }

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget menu(BuildContext context) {
    return MenuAnchor(
      builder: (BuildContext context, MenuController controller, Widget? child) {
        return IconButton(
          onPressed: () {
            controller.isOpen ? controller.close() : controller.open();
          },
          icon: const Icon(Icons.more_horiz),
          tooltip: 'Filter type',
        );
      },
      menuChildren: List<MenuItemButton>.generate(
        FilterType.values.length,
        (int index) => MenuItemButton(
          style: TextButton.styleFrom(
              visualDensity: VisualDensity.compact,
              alignment: AlignmentDirectional.center,
              backgroundColor: FilterType.values[index] == filterType ? Theme.of(context).colorScheme.primary : null),
          onPressed: () => setState(() {
            filterType = FilterType.values[index];
            search.text = lastSearch = "";
            radios?.clear();
          }),
          child: Text(
            ["Name", "Strict name", "Country name", "Language"][index],
            style: const TextStyle()
                .copyWith(color: FilterType.values[index] == filterType ? Theme.of(context).colorScheme.onPrimary : null),
          ),
        ),
      ),
    );
  }

  Future<List<MyRadio>> getRadios() {
    if (lastSearch == search.text) return Future.value(radios);

    SearchParameters? p;
    // searchfilter could be used for advanced filter
    //var p = StationFilterTypes.byname.getParameters;
    //p.limit = 1;

    lastSearch = search.text;
    return search.text == ""
        ? Future.value([])
        : radioTools.findRadio(search.text, filterType.toStationFilter, forceHttps: true, parameters: p);
  }

  Widget get countWidget => ValueListenableBuilder<int?>(
      valueListenable: countListener,
      builder: (context, int? data, child) {
        return Badge(
            isLabelVisible: data != null,
            largeSize: 25,
            label: Container(
                alignment: AlignmentDirectional.center,
                constraints: const BoxConstraints(minWidth: 17),
                child: Text(data.toString(), style: const TextStyle().copyWith(color: Colors.white))));
      });
}

extension FilterExt on FilterType {
  StationFilterTypes get toStationFilter {
    switch (this) {
      case FilterType.name:
        return StationFilterTypes.byname;
      case FilterType.strictName:
        return StationFilterTypes.bynameexact;
      case FilterType.contry:
        return StationFilterTypes.bycountry;
      case FilterType.language:
        return StationFilterTypes.bylanguage;
    }
  }
}
