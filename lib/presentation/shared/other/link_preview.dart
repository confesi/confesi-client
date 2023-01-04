import '../../../application/shared/cubit/website_launcher_cubit.dart';
import '../../../core/styles/typography.dart';
import '../../../core/utils/sizing/width_fraction.dart';
import '../button_touch_effects/touchable_scale.dart';
import '../indicators/loading_cupertino.dart';
import 'cached_online_image.dart';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UrlPreviewTile extends StatefulWidget {
  const UrlPreviewTile({super.key, required this.url});

  final String url;

  @override
  State<UrlPreviewTile> createState() => _UrlPreviewTileState();
}

class _UrlPreviewTileState extends State<UrlPreviewTile> {
  Future<Metadata?> futureSnapshot() async {
    Metadata? result = await AnyLinkPreview.getMetadata(link: widget.url);
    return result;
  }

  Widget buildBody(BuildContext context, AsyncSnapshot<Object?> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Container(
        height: 100,
        padding: const EdgeInsets.all(10),
        child: const Center(child: LoadingCupertinoIndicator()),
      );
    } else if (snapshot.hasData && snapshot.data.runtimeType == Metadata) {
      Metadata metaData = (snapshot.data as Metadata);
      return SizedBox(
        height: metaData.image == null ? null : 100, // If no image is available, don't include space for it
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            metaData.image == null
                ? Container()
                : SizedBox(
                    height: double.infinity,
                    width: widthFraction(context, 1 / 3),
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                      child: CachedOnlineImage(url: metaData.image!),
                    ),
                  ),
            Expanded(
              child: Container(
                  padding: const EdgeInsets.all(15),
                  // height: metaData.image == null ? null : 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        metaData.title == null ? widget.url : metaData.title!,
                        style: kBody.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        textScaleFactor: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: metaData.desc == null ? 0 : 5),
                      Text(
                        metaData.desc == null ? "" : metaData.desc!,
                        style: kDetail.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        textScaleFactor: 1,
                        overflow: TextOverflow.ellipsis,
                        // maxLines: 2,
                      ),
                      SizedBox(height: metaData.url == null ? 0 : 5),
                      Text(
                        metaData.url == null ? "" : metaData.url!,
                        style: kDetail.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        textScaleFactor: 1,
                        overflow: TextOverflow.ellipsis,
                        // maxLines: 2,
                      ),
                    ],
                  )),
            ),
          ],
        ),
      );
    } else {
      return Container(
        height: 100,
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Text(
            "No preview available: ${widget.url}",
            style: kDetail.copyWith(color: Theme.of(context).colorScheme.onSurface),
            textAlign: TextAlign.center,
            textScaleFactor: 1,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TouchableScale(
      onTap: () => context.read<WebsiteLauncherCubit>().launchPostLink(widget.url),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.surface, width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: FutureBuilder(
            future: futureSnapshot(),
            builder: (context, snapshot) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: buildBody(context, snapshot),
              );
            },
          ),
        ),
      ),
    );
  }
}
