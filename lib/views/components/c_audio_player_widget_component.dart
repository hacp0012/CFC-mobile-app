import 'package:cfc_christ/configs/c_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CAudioPlayerWidgetComponent extends StatelessWidget {
  const CAudioPlayerWidgetComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
      child: Padding(
        padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
        child: Row(
          children: [
            IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.play_circle)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const LinearProgressIndicator(
                    value: .45,
                    borderRadius: BorderRadius.all(Radius.circular(CConstants.DEFAULT_RADIUS)),
                  ),
                  Row(children: [
                    Text("01:12", style: Theme.of(context).textTheme.labelSmall),
                    const Spacer(),
                    Text("01:30", style: Theme.of(context).textTheme.labelSmall),
                  ]),
                ],
              ),
            ),
            IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.ellipsis_vertical)),
          ],
        ),
      ),
    );
  }
}
