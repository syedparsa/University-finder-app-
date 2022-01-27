import 'package:dream_university_finder_app/app/Home/models/Job.dart';
import 'package:flutter/material.dart';
class JobListTiles extends StatelessWidget {
  final Job job;
  final VoidCallback onTap;
  const JobListTiles({Key? key, required this.job, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(

      title: Text(job.name),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
