import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

class ForumScreenLoaded extends StatelessWidget {
  const ForumScreenLoaded({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final ginaTheme = Theme.of(context);

    return Scaffold(
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Container(
              width: width * 0.94,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 20,
                        ),
                        const Gap(10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Chona Mae Taas',
                              style: ginaTheme.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Posted 5 hours ago',
                              style: ginaTheme.textTheme.bodySmall?.copyWith(
                                color: GinaAppTheme.lightOutline,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Gap(10),
                    Text(
                      'I just had my first period and I\'m really anxious about it. What should I do?',
                      style: ginaTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                    const Gap(10),
                    SizedBox(
                      width: width * 0.9,
                      child: Text(
                        "I'm so anxious about my first period. I've heard so many horror stories from other girls about how painful and embarrassing it can be. I'm worried about leaking blood, getting cramps, and smelling bad. I'm also worried about what other people will think of me now that I'm a woman.",
                        style: ginaTheme.textTheme.labelMedium,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    const Row(
                      children: [
                        Icon(Icons.comment),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
