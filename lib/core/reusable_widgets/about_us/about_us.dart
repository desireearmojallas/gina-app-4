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
          'version': '1.0.0',
          'year': DateTime.now().year.toString(),
        },
        applicationLegalese: 'Copyright © My Company, {{ year }}',
        applicationDescription: const Text(
          'Displays an About dialog, which describes the application.',
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
            icon: Icon(Icons.list),
            title: Text('Changelog'),
            filename: 'assets/CHANGELOG.md', // Specify your markdown file path
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
