import 'package:cfc_christ/classes/c_image_handler_class.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:flutter/material.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class CImagesGridGroupViewComponent extends StatelessWidget {
  const CImagesGridGroupViewComponent({super.key, this.pictures = const [null, null, null, null]});

  final List? pictures;

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
          if (pictures != null) {
            if (pictures?.length == 1) {
              return GestureAnimator(
                child: Image.asset(
                  'lib/assets/pictures/family_1.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                onTap: () => CImageHandlerClass.show(context, [null]),
              );
            } else if (pictures?.length == 2) {
              return Row(children: [
                Flexible(
                  flex: 1,
                  child: GestureAnimator(
                    child: Image.asset('lib/assets/pictures/family_1.jpg', fit: BoxFit.cover, height: double.infinity),
                    onTap: () => CImageHandlerClass.show(context, [null]),
                  ),
                ),
                const SizedBox(width: 3.0),
                Flexible(
                  flex: 1,
                  child: GestureAnimator(
                      child:
                          Image.asset('lib/assets/pictures/praying_people.jpg', fit: BoxFit.cover, height: double.infinity)),
                ),
              ]);
            } else if (pictures?.length == 3) {
              return Row(children: [
                Flexible(
                  flex: 2,
                  child: GestureAnimator(
                    child: Image.asset(
                      'lib/assets/pictures/family_1.jpg',
                      fit: BoxFit.cover,
                      height: double.infinity,
                    ),
                    onTap: () => CImageHandlerClass.show(context, [null]),
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
                          child: Image.asset('lib/assets/pictures/praying_people.jpg',
                              fit: BoxFit.cover, height: double.infinity),
                        ),
                      ),
                      const SizedBox(height: 3.0),
                      GestureAnimator(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: (180 / 2) - 1.5),
                          child: Image.asset('lib/assets/pictures/family_2.jpg', fit: BoxFit.cover, height: double.infinity),
                        ),
                      ),
                    ],
                  ),
                ),
              ]);
            } else if ((pictures?.length ?? 4) > 3) {
              return Row(children: [
                Flexible(
                  flex: 2,
                  child: GestureAnimator(
                    child: Image.asset(
                      'lib/assets/pictures/family_1.jpg',
                      fit: BoxFit.cover,
                      height: double.infinity,
                    ),
                    onTap: () => CImageHandlerClass.show(context, [null]),
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
                          child: Image.asset('lib/assets/pictures/praying_people.jpg',
                              fit: BoxFit.cover, height: double.infinity),
                        ),
                      ),
                      const SizedBox(height: 3.0),
                      GestureAnimator(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: (180 / 2) - 1.5),
                          child: Stack(
                            children: [
                              Image.asset('lib/assets/pictures/family_2.jpg', fit: BoxFit.cover, height: double.infinity),
                              Container(
                                color: Colors.black.withOpacity(.63),
                                child: Center(
                                  child: Text(
                                    '+9',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]);
            }
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
