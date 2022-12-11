import 'package:Confessi/application/shared/cubit/website_launcher_cubit.dart';
import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:Confessi/presentation/shared/indicators/loading_cupertino.dart';
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
  bool isNull = false;

  Future<Metadata?> futureSnapshot() async {
    Metadata? result = await AnyLinkPreview.getMetadata(link: widget.url);
    return result;
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
            key: UniqueKey(),
            future: futureSnapshot(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    widget.url,
                    style: kBody.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              } else if (snapshot.hasData) {
                Metadata metaData = (snapshot.data as Metadata);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        metaData.title == null ? widget.url : metaData.title!,
                        style: kBody.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    metaData.image == null ? Container() : Image.network(metaData.image!),
                  ],
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.all(10),
                  child: LoadingCupertinoIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
