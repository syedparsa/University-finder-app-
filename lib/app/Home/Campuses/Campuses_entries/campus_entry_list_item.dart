
import 'package:dream_university_finder_app/app/Home/models/Campus_Entry_Model.dart';
import 'package:dream_university_finder_app/app/Home/models/Campus_Model.dart';
import 'package:dream_university_finder_app/configuration/helper_list.dart';
import 'package:flutter/material.dart';

import '../../../../common_widgets/course_format.dart';


class CourseEntryListItem extends StatelessWidget {
  const CourseEntryListItem({
    required this.entry,
    required this.camp,
    required this.onTap,
  });

  final campusEntry entry;
  final Campuses camp;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin:const EdgeInsets.symmetric(horizontal: 20),

      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(20),
            boxShadow: shadowlist,),
          margin: const EdgeInsets.only(top: 20),

          child: Row(
            children: <Widget>[
              Expanded(
                child: Stack(

                  children: [
                    Column(
                      children: [

                        _buildContents(context),
                      ],
                    ),

                  ],

                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final dayOfWeek = CourseFormat.dayOfWeek(entry.start);
    final startDate = CourseFormat.date(entry.start);
    final endDate = CourseFormat.date(entry.end);
    final durationFormatted =CourseFormat.Sems(entry.durationIndays);



    final pay = entry.CourseFee * entry.duration;
    final payFormatted = CourseFormat.currency(pay);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(children: <Widget>[
          Text(dayOfWeek, style: const TextStyle(fontSize: 18.0, color: Colors.grey)),
          const SizedBox(width: 15.0),

          if (entry.CourseFee > 0.0) ...<Widget>[
            Expanded(child: Container()),
            Text(
              payFormatted,
              style: TextStyle(fontSize: 16.0, color: Colors.green[700]),
            ),
          ],
        ]),
        Row(children: <Widget>[
          Text('$startDate - $endDate', style: const TextStyle(fontSize: 16.0)),
          Expanded(child: Container()),
          Text(durationFormatted, style: const TextStyle(fontSize: 16.0)),
        ]),
        if (entry.comment.isNotEmpty)
          Text(
            entry.comment,
            style: const TextStyle(fontSize: 12.0),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
      ],
    );
  }
}

class DismissibleEntryListItem extends StatelessWidget {
  const DismissibleEntryListItem({
    this.key,
    this.entry,
    this.onDismissed,
    this.onTap, this.camp,
  });

  @override
  final Key? key;
  final campusEntry? entry;
  final   Campuses? camp;
  final VoidCallback? onDismissed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(color: Colors.red),
      key: key!,
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => onDismissed!(),
      child: CourseEntryListItem(
        entry: entry!,
        camp: camp!,
        onTap: onTap!,
      ),
    );
  }
}
