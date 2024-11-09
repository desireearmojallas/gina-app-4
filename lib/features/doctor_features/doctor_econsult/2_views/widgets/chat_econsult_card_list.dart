import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gina_app_4/core/resources/images.dart';
import 'package:gina_app_4/core/reusable_widgets/scrollbar_custom.dart';
import 'package:gina_app_4/core/theme/theme_service.dart';

class ChatEConsultCardList extends StatelessWidget {
  const ChatEConsultCardList({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.6,
      child: RefreshIndicator(
        onRefresh: () async {
          // Add your refresh logic here
          return;
        },
        child: ScrollbarCustom(
          child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: 5, // todo: to change
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      height: 90.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: GinaAppTheme.appbarColorLight,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 28.0,
                                      backgroundImage: AssetImage(
                                        Images.patientProfileIcon,
                                      ),
                                    ),
                                    const Gap(10),
                                    const Column(
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 200,
                                              child: Text(
                                                'Desiree Armojallas',
                                                style: TextStyle(
                                                  color: GinaAppTheme
                                                      .cancelledTextColor,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 200,
                                              child: Text(
                                                'You: Hi, how are you?',
                                                style: TextStyle(
                                                  color: GinaAppTheme
                                                      .cancelledTextColor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Gap(30),
                                    const Text(
                                      'Yesterday',
                                      style: TextStyle(
                                        color: GinaAppTheme.cancelledTextColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
