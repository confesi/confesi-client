// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../application/authentication_and_settings/cubit/user_cubit.dart';
// import '../../../constants/create_post/general.dart';
// import '../../../core/styles/typography.dart';
// import '../../shared/button_touch_effects/touchable_opacity.dart';
// import 'package:flutter/material.dart';

// class ChildPost extends StatelessWidget {
//   const ChildPost({
//     super.key,
//     required this.body,
//     this.onTap,
//     required this.title,
//   });

//   final String title;
//   final String body;
//   final VoidCallback? onTap;

//   Widget buildBody(BuildContext context) => Container(
//         width: double.infinity,
//         padding: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           color: Theme.of(context).colorScheme.background,
//           borderRadius:
//               BorderRadius.all(Radius.circular(context.watch<UserCubit>().stateAsUser.curvyEnum.borderRadius)),
//           border: Border.all(color: Theme.of(context).colorScheme.onBackground, width: borderSize, strokeAlign: BorderSide.strokeAlignCenter),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Replying to post:",
//               style: kDetail.copyWith(
//                 color: Theme.of(context).colorScheme.onSurface,
//                 fontSize: kDetail.fontSize! * context.watch<UserCubit>().stateAsUser.textSizeEnum.multiplier,
//               ),
//               textAlign: TextAlign.left,
//             ),
//             const SizedBox(height: 15),
//             Text(
//               title.length > kChildPostTitlePreviewLength
//                   ? '${title.substring(0, kChildPostTitlePreviewLength)}...'
//                   : title,
//               style: kDisplay1.copyWith(
//                 color: Theme.of(context).colorScheme.primary,
//                 fontSize: 17 * context.watch<UserCubit>().stateAsUser.textSizeEnum.multiplier,
//               ),
//               overflow: TextOverflow.ellipsis,
//               maxLines: 2,
//               textAlign: TextAlign.left,
//             ),
//             const SizedBox(height: 5),
//             Text(
//               body.length > kChildPostBodyPreviewLength ? '${body.substring(0, kChildPostBodyPreviewLength)}...' : body,
//               style: kBody.copyWith(
//                 color: Theme.of(context).colorScheme.primary,
//                 fontSize: kBody.fontSize! * context.watch<UserCubit>().stateAsUser.textSizeEnum.multiplier,
//               ),
//               overflow: TextOverflow.ellipsis,
//               maxLines: 2,
//               textAlign: TextAlign.left,
//             ),
//           ],
//         ),
//       );

//   @override
//   Widget build(BuildContext context) {
//     return onTap == null
//         ? buildBody(context)
//         : TouchableOpacity(
//             onTap: () => onTap!(),
//             child: buildBody(context),
//           );
//   }
// }
