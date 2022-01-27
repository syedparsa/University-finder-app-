import 'package:dream_university_finder_app/app/Home/models/Host_Models.dart';
import 'package:dream_university_finder_app/configuration/helper_list.dart';
import 'package:flutter/material.dart';
class HostsTiles extends StatelessWidget {

  final Hosts host;

  final VoidCallback onTap;

  const HostsTiles({Key? key, required this.onTap, required this.host,  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

      height: 80,
      margin:const EdgeInsets.symmetric(horizontal: 20),

      child: Material(
        child: InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(color: Colors.blueGrey.shade300,
              borderRadius: BorderRadius.circular(20),
              boxShadow: shadowlist,),
            margin: const EdgeInsets.only(top: 20),

            child: Row(
              children: <Widget>[
                Expanded(child:
                Column(
                  children: [
                    Text(host.name,textAlign: TextAlign.center,style: const TextStyle(
                      fontWeight: FontWeight.w200
                      ,fontSize: 20.0,
                    ),),
                    const Icon(Icons.chevron_right),
                  ],

                ),),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
