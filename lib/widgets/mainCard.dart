import 'package:flutter/material.dart';
import 'package:versiontracker/widgets/DetailsRow.dart';

class MainCard extends StatelessWidget {
  final List<String> apiName;
  final List<String> apiVersion;
  final List<String> timestamp;
  final Color color;
  final List<String> endpoint;

  MainCard({
    required this.apiName,
    required this.apiVersion,
    required this.timestamp,
    required this.color,
    required this.endpoint,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0.0, 2.0), //(x,y)
            blurRadius: 8.0,
          ),
        ],
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: DetailRow(
          apiName: apiName,
          apiVersion: apiVersion,
          timestamp: timestamp,
          color: color,
          endpoint: endpoint,
        ),
      ),
    );
  }
}
