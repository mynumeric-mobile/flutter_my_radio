# flutter_my_radio

**flutter_my_radio provide an easy way to find and listen any web radio in you flutter app.**

This plugin is flutter client for <a href="https://www.radio-browser.info/">radio-browser api</a>.

Radio-browser is a database of internet radios. It allows you to search for radios using numerous criteria: name, tags, countries, languages.

There is a lot of metadata, including stream urls, site urls and other indications.




## Usage

### Do a search:

Start by declaring a MyRadioTools object

`class _MyAppState extends State<MyApp> {
MyRadioTools radioTools = MyRadioTools();
...`

Simply do a search specifying the keyword and search type:

`radios=await radioTools.findRadio("Europe 1", StationFilterTypes.byname,);`

The plugin automatically generates a widget for each radio found:

`radios![index].widget()`

 the search can be constrained by parameters: limit, offset, order
To do this, create a SearchParameters object and specify your parameters:

`var p = StationFilterTypes.byname.getParameters;
p.limit=10 ;`

Then simply specify the SearchParameters object thus created in your search:

`radios=await radioTools.findRadio("Europe 1", StationFilterTypes.byname,parameters:p);`


### Update statistics:

Radio-browser offers, among other things, a click count to find out the popularity of a radio station. Each time you read it, it is important to use the following command to update it:

`radioTools.addClick(radios![index].stationUUID!);`


### Get possible values:

You can also get lists of values ​​for example languages:

`var lst = await radioTools.getList("", RadioListTypes.languages);`

### Conclusion

the API is documented <a href="https://docs.radio-browser.info/#introduction"> here</a>

Have a look at exemple folder for details

<a href="https://my-numeric.com">Powered by My-Numeric.com</a>
