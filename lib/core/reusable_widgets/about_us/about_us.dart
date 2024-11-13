import 'package:flutter/material.dart';
import 'package:about/about.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gina_app_4/core/resources/images.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger the About page dialog immediately after widget build
    Future.microtask(() {
      showAboutPage(
        context: context,
        values: {
          'version': '2.0.0',
          'year': '2024',
          'author': 'Desiree Armojallas'
        },
        applicationLegalese: 'Copyright © {{ author }}, {{ year }}',
        applicationDescription: const Text(
          'This is a capstone project presented at the University of San Jose-Recoletos, in compliance with the Capstone Subject, showcasing the application.',
          textAlign: TextAlign.center,
        ),
        applicationIcon: SizedBox(
          width: 100,
          height: 100,
          child: SvgPicture.asset(
            Images.appLogo,
            width: 100,
            height: 100,
          ),
        ),
        children: const <Widget>[
          MarkdownPageListTile(
            filename: 'README.md',
            title: Text('View Readme'),
            icon: Icon(Icons.all_inclusive),
          ),
          MarkdownPageListTile(
            icon: Icon(Icons.list),
            title: Text('Changelog'),
            filename: '', // Specify your markdown file path
          ),
          MarkdownPageListTile(
            filename: 'CONTRIBUTING.md',
            title: Text('Contributing'),
            icon: Icon(Icons.share),
          ),
          MarkdownPageListTile(
            filename: 'CODE_OF_CONDUCT.md',
            title: Text('Code of conduct'),
            icon: Icon(Icons.sentiment_satisfied),
          ),
          LicensesPageListTile(
            icon: Icon(Icons.favorite),
          ),
        ],
      ).then((_) {
        // Close the current page and return to the previous screen after the dialog is closed
        Navigator.of(context).pop();
      });
    });

    // Return an empty container that does not interfere with the navigation stack
    return const SizedBox();
  }
}
