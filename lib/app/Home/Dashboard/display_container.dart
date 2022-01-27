
import 'package:dream_university_finder_app/configuration/helper_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class DisplayContainer extends StatelessWidget {
  const DisplayContainer( {Key? key}) : super(key: key);




  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 240,
        margin:const EdgeInsets.symmetric(horizontal: 20),
        child: Row(

          children: [
            Expanded(child:
            Stack(

              children: [
                Container(
                  decoration: BoxDecoration(color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: shadowlist,),
                  margin: const EdgeInsets.only(top: 40),



                ),

              ],

            ),


            ),
            Expanded(child: Container(
              margin: const EdgeInsets.only(top: 60,bottom: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: shadowlist,
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),)

              ),
            ),),
         const SizedBox(height: 50),

          ],

        ),



      ),
    );
  }
}
