
import 'package:dream_university_finder_app/app/Home/Campuses/Empty_Content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef ItemWidgetbuilder<T>=Widget Function(BuildContext context,T items);
class ListItemBuilder<T> extends StatelessWidget {
  const ListItemBuilder({Key? key,  required this.snapshot,  required this.itembuilder}) : super(key: key);
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetbuilder<T> itembuilder;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData){
     final List<T> items=snapshot.data!;
     print(items);
     if (items.isNotEmpty){

      return Expanded(child: _buildList(items));
     }else {

       return const EmptyContent();
     }
    } else if(snapshot.hasError){
    print(snapshot.error.toString());
    return const EmptyContent(
      title: 'Something went wrong ',
      message: 'Can\'t load the items right now',
    );
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildList(List<T> items){

   return ListView.separated(
     separatorBuilder: (context,index)=>const Divider(height: 0.5),
       itemCount:items.length+2,
     itemBuilder: (context,index){
       if (index==0 || index==items.length+1)
       {
         return Container();
       }
       return itembuilder(context,items[index-1]);
    },
    );
  }

}

