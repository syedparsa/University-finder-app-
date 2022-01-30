import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dream_university_finder_app/Services/Database.dart';
import 'package:dream_university_finder_app/app/Home/Campuses/Campus_List_Tiles.dart';
import 'package:dream_university_finder_app/app/Home/Campuses/List_Items_Builder.dart';
import 'package:dream_university_finder_app/app/Home/Description_Page/Campus_Description_Tiles.dart';
import 'package:dream_university_finder_app/app/Home/Description_Page/Hosts_Descriptions_Tiles.dart';
import 'package:dream_university_finder_app/app/Home/Hosts/Host_List_Tiles.dart';
import 'package:dream_university_finder_app/app/Home/Notifications/AwesomeNotificationsService.dart';
import 'package:dream_university_finder_app/app/Home/models/Campus_Model.dart';
import 'package:dream_university_finder_app/app/Home/models/Host_Models.dart';
import 'package:dream_university_finder_app/common_widgets/sign_in/sign_in_Button.dart';
import 'package:dream_university_finder_app/configuration/helper_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key, this.camp, this.host}) : super(key: key);
  final Campuses? camp;
  final Hosts? host;

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? payload;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildHostStream(context),
    );
  }

  /* buidlCampusStream() {
    return  StreamBuilder<List<Campuses>>(
      stream: CampusStream,
      builder: (context, snapshot) {
        return NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool scrolling) {
            return <Widget>[TopScrollableBar(), SearchScrollablebar()];
          },
          body: ListItemBuilder(
              snapshot: snapshot,
              itembuilder: (context, uni) {
                return CampusListTiles(
                  uni: uni as Campuses,
                  onTap: ()=>CampusDescriptionTiles(
                    uni:uni, onTap: () {  },
                  ),
                );
              }),
        );
      },
    );
  }

  buidlHostStream() {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Hosts>>(
      stream: database.HostsStream(),
      builder: (context, snapshot) {
        return ListItemBuilder<Hosts>(
          snapshot: snapshot,
          itembuilder: (context, host) => Dismissible(
            background: Container(
              color: Colors.red,
            ),
            key: Key('host-${host.id}'),
            child: Column(
              children: [
                HostsTiles(
                    host: host,
                    onTap: () {
                      Navigator.of(context, rootNavigator: true)
                          .push(MaterialPageRoute(
                        builder: (context) {
                          return HostDescriptionTiles(host: host, onTap: () {});
                        },
                      ));
                    }),
              ],
            ),
          ),
        );
      },
    );
  }
*/
  _Alertcall() {
    AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) {
        if (isAllowed) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Allow Notifications'),
              content: Text('Our app would like to send you notifications'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Don\'t Allow',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ),
                TextButton(
                  onPressed: () => {
                    AwesomeNotificationService.createEducationFoodNotification(
                        context),
                    Navigator.pop(context) as Navigator,
                  },
                  child: Text(
                    'Allow',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  TextEditingController SearchController = TextEditingController();

  Stream<List<Campuses>> CampusStream = Stream.value([]);

  SearchByCampuses _sortByCampus = SearchByCampuses.name;
  bool ascendingSorting = true;

  @override
  void initState() {
    super.initState();
    final database = Provider.of<Database>(context, listen: false);

    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      var Favourite = await database.CampusesStream().first;

      if (mounted)
        setState(() {
          CampusStream = database.CampusesStream();
        });
    });
  }

  Widget _buildHostStream(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return Container(
      color: Colors.blueGrey.shade300,
      child: StreamBuilder<List<Hosts>>(
        stream: database.HostsStream(),
        builder: (context, snapshot) {
          return NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool scrolling) {
              return <Widget>[TopScrollableBar(), SearchScrollablebar()];
            },
            body: ListItemBuilder(
                snapshot: snapshot,
                itembuilder: (context, host) {
                  return HostsTiles(
                    host: host as Hosts,
                    onTap: () => HostDescriptionTiles(
                      host: host,
                      onTap: () {},
                    ),
                  );
                }),
          );
        },
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    return Container(
      color: Colors.blueGrey.shade300,
      child: StreamBuilder<List<Campuses>>(
        stream: CampusStream,
        builder: (context, snapshot) {
          return NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool scrolling) {
              return <Widget>[TopScrollableBar(), SearchScrollablebar()];
            },
            body: ListItemBuilder(
                snapshot: snapshot,
                itembuilder: (context, uni) {
                  return CampusListTiles(
                    uni: uni as Campuses,
                    onTap: () => CampusDescriptionTiles(
                      uni: uni,
                      onTap: () {},
                    ),
                  );
                }),
          );
        },
      ),
    );
  }

  SliverAppBar TopScrollableBar() {
    return SliverAppBar(
      backgroundColor: Colors.blueGrey.shade300,
      floating: false,
      elevation: 0,
      flexibleSpace: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return FlexibleSpaceBar(
          collapseMode: CollapseMode.none,
          background: Padding(
            padding: EdgeInsets.fromLTRB(180, 50, 20, 20),
            child: ElevatedButton.icon(
              onPressed: () => _Alertcall(),
              icon: Icon(
                Icons.add_alert,
                color: Colors.red.shade600,

              ),
              label: Text(
                'Set Alert',
                style: TextStyle(fontSize: 15),
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
                  padding:
                      MaterialStateProperty.all(EdgeInsets.only(left: 10,right: 10)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.elliptical(5, 5),
                              right: Radius.elliptical(5, 5)),
                          side: BorderSide(color: Colors.transparent)))),
            ),
          ),
        );
      }),
    );
  }

  _filterStream(String value) async {
    value = value.trim();

    final db = Provider.of<Database>(context, listen: false);

    var attractions = await db.CampusesStream().first;
    var filteredPlaces = attractions
        .where((element) =>
            element.name!.toLowerCase().contains(value.toLowerCase()) ||
            element.address!.toLowerCase().contains(value.toLowerCase()) ||
            (element.country != null &&
                element.country!.contains(value.toLowerCase())) ||
            element.countrycode!.toLowerCase().contains(value.toLowerCase()) ||
            (element.url != null &&
                element.details!.length > 0 &&
                element.website!.contains(value.toLowerCase())) ||
            (element.city != null &&
                element.city!.toLowerCase().contains(value.toLowerCase())))
        .toList();
    setState(() {
      CampusStream = Stream.value(filteredPlaces);
    });
    //_streamController.sink.add(filteredPlaces);
  }

  _sortData() async {
    final db = Provider.of<Database>(context, listen: false);
    var searchAble = await db.CampusesStream().first;
    searchAble.sort((a, b) {
      int value = 0;

      switch (_sortByCampus) {
        case SearchByCampuses.name:
          value = a.name == null || b.name == null
              ? 0
              : a.name!.toLowerCase().compareTo(b.name!.toLowerCase());
          break;

        case SearchByCampuses.country:
          value = a.country == null || b.country == null
              ? 0
              : a.country!.toLowerCase().compareTo(b.country!.toLowerCase());
          break;
      }
      return ascendingSorting ? value : -1 * value;
    });
    Navigator.pop(context);
    setState(() {
      CampusStream = Stream.value(searchAble);
    });
  }

  SliverAppBar SearchScrollablebar() {
    return SliverAppBar(
      backgroundColor: Colors.blueGrey.shade300,
      pinned: true,
      title: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.withOpacity(1.0),
                offset: const Offset(1.1, 1.1),
                blurRadius: 5.0),
          ],
        ),
        child: CupertinoTextField(
          controller: SearchController,
          keyboardType: TextInputType.text,
          onChanged: (value) {
            WidgetsBinding.instance?.addPostFrameCallback((_) async {
              await _filterStream(value);
            });
          },
          placeholder: 'Search here ',
          placeholderStyle: TextStyle(
            color: Color(0xffC4C6CC),
            fontSize: 14.0,
            fontFamily: 'Brutal',
          ),
          prefix: Padding(
            padding: const EdgeInsets.fromLTRB(5.0, 5.0, 10, 5.0),
            child: Icon(
              Icons.search,
              size: 22,
              color: Colors.black,
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.white,
          ),
          suffix: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 1, 0),
            child: IconButton(
              icon: Icon(
                Icons.settings,
                size: 22,
                color: Colors.black,
              ),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    elevation: 4.0,
                    builder: (context) {
                      return StatefulBuilder(builder: (context, setState) {
                        return Container(
                          height: 130,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 20, 23, 0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'filtered Results ',
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 22,
                                        ),
                                      ),
                                      Checkbox(
                                        value: ascendingSorting,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            ascendingSorting = value!;
                                          });
                                          _sortData();
                                        },
                                      ),
                                      Text('swipe right to choose filter')
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 30, 0),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Radio(
                                                  value: SearchByCampuses.name,
                                                  groupValue: _sortByCampus,
                                                  onChanged: (SearchByCampuses?
                                                      value) {
                                                    setState(() {
                                                      _sortByCampus = value!;
                                                    });
                                                    _sortData();
                                                  },
                                                ),
                                                Text('Name')
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Radio(
                                                  value:
                                                      SearchByCampuses.country,
                                                  groupValue: _sortByCampus,
                                                  onChanged: (SearchByCampuses?
                                                      value) {
                                                    setState(() {
                                                      _sortByCampus = value!;
                                                    });
                                                    _sortData();
                                                  },
                                                ),
                                                Text('Country')
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                    });
              },
            ),
          ),
        ),
      ),
    );
  }

/*_search(String url) async {
    // final response = await http.Client().get(Uri.parse('https://www.mastersportal.com/search/master?kw-what=computer&kw-where=Pakistan'));
    // print(response.statusCode);
//     if (response.statusCode == 200) {
//       var doc = parser.parse(response.body);
//       var elements = doc.getElementsByClassName('SearchResultsList');
//       print('hasan');
// print(elements);
//       for (var element in elements) {
//         print('zeeshu');
//         print(element);
//         var a =element.children[0].children[0].children[0].children[0].text;
//         print(a);
//         break;
//       }
//     }
//     var parser = await Chaleno().load('https://www.mastersportal.eu/');
//     final title = parser?.getElementById('Internal');
//     print(title?.html);
//     var h = parser?.querySelector(
//         'div > main > div > div > div > div > article > section > ul > li:nth-child(1) > a');
//     print(h!.href);
  }*/
}
