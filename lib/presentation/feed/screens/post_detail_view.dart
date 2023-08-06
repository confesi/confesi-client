import 'package:confesi/presentation/comments/widgets/simple_comment_sort.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confesi/application/comments/cubit/comment_section_cubit.dart';
import 'package:confesi/application/user/cubit/quick_actions_cubit.dart';
import 'package:confesi/application/user/cubit/saved_posts_cubit.dart';
import 'package:confesi/core/utils/numbers/add_commas_to_number.dart';
import 'package:confesi/models/post.dart';
import 'package:confesi/presentation/shared/edited_source_widgets/swipe_refresh.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:scrollable/exports.dart';
import 'package:screenshot_callback/screenshot_callback.dart';
import '../../../application/user/cubit/notifications_cubit.dart';
import '../../../core/router/go_router.dart';
import '../../../core/services/global_content/global_content.dart';
import '../../comments/widgets/comment_text_sheet.dart';
import '../methods/show_post_options.dart';
import '../utils/post_metadata_formatters.dart';
import '../../shared/behaviours/one_theme_status_bar.dart';
import '../../../core/styles/typography.dart';
import '../../shared/buttons/simple_text.dart';
import '../../shared/overlays/notification_chip.dart';
import '../../shared/stat_tiles/stat_tile_group.dart';
import '../../comments/widgets/comments_section.dart';

class SimpleDetailViewScreen extends StatefulWidget {
  const SimpleDetailViewScreen({super.key, required this.props});

  final HomePostsDetailProps props;

  @override
  State<SimpleDetailViewScreen> createState() => _SimpleDetailViewScreenState();
}

class _SimpleDetailViewScreenState extends State<SimpleDetailViewScreen> {
  late CommentSheetController commentSheetController;
  late ScreenshotCallback screenshotCallback;

  @override
  void initState() {
    commentSheetController = CommentSheetController();
    screenshotCallback = ScreenshotCallback();
    screenshotCallback.addListener(
      () {
        showNotificationChip(
          context,
          "Tap here to share this instead",
          notificationType: NotificationType.success,
          onTap: () => context.read<QuickActionsCubit>().sharePost(context, widget.props.post),
        );
      },
    );
    // post frame callback
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (widget.props.openKeyboard) commentSheetController.focus();
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    screenshotCallback.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Post post = Provider.of<GlobalContentService>(context).posts[widget.props.post.id]!;
    return OneThemeStatusBar(
      brightness: Brightness.light,
      child: KeyboardDismiss(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: CommentSheetView(post: post),
        ),
      ),
    );
  }
}
