import 'dart:convert';
import 'package:http/http.dart' as http;

class AzureDevOpsService {
  final String organization;
  final String project;
  final String variableGroupId;
  final String personalAccessToken;

  AzureDevOpsService({
    required this.organization,
    required this.project,
    required this.variableGroupId,
    required this.personalAccessToken,
  });

  Future<String?> fetchVariableValue(String variableName) async {
    final String url =
        'https://dev.azure.com/$organization/$project/_apis/distributedtask/variablegroups/$variableGroupId?api-version=6.0-preview.2';
    final String basicAuth =
        'Basic ' + base64Encode(utf8.encode(':$personalAccessToken'));

    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': basicAuth},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      final variable = data['variables']?[variableName];
      if (variable != null && variable['value'] != null) {
        return variable['value'];
      } else {
        throw Exception('Variable not found or has no value');
      }
    } else {
      throw Exception('Failed to load variable group values');
    }
  }
}
