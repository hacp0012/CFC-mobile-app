import 'package:cfc_christ/configs/c_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CNotificationCardListComponent extends StatelessWidget {
  const CNotificationCardListComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
      child: Padding(
        padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const CircleAvatar(radius: CConstants.GOLDEN_SIZE * 3, child: Icon(CupertinoIcons.bell)),

          // -- Body :
          const SizedBox(width: CConstants.GOLDEN_SIZE),
          Expanded(
            child: Column(children: [
              Row(children: [
                const Icon(CupertinoIcons.envelope, size: CConstants.GOLDEN_SIZE * 2),
                const SizedBox(width: CConstants.GOLDEN_SIZE),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: CConstants.GOLDEN_SIZE - 5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(CConstants.DEFAULT_RADIUS),
                  ),
                  child: Text(
                    "Message",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),

                // Date :
                const Spacer(),
                Text("14 avr 2024", style: Theme.of(context).textTheme.labelMedium),
              ]),

              // --- Message :
              const Text(
                "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam "
                "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam ",
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ]),
          )
        ]),
      ),
    );
  }
}
