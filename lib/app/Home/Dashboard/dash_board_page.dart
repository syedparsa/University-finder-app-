import 'package:dream_university_finder_app/Services/Database.dart';
import 'package:dream_university_finder_app/app/Home/Campuses/Campus_List_Tiles.dart';
import 'package:dream_university_finder_app/app/Home/Campuses/List_Items_Builder.dart';
import 'package:dream_university_finder_app/app/Home/Dashboard/Search_bar_widget.dart';
import 'package:dream_university_finder_app/app/Home/Description_Page/Descriptions.dart';

import 'package:dream_university_finder_app/app/Home/models/Campus_Model.dart';
import 'package:dream_university_finder_app/common_widgets/sign_in/sign_in_Button.dart';
import 'package:dream_university_finder_app/configuration/helper_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatelessWidget {

  DashboardPage({Key? key, this.camp,  this.payload}) : super(key: key);
  final TextEditingController _whereTextController = TextEditingController();
  final TextEditingController _whatTextController = TextEditingController();
  final  Campuses? camp;
  final String? payload;


  Widget _buildContent(BuildContext context) {
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
            child: UniListTiles(
              uni: uni,
              onTap: () => Descriptions.show(context,uni),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blueGrey,
        child: Column(
          children: [
            SearchBarWidget(
                whatTextController: _whatTextController,
                whereTextController: _whereTextController),
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
                _search(url);
              },
            ),
            const SizedBox(height: 100.0),
            _buildContent(context),
          ],
        ),
      ),
    );
  }

  _search(String url) async {
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
  }
}
