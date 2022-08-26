import 'package:Confessi/presentation/create_post/widgets/floating_button.dart';
import 'package:Confessi/presentation/shared/behaviours/keyboard_dismiss.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../../shared/layout/appbar.dart';

class CreatePostHome extends StatefulWidget {
  const CreatePostHome({Key? key}) : super(key: key);

  @override
  State<CreatePostHome> createState() => _CreatePostHomeState();
}

class _CreatePostHomeState extends State<CreatePostHome> {
  final ScrollController scrollController = ScrollController();
  FocusNode titleFocusNode = FocusNode();
  FocusNode bodyFocusNode = FocusNode();

  @override
  void dispose() {
    scrollController.dispose();
    titleFocusNode.dispose();
    bodyFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      // floatingActionButton: const FloatingButton(),
      body: GestureDetector(
        onTap: () => titleFocusNode.requestFocus(),
        child: SafeArea(
          child: Container(
            // Transparent hitbox trick.
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return KeyboardDismissLayout(
                    child: GestureDetector(
                      onTap: () => bodyFocusNode.requestFocus(),
                      child: SizedBox(
                        height: constraints.maxHeight,
                        child: ScrollableView(
                          controller: scrollController,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                  height:
                                      30), // Here to offset the scrollable, however, still position the text initially 30px from the top and not restrict it 30px from the top.
                              Container(
                                // Transparent hitbox trick.
                                color: Colors.transparent,
                                child: TextField(
                                  focusNode: titleFocusNode,
                                  // controller: textFieldController,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  style: kHeader.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  decoration: const InputDecoration.collapsed(
                                    hintText: "Create a captivating title",
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => titleFocusNode.requestFocus(),
                                child: Container(
                                  // Transparent hitbox trick.
                                  color: Colors.transparent,
                                  width: double.infinity,
                                  child: const SizedBox(height: 15),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => bodyFocusNode.requestFocus(),
                                child: Container(
                                  // Transparent hitbox trick.
                                  color: Colors.transparent,
                                  child: TextField(
                                    focusNode: bodyFocusNode,
                                    // controller: textFieldController,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    style: kBody.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                    decoration: const InputDecoration.collapsed(
                                      hintText: "Then spill your guts here...",
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                  height:
                                      30), // Adds some padding to the bottom.
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
