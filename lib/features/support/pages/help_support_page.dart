import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  void _launchURL(BuildContext context) async {
    final Uri url = Uri.parse('https://help.screencraft.net.au/help/2680392001');

    if (await canLaunchUrl(url)) {
      await launchUrl (url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _launchURL(context),
              child: const Text(
                'Find help and support here',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                )
                ),
            )
          ],
        ),
      ),
    );
  }
}
