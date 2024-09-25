import 'package:cached_network_image/cached_network_image.dart';
import 'package:cfc_christ/classes/c_image_handler_class.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:flutter/material.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class CImagesGridGroupViewComponent extends StatelessWidget {
  const CImagesGridGroupViewComponent({super.key, this.pictures = const [null, null, null, null]});

  final List pictures;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(CConstants.GOLDEN_SIZE),
        child: Builder(builder: (context) {
          // When is 1
          // When is 2
          // When is 3
          // When is more (+more)
          if (pictures.length == 1) {
            return GestureAnimator(
              child: Image(
                image: CachedNetworkImageProvider(
                  CImageHandlerClass.byPid(pictures[0], scale: 45, defaultImage: 'images.image_1'),
                ),
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              onTap: () => CImageHandlerClass.show(context, [...pictures.map((e) => e)], startAt: 0),
            );
          } else if (pictures.length == 2) {
            return Row(children: [
              Flexible(
                flex: 1,
                child: GestureAnimator(
                  child: Image(
                    image: CachedNetworkImageProvider(CImageHandlerClass.byPid(pictures[0], scale: 36)),
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  onTap: () => CImageHandlerClass.show(context, [...pictures.map((e) => e)], startAt: 0),
                ),
              ),
              const SizedBox(width: 3.0),
              Flexible(
                flex: 1,
                child: GestureAnimator(
                  child: Image(
                    image: CachedNetworkImageProvider(CImageHandlerClass.byPid(pictures[1], scale: 36)),
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  onTap: () => CImageHandlerClass.show(context, [...pictures.map((e) => e)], startAt: 1),
                ),
              ),
            ]);
          } else if (pictures.length == 3) {
            return Row(children: [
              Flexible(
                flex: 2,
                child: GestureAnimator(
                  child: Image(
                    image: CachedNetworkImageProvider(CImageHandlerClass.byPid(pictures[0], scale: 36)),
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  onTap: () => CImageHandlerClass.show(context, [...pictures.map((e) => e)], startAt: 0),
                ),
              ),
              const SizedBox(width: 3.0),
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    GestureAnimator(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: (180 / 2) - 1.5),
                        child: Image(
                          image: CachedNetworkImageProvider(CImageHandlerClass.byPid(pictures[1], scale: 27)),
                          fit: BoxFit.cover,
                          height: double.infinity,
                          width: double.infinity,
                        ),
                      ),
                      onTap: () => CImageHandlerClass.show(context, [...pictures.map((e) => e)], startAt: 1),
                    ),
                    const SizedBox(height: 3.0),
                    GestureAnimator(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: (180 / 2) - 1.5),
                        child: Image(
                          image: CachedNetworkImageProvider(CImageHandlerClass.byPid(pictures[2], scale: 27)),
                          fit: BoxFit.cover,
                          height: double.infinity,
                          width: double.infinity,
                        ),
                      ),
                      onTap: () => CImageHandlerClass.show(context, [...pictures.map((e) => e)], startAt: 2),
                    ),
                  ],
                ),
              ),
            ]);
          } else if ((pictures.length) > 3) {
            return Row(children: [
              Flexible(
                flex: 2,
                child: GestureAnimator(
                  child: Image(
                    image: CachedNetworkImageProvider(CImageHandlerClass.byPid(pictures[0], scale: 36)),
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  onTap: () => CImageHandlerClass.show(context, [...pictures.map((e) => e)], startAt: 0),
                ),
              ),
              const SizedBox(width: 3.0),
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    GestureAnimator(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: (180 / 2) - 1.5),
                        child: Image(
                          image: CachedNetworkImageProvider(CImageHandlerClass.byPid(pictures[1], scale: 27)),
                          fit: BoxFit.cover,
                          height: double.infinity,
                          width: double.infinity,
                        ),
                      ),
                      onTap: () => CImageHandlerClass.show(context, [...pictures.map((e) => e)], startAt: 1),
                    ),
                    const SizedBox(height: 3.0),
                    GestureAnimator(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: (180 / 2) - 1.5),
                        child: Stack(
                          children: [
                            Image(
                              image: CachedNetworkImageProvider(CImageHandlerClass.byPid(pictures[2], scale: 27)),
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            ),
                            Container(
                              color: Colors.black.withOpacity(.63),
                              child: Center(
                                child: Text(
                                  '+${pictures.length - 3}',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () => CImageHandlerClass.show(context, [...pictures.map((e) => e)], startAt: 2),
                    ),
                  ],
                ),
              ),
            ]);
          }

          return Center(
            child: Text(
              "No pricture provided",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.error),
            ),
          );
        }),
      ),
    );
  }
}
