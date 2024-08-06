import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:versiontracker/services/azure_devops_service.dart';

import '../widgets/mainCard.dart';

class CCDashboard extends StatefulWidget {
  final AzureDevOpsService azureDevOpsService;
  CCDashboard({super.key})
      : azureDevOpsService = AzureDevOpsService(
          organization: 'org',
          project: 'project',
          variableGroupId: 'id',
          personalAccessToken: 'pat',
        );

  @override
  State<CCDashboard> createState() => _CCDashboardState();
}

class _CCDashboardState extends State<CCDashboard> {
  Map<String, List<String>> processApiData(Map<String, dynamic> apiData) {
    final List<String> apiNames =
        apiData.keys.map<String>((key) => key.toString()).toList();
    final List<String> apiVersions =
        apiNames.map((name) => apiData[name]['version'].toString()).toList();
    final List<String> timestamp =
        apiNames.map((name) => apiData[name]['timestamp'].toString()).toList();
    final List<String> endpoint =
        apiNames.map((name) => apiData[name]['endpoint'].toString()).toList();
    return {
      'names': apiNames,
      'versions': apiVersions,
      'timestamp': timestamp,
      'endpoint': endpoint
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "CheapCaribbean",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0, left: 8.0),
              child: Text(
                "Vacations.",
                style: TextStyle(
                  fontFamily: GoogleFonts.sacramento().fontFamily,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 232, 46, 139),
      ),
      body: FutureBuilder<String?>(
        future: widget.azureDevOpsService.fetchVariableValue("ccversion"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Color.fromARGB(255, 232, 46, 139),
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No variables found'));
          } else {
            final variables = snapshot.data!;
            final jsonData = json.decode(variables);

            final prodApiData =
                processApiData(jsonData[0]["CheapCaribbean"]["prod"]);
            final devApiData =
                processApiData(jsonData[0]["CheapCaribbean"]["Dev"]);
            final pProdApiData =
                processApiData(jsonData[0]["CheapCaribbean"]["preprod"]);
            final qaApiData =
                processApiData(jsonData[0]["CheapCaribbean"]["QA"]);

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "DEV",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  MainCard(
                    apiName: devApiData['names']!,
                    apiVersion: devApiData['versions']!,
                    timestamp: devApiData['timestamp']!,
                    endpoint: devApiData['endpoint']!,
                    color: const Color.fromARGB(255, 232, 46, 139),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  const Text(
                    "QA",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  MainCard(
                    apiName: qaApiData['names']!,
                    apiVersion: qaApiData['versions']!,
                    timestamp: qaApiData['timestamp']!,
                    endpoint: qaApiData['endpoint']!,
                    color: const Color.fromARGB(255, 232, 46, 139),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  const Text(
                    "PreProd",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  MainCard(
                    apiName: pProdApiData['names']!,
                    apiVersion: pProdApiData['versions']!,
                    timestamp: pProdApiData['timestamp']!,
                    endpoint: pProdApiData['endpoint']!,
                    color: const Color.fromARGB(255, 232, 46, 139),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  const Text(
                    "Prod",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  MainCard(
                    apiName: prodApiData['names']!,
                    apiVersion: prodApiData['versions']!,
                    timestamp: prodApiData['timestamp']!,
                    endpoint: prodApiData['endpoint']!,
                    color: const Color.fromARGB(255, 232, 46, 139),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
