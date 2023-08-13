// import 'package:flutter/material.dart';
// import 'package:any_link_preview/any_link_preview.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:cached_network_image/cached_network_image.dart';

// import '../../../core/styles/typography.dart';
// import '../../../core/utils/sizing/width_fraction.dart';
// import '../button_touch_effects/touchable_scale.dart';
// import '../indicators/loading_cupertino.dart';
// import '../other/cached_online_image.dart';
// import 'package:confesi/application/user/cubit/quick_actions_cubit.dart';

// class UrlPreviewTile extends StatefulWidget {
//   const UrlPreviewTile({Key? key, required this.url}) : super(key: key);

//   final String url;

//   @override
//   State<UrlPreviewTile> createState() => _UrlPreviewTileState();
// }

// class _UrlPreviewTileState extends State<UrlPreviewTile> {
//   Future<Metadata?>? _futureSnapshot;

//   @override
//   void initState() {
//     super.initState();
//     _futureSnapshot = futureSnapshot();
//   }

//   Future<Metadata?> futureSnapshot() async {
//     String securedUrl = ensureHttpsUrl(widget.url);
//     Metadata? result = await AnyLinkPreview.getMetadata(link: securedUrl);
//     return result;
//   }

//   String ensureHttpsUrl(String inputUrl) {
//     if (!inputUrl.startsWith('https://') && !inputUrl.startsWith('http://')) {
//       return 'https://$inputUrl';
//     }
//     return inputUrl;
//   }

//   Widget buildBody(BuildContext context, AsyncSnapshot<Object?> snapshot) {
//     if (snapshot.connectionState == ConnectionState.waiting) {
//       return Container(
//         color: Theme.of(context).colorScheme.surface,
//         height: 150,
//         padding: const EdgeInsets.all(15),
//         child: Center(child: LoadingCupertinoIndicator(color: Theme.of(context).colorScheme.primary)),
//       );
//     } else if (snapshot.hasData && snapshot.data.runtimeType == Metadata) {
//       Metadata metaData = (snapshot.data as Metadata);
//       return SizedBox(
//         height: metaData.image == null ? null : 150,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             metaData.image == null
//                 ? Container()
//                 : FractionallySizedBox(
//                     heightFactor: 1,
//                     child: ClipRRect(
//                       borderRadius:
//                           const BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
//                       child: CachedOnlineImage(url: metaData.image!),
//                     ),
//                   ),
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.all(15),
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).colorScheme.surface,
//                   border: Border.all(color: Theme.of(context).colorScheme.onBackground, width: 0.8),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Visibility(
//                       visible: metaData.title != null && metaData.title != "null",
//                       child: Text(
//                         metaData.title!,
//                         style: kBody.copyWith(color: Theme.of(context).colorScheme.primary),
//                         textScaleFactor: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                     SizedBox(height: metaData.desc == null || metaData.desc == "null" ? 0 : 5),
//                     Visibility(
//                       visible: metaData.desc != null && metaData.desc != "null",
//                       child: Text(
//                         metaData.desc!,
//                         style: kDetail.copyWith(color: Theme.of(context).colorScheme.onSurface),
//                         textScaleFactor: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                     SizedBox(height: metaData.url == null || metaData.url == "null" ? 0 : 5),
//                     Visibility(
//                       visible: metaData.url != null && metaData.url != "null",
//                       child: Text(
//                         metaData.url!,
//                         style: kDetail.copyWith(color: Theme.of(context).colorScheme.onSurface),
//                         textScaleFactor: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     } else {
//       return Container(
//         height: 150,
//         color: Theme.of(context).colorScheme.surface,
//         padding: const EdgeInsets.all(15),
//         child: Center(
//           child: RichText(
//             textAlign: TextAlign.center,
//             overflow: TextOverflow.ellipsis,
//             text: TextSpan(
//               style: kDetail.copyWith(color: Theme.of(context).colorScheme.onSurface),
//               children: [
//                 TextSpan(
//                   text: "No preview available:\n",
//                   style: kDetail.copyWith(color: Theme.of(context).colorScheme.onSurface),
//                 ),
//                 TextSpan(
//                   text: widget.url,
//                   style: kDetail.copyWith(color: Theme.of(context).colorScheme.primary),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return TouchableScale(
//       onTap: () => context.read<QuickActionsCubit>().launchWebsite(widget.url),
//       child: ClipRRect(
//         borderRadius: const BorderRadius.all(Radius.circular(15)),
//         child: Container(
//           width: double.infinity,
//           decoration: BoxDecoration(
//             border: Border.all(color: Theme.of(context).colorScheme.surface, width: 1),
//             borderRadius: const BorderRadius.all(Radius.circular(15)),
//           ),
//           child: FutureBuilder(
//             future: _futureSnapshot,
//             builder: (context, snapshot) {
//               return AnimatedSwitcher(
//                 duration: const Duration(milliseconds: 250),
//                 child: buildBody(context, snapshot),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
