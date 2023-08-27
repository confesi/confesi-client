import 'package:confesi/presentation/primary/widgets/scroll_dots.dart';
import 'package:confesi/presentation/shared/other/cached_online_image.dart';
import 'package:confesi/presentation/shared/other/zoomable.dart';
import 'package:flutter/material.dart';

class ImgViewer extends StatefulWidget {
  const ImgViewer({super.key, required this.imgUrls});

  final List<String> imgUrls;

  @override
  State<ImgViewer> createState() => _ImgViewerState();
}

class _ImgViewerState extends State<ImgViewer> {
  int currentIdx = 0;

  @override
  Widget build(BuildContext context) {
    return widget.imgUrls.isEmpty
        ? const SizedBox()
        : AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                border: Border.all(
                  color: Theme.of(context).colorScheme.onBackground,
                  width: 0.8,
                ),
              ),
              width: double.infinity,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
                child: Stack(
                  clipBehavior: Clip.hardEdge,
                  alignment: Alignment.bottomCenter,
                  children: [
                    PageView(
                      onPageChanged: (v) => setState(() => currentIdx = v),
                      children: widget.imgUrls.map((e) => CachedOnlineImage(url: e)).toList(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: ScrollDots(
                        pageLength: widget.imgUrls.length,
                        pageIndex: currentIdx,
                        activeColor: Theme.of(context).colorScheme.tertiary,
                        borderColor: Theme.of(context).colorScheme.primary,
                        bgColor: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
