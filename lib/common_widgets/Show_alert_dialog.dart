
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<dynamic>? ShowAlertDailog(
 BuildContext context,{
   String? cancelActiontext,
 required String defaultActionText,
 required String title,
 required String? content,}
 )
{
if(!Platform.isIOS){
   return showDialog(
       context: context,
       builder: (context) => AlertDialog(
         title: Text(title),
       content: Text(content!),
         actions: <Widget>
         [
           if (cancelActiontext != null)
             FlatButton(
                 onPressed: ()=>Navigator.of(context).pop(false),
                 child:Text(cancelActiontext),
             ),
           FlatButton(
               onPressed:()=>Navigator.of(context).pop(true),
               child: Text(defaultActionText),
               ),
         ],
       ),
   );
}
return showCupertinoDialog(
  context: context,
  builder: (context) => CupertinoAlertDialog(
    title: Text(title),
    content: Text(content!),
    actions: <Widget>[
      if (cancelActiontext != null)
        CupertinoDialogAction(
          onPressed: ()=>Navigator.of(context).pop(false),
          child:Text(cancelActiontext),
        ),
      CupertinoDialogAction(
        onPressed:()=>Navigator.of(context).pop(true),
        child: Text(defaultActionText),
      ),
    ],
  ),
);
}
