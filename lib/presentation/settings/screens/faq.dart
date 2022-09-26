import 'package:Confessi/presentation/settings/widgets/setting_tile.dart';
import 'package:Confessi/presentation/settings/widgets/stepper_tile.dart';
import 'package:Confessi/presentation/shared/behaviours/init_opacity.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../../shared/behaviours/simulated_bottom_safe_area.dart';
import '../../shared/layout/appbar.dart';
import '../widgets/header_text.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  bool open = false;

  @override
  Widget build(BuildContext context) {
    return ThemedStatusBar(
        child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.shadow,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AppbarLayout(
              backgroundColor: Theme.of(context).colorScheme.shadow,
              centerWidget: Text(
                'FAQ',
                style: kTitle.copyWith(
                    color: Theme.of(context).colorScheme.primary),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: ScrollableView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HeaderText(text: "General"),
                      const StepperTile(
                        question: "My University isn't in the app.",
                        answer:
                            "Gasp! You can send us a message (found under 'Feedback' in general settings), and we'll be glad to consider adding it.",
                      ),
                      const SizedBox(height: 10),
                      const StepperTile(
                        question: "I just saw inappropriate content.",
                        answer:
                            "That's not good! At Confesi, we try to be a place for freedom of expression, however, we understand some things are clearly not acceptable. In these cases, make sure to report the post. This will ensure a moderator looks it over as soon as they can.",
                      ),
                      const SizedBox(height: 10),
                      const StepperTile(
                        question: "Can I become a moderator?",
                        answer:
                            "You can send us a message (found under 'Feedback' in general settings) with why you want to be a mod, and why you should be chosen.",
                      ),
                      const SizedBox(height: 10),
                      const StepperTile(
                        question: "I found an easter egg that gave me stuff?",
                        answer:
                            "Shhhhhhhhh, keep it to yourself! In the meantime, keep looking for more. There are so, so many - some easy to find, others impossibly hidden.",
                      ),
                      const SizedBox(height: 10),
                      const StepperTile(
                        question: "My language isn't supported.",
                        answer:
                            "Oh no! You can send us a message (found under 'Feedback' in general settings), and we'll try to get a translation added for you if enough people feel the same way!",
                      ),
                      const SizedBox(height: 10),
                      const StepperTile(
                        question: "I thought of a feature that could be added.",
                        answer:
                            "That sounds amazing! Send us a message (found under 'Feedback' in general settings), and we'll seriously consider it. Our lead developer reads everything sent (yes, everything).",
                      ),
                      const SizedBox(height: 10),
                      const HeaderText(text: "Privacy"),
                      const StepperTile(
                        question: "Are my confessions linked to me?",
                        answer:
                            "Users are not able to see who posts confessions. That is private. The only data they can see is the genre (you enter manually), your faculty (optionally entered), year of study (you enter manually), and university (your home university selected in your profile). These are used to simply sort your posts.",
                      ),
                      const SizedBox(height: 10),
                      const StepperTile(
                        question: "Can I delete a confession?",
                        answer:
                            "Yes... and no. Confessions written and saved to your profile can be deleted via navigating to them in your profile and pressing 'delete'. However, if you choose the 'send without saving to my profile' option when confessing, it's completely out of our control (as it's detached from your account).",
                      ),
                      const SizedBox(height: 10),
                      const StepperTile(
                        question: "<Some message about comments and privacy.>",
                        answer: "ABC",
                      ),
                      const SizedBox(height: 10),
                      const StepperTile(
                        question:
                            "<Some message about general privacy of the app and how it works.>",
                        answer: "ABC",
                      ),
                      const SizedBox(height: 10),
                      const HeaderText(text: "Development"),
                      const StepperTile(
                        question: "Who made Confesi?",
                        answer:
                            "Confesi was built by University of Victoria students over the span of about a year.",
                      ),
                      const SizedBox(height: 10),
                      const StepperTile(
                        question: "Are you looking for developers?",
                        answer:
                            "We're not actively looking, but if you have skills in the technologies we use, then feel free to reach out. No harm in asking!",
                      ),
                      const SizedBox(height: 10),
                      const StepperTile(
                        question: "On what platforms is Confesi offered?",
                        answer:
                            "Confesi was originally built for iOS and android, but recently we've been working towards getting native macOS, windows, and web versions as well. You can expect them sometime in the distant future.",
                      ),
                      const SizedBox(height: 10),
                      const StepperTile(
                        question: "I found a bug.",
                        answer:
                            "Please send us an error report (found under 'Feedback' in general settings). If possible, include: your device, what the bug was, what led up to it, what you believe caused it, and anything else you remember!",
                      ),
                      const SizedBox(height: 10),
                      const HeaderText(
                        verticalPadding: false,
                        text: "Have a question we should add?",
                      ),
                      SettingTile(
                        icon: CupertinoIcons.pen,
                        text: "Feedback",
                        onTap: () => print("feedback"),
                      ),
                      const SimulatedBottomSafeArea(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
