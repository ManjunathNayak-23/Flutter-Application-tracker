import 'package:flutter/material.dart';
import 'package:versiontracker/widgets/detailCard.dart';

class DetailRow extends StatelessWidget {
  final List<String> apiName;
  final List<String> apiVersion;
  final List<String> timestamp;
  final List<String> endpoint;
  final Color color;

  const DetailRow({
    required this.apiName,
    required this.apiVersion,
    required this.timestamp,
    required this.color,
    required this.endpoint,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0, // Space between items horizontally
      runSpacing: 12.0, // Space between items vertically
      alignment: WrapAlignment.spaceEvenly,

      children: List.generate(apiName.length, (index) {
        return DetailCard(
          apiName: apiName[index],
          apiVersion: apiVersion[index],
          timestamp: timestamp[index],
          color: color,
          endpoints: endpoint[index],
        );
      }).toList(),
    );
  }
}
