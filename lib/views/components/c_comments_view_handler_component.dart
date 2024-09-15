import 'package:cfc_christ/classes/c_misc_class.dart';
import 'package:cfc_christ/classes/c_sections_types_enum.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

class CCommentsViewHandlerComponent extends StatefulWidget {
  const CCommentsViewHandlerComponent({
    super.key,
    required this.section,
    required this.id,
    this.ownerId,
  });

  final CSectionsTypesEnum section;
  final String id;
  final String? ownerId;

  @override
  State<CCommentsViewHandlerComponent> createState() => _CCommentsViewHandlerComponentState();
}

class _CCommentsViewHandlerComponentState extends State<CCommentsViewHandlerComponent> {
  // DATAS ------------------------------------------------------------------------------------------------------------------:

  // INITIALIZER ------------------------------------------------------------------------------------------------------------:

  // VIEW -------------------------------------------------------------------------------------------------------------------:
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: CConstants.GOLDEN_SIZE * 1),
      Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Expanded(
          child: TextField(
            decoration: const InputDecoration().copyWith(
              hintText: "Laisser votre commentaire ici ...",
            ),
            maxLines: null,
            keyboardType: TextInputType.multiline,
          ),
        ),
        TextButton(onPressed: () {}, child: const Text('POSTER')),
      ]),
      const SizedBox(height: CConstants.GOLDEN_SIZE * 2),
      ...List<Widget>.generate(1, (int index) {
        return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Column(
            children: [
              SizedBox(height: CConstants.GOLDEN_SIZE * 1.5),
              CircleAvatar(
                backgroundImage: AssetImage('lib/assets/pictures/smil_man.jpg'),
                radius: CConstants.GOLDEN_SIZE * 2,
              ),
            ],
          ),
          const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
          Expanded(
            child: Card(
              elevation: 0,
              // margin: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
              child: Padding(
                padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE / 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Faker().person.name()),
                    SelectableText(
                      Faker().lorem.sentences(3).join(' '),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: CMiscClass.whenBrightnessOf(context, light: Colors.grey.shade700),
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]);
      }),
    ]);
  }

  // METHODS ----------------------------------------------------------------------------------------------------------------:
  load() {}

  post() {}

  // OWNLER --> -------------------------------- :
  edit() {}

  // ADMIN --> --------------------------------- :
  remove() {}
}
