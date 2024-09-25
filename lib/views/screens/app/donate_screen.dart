import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/configs/c_styled_text_tags.dart';
import 'package:cfc_christ/views/layouts/default_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:styled_text/widgets/styled_text.dart';

class DonateScreen extends StatefulWidget {
  static const String routeName = 'donate';
  static const String routePath = 'donate';

  const DonateScreen({super.key});

  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      transparentStatusBar: true,
      child: Scaffold(
        appBar: AppBar(title: const Text('Donation')),
        body: ListView(padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE * 1.5), children: [
          const CircleAvatar(
            radius: 81,
            backgroundImage: AssetImage('lib/assets/pictures/final/donation.jpg'),
          ),

          const SizedBox(height: CConstants.GOLDEN_SIZE),
          Text(
            "« Tout ce que vous faites, faites-le de bon cœur, comme pour le Seigneur et non pour des hommes. »",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            "Colossiens 3:23",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(fontStyle: FontStyle.italic),
          ),

          const SizedBox(height: CConstants.GOLDEN_SIZE * 2),
          StyledText(
            text: """
La Communauté Famille Chrétienne, investie de la mission d’être une milice sacrée pour la défense des valeurs familiales, œuvre chaque jour pour apporter la bonne nouvelle, les enseignements de qualité pour aider les couples à vivre en harmonie, en tout amour et paix, afin de rendre chaque jour plus vrai dans le monde son slogan qui dit « Il est possible de vivre heureux dans le mariage ».
      
La CFC vit et maintient ses activités grâce aux cotisations de ses membres, aux dons, legs et toutes autres formes de libéralités des personnes bienveillantes. Elle a en effet besoin des moyens matériels et financiers pour réaliser sa mission et maintenir en permanent état de fonctionnement cette plateforme mobile de partage de l’évangile, des enseignements spirituels et de vie, et de communication, qui est d’ailleurs un don d’un couple membre, en est le parfait exemple.
      
Voulez-vous être notre bienfaiteur et nous verser des libéralités ?
      
   
Comptes bancaires
Banque Internationale de Crédit SARL, en sigle « BIC »,
n° compte : <bold>24 012 339 001 - 25</bold>
      
      """,
            tags: CStyledTextTags().tags,
          ),
          const Card(
            elevation: .0,
            margin: EdgeInsets.all(CConstants.GOLDEN_SIZE),
            // surfaceTintColor: Colors.orange,
            child: Padding(
              padding: EdgeInsets.all(CConstants.GOLDEN_SIZE),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                TextField(decoration: InputDecoration(labelText: "Nom")),
                SizedBox(height: CConstants.GOLDEN_SIZE),
                TextField(decoration: InputDecoration(labelText: "Nom Complat")),
                SizedBox(height: CConstants.GOLDEN_SIZE),
                TextField(decoration: InputDecoration(labelText: "Telephone")),
                SizedBox(height: CConstants.GOLDEN_SIZE),
                TextField(decoration: InputDecoration(labelText: "Email")),
                SizedBox(height: CConstants.GOLDEN_SIZE),
                TextField(decoration: InputDecoration(labelText: "Adresse")),
                SizedBox(height: CConstants.GOLDEN_SIZE),
                TextField(decoration: InputDecoration(labelText: "Pay")),
                SizedBox(height: CConstants.GOLDEN_SIZE),
                TextField(decoration: InputDecoration(labelText: "Montant")),
                SizedBox(height: CConstants.GOLDEN_SIZE),
                DropdownButtonHideUnderline(
                  child: DropdownMenu(
                    hintText: "Type de libéralité",
                    dropdownMenuEntries: [
                      DropdownMenuEntry(value: '1', label: 's'),
                    ],
                  ),
                ),
                SizedBox(height: CConstants.GOLDEN_SIZE),
                DropdownButtonHideUnderline(
                  child: DropdownMenu(
                    hintText: "Occurrence",
                    dropdownMenuEntries: [
                      DropdownMenuEntry(value: '1', label: 's'),
                    ],
                  ),
                ),
                SizedBox(height: CConstants.GOLDEN_SIZE),
                DropdownButtonHideUnderline(
                  child: DropdownMenu(
                    hintText: "Destination",
                    dropdownMenuEntries: [
                      DropdownMenuEntry(value: '1', label: 's'),
                    ],
                  ),
                ),
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: null,
              icon: const Icon(CupertinoIcons.drop),
              label: const Text("FAIRE UN DON"),
              style: const ButtonStyle(
                // backgroundColor: WidgetStatePropertyAll(Colors.orange),
                foregroundColor: WidgetStatePropertyAll(Colors.white),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
