import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ssl_checker/ssl_checker.dart';

class StatusIcon extends StatefulWidget {
  final String endpoint;

  StatusIcon({required this.endpoint});

  @override
  _StatusIconState createState() => _StatusIconState();
}

class _StatusIconState extends State<StatusIcon> {
  Color _iconColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    _checkEndpoint();
  }

  Future<void> _checkEndpoint() async {
    try {
      final response = await http.get(Uri.parse("https://${widget.endpoint}"));
      if (!mounted) return;
      setState(() {
        if (response.statusCode == 200) {
          _iconColor = Colors.green;
        } else {
          _iconColor = Colors.red;
        }
      });
    } catch (e) {
      print(e);
      if (!mounted) return;
      setState(() {
        _iconColor = Colors.red;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.circle,
      color: _iconColor,
      size: 12.0,
    );
  }
}

// class SslDurationChecker extends StatefulWidget {
//   final String endpoint;

//   SslDurationChecker({required this.endpoint});

//   @override
//   _SslDurationCheckerState createState() => _SslDurationCheckerState();
// }

// class _SslDurationCheckerState extends State<SslDurationChecker> {
//   int remainingDays = 0;

//   @override
//   void initState() {
//     super.initState();
//     fetchSSLExpiry();
//   }

//   Future<void> fetchSSLExpiry() async {
//     try {
//       SslCheckResult response = await sslChecker(widget.endpoint);
//       print(response);
//       DateTime expiryDate = response.certificate!.endValidity;
//       DateTime now = DateTime.now();
//       Duration remaining = expiryDate.difference(now);
//       if (!mounted) return;
//       setState(() {
//         remainingDays = remaining.inDays;
//       });
//     } catch (e) {
//       print('Error fetching SSL certificate information: $e');
//       // Handle error as needed
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Text("$remainingDays");
//   }
// }

class DetailCard extends StatelessWidget {
  final String apiName;
  final String apiVersion;
  final String timestamp;
  final Color color;
  final String endpoints;

  const DetailCard({
    required this.apiName,
    required this.apiVersion,
    required this.timestamp,
    required this.color,
    required this.endpoints,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: color,
            offset: Offset(0.0, 2.0),
            blurRadius: 6.0,
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                apiName.toUpperCase(),
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 8),
              StatusIcon(endpoint: endpoints),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "v$apiVersion",
            style: const TextStyle(
              color: Color.fromARGB(255, 0, 82, 95),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            timestamp,
            style: const TextStyle(
              color: Colors.blueGrey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          // SslDurationChecker(endpoint: endpoints),
        ],
      ),
    );
  }
}
