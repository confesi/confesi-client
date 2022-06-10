import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/typography.dart';
import 'package:flutter_mobile_client/responsive/sizes.dart';
import 'package:flutter_mobile_client/screens/post/post_details.dart';
import 'package:flutter_mobile_client/widgets/buttons/action.dart';
import 'package:flutter_mobile_client/widgets/layouts/line.dart';
import 'package:flutter_mobile_client/widgets/text/group.dart';

class PostHome extends StatefulWidget {
  const PostHome({Key? key}) : super(key: key);

  @override
  State<PostHome> createState() => _PostHomeState();
}

class _PostHomeState extends State<PostHome> {
  final ScrollController controller = ScrollController();

  bool pressed = false;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.offset <= 0) {
        FocusScope.of(context).unfocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        // print(details.delta.direction);
        if (details.delta.direction > 0 && details.delta.distance > 20) {
          FocusScope.of(context).unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: Theme.of(context).colorScheme.background,
          shadowColor: Colors.transparent,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
            child: Responsive(
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    const GroupText(
                      widthMultiplier: 80,
                      body:
                          "Please be civil, but have fun. Posts are never linked to your account.",
                      header: "Create Confession",
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                          tag: "details-button",
                          child: Material(
                            child: ActionButton(
                              onPress: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => const PostDetails()));
                              },
                              text: "add details",
                              icon: CupertinoIcons.pen,
                              backgroundColor: Theme.of(context).colorScheme.secondary,
                              iconColor: Theme.of(context).colorScheme.onPrimary,
                              textColor: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        ActionButton(
                          loading: pressed,
                          onPress: () {
                            setState(() {
                              pressed = !pressed;
                            });
                          },
                          text: "publish post",
                          icon: CupertinoIcons.arrow_turn_left_up,
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          iconColor: Theme.of(context).colorScheme.onPrimary,
                          textColor: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    LineLayout(color: Theme.of(context).colorScheme.surface),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: controller,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 15),
                          child: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            style: kBody.copyWith(color: Theme.of(context).colorScheme.primary),
                            decoration: InputDecoration.collapsed(
                              hintText: "spill your guts...",
                              hintStyle:
                                  kDetail.copyWith(color: Theme.of(context).colorScheme.surface),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              null,
            ),
          ),
        ),
      ),
    );
  }
}
