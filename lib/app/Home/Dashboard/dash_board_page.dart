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
  final TextEditingController _whereTextController = TextEditingController();
  final TextEditingController _whatTextController = TextEditingController();

  String? payload;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        color: Colors.blueGrey,
        child: Column(
          children: [

            Padding(
              padding: EdgeInsets.only(left: 180, top: 50),
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
                    backgroundColor: MaterialStateProperty.all(Colors.black12),
                    padding:
                        MaterialStateProperty.all(EdgeInsets.only(right: 15)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.horizontal(
                                left: Radius.elliptical(5, 10),
                                right: Radius.elliptical(5, 10)),
                            side: BorderSide(color: Colors.transparent)))),
              ),
            ),
            /*SearchBarWidget(
                whatTextController: _whatTextController,
                whereTextController: _whereTextController),*/
            const SizedBox(
              height: 8.0,
            ),
            SignInButton(
              borderRadius: 20,
              text: 'Search',
              color: primaryGreen,
              textcolor: Colors.white,
              onPressed: () {
                var url =
                    'https://www.mastersportal.com/search/master?kw-what=' +
                        _whatTextController.text +
                        '&kw-where=' +
                        _whereTextController.text;
                /*_search(url);*/
              },
            ),
            buidlCampusStream(),
            SizedBox(height: 10.0),
            buidlHostStream()
          ],
        ),
      ),
    );
  }

  buidlCampusStream() {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Campuses>>(
      stream: database.CampusesStream(),
      builder: (context, snapshot) {
        return ListItemBuilder<Campuses>(
          snapshot: snapshot,
          itembuilder: (context, uni) => Dismissible(
            background: Container(
              color: Colors.red,
            ),
            key: Key('uni-${uni.id}'),
            child: Column(
              children: [
                CampusListTiles(
                    uni: uni,
                    onTap: () {
                      Navigator.of(context, rootNavigator: true)
                          .push(MaterialPageRoute(
                        builder: (context) {
                          return CampusDescriptionTiles(uni: uni, onTap: () {});
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

  Widget _buildContent(BuildContext context) {
    return Container(
      child: Column(
        children: [],
      ),
    );
  }

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
