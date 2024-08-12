import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/views/layouts/empty_layout.dart';
import 'package:flutter/material.dart';
import 'package:linkfy_text/linkfy_text.dart';

class AboutusScreen extends StatefulWidget {
  static const String routeName = 'aboutus';
  static const String routePath = 'aboutus';

  const AboutusScreen({super.key});

  @override
  State<AboutusScreen> createState() => _AboutusScreenState();
}

class _AboutusScreenState extends State<AboutusScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Scaffold(
        appBar: AppBar(title: const Text('A propos de la CFC')),
        body: ListView(children: [
          const SizedBox(height: CConstants.GOLDEN_SIZE * 3),

          // -- LOGO :
          CircleAvatar(
            radius: CConstants.GOLDEN_SIZE * 7,
            backgroundColor: CConstants.LIGHT_COLOR,
            child: Image.asset('lib/assets/icons/LOGO_CFC_512.png', height: CConstants.GOLDEN_SIZE * 18),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
                child: Text("CFC", style: Theme.of(context).textTheme.headlineMedium),
              ),
              Padding(
                padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
                child: Text("Communauté Famille Chrétienne", style: Theme.of(context).textTheme.titleMedium),
              ),
              Padding(
                padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
                child: Text("La CFC et son charisme", style: Theme.of(context).textTheme.titleMedium),
              ),
            ],
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: CConstants.GOLDEN_SIZE * 42),
            child: Padding(
              padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
              child: Column(
                children: [
                  const LinkifySelectableText("""
                  
Initiée à Kinshasa, en octobre 1984 par un groupe de trois couples amis, dont celui de BOTOLO Léon et Valentine, la Communauté Famille Chrétienne, CFC en sigle, est une Communauté de prière et de vie, ayant pour mission l’encadrement spirituel, moral et humain des couples et de leurs familles pour leur sanctification et leur promotion humaine et intégrale. La CFC a donc pour charisme particulier la sanctification des couples et de leurs familles. Elle vit cette spiritualité selon le modèle du Renouveau charismatique catholique (art 1er du Règlement Intérieur).

Association à caractère laïc, spirituel, social, apolitique, non gouvernemental et sans but lucratif, la CFC établit son siège en un lieu dénommé « Centre Cana » situé au numéro 78, rue Banalia, commune de Kasa-Vubu, à Kinshasa, en République Démocratique du Congo.

La Communauté Famille Chrétienne, en sigle « C.F.C. », marquée par la trilogie suivante : (1) Communauté de prière et de vie, (2) Association privée des fidèles, sur le plan canonique, dirigée par ses membres (canon 321) et (3) Association sans but lucratif, sur le plan civil ; a pour but de :

Promouvoir la sanctification des couples et des familles ;
Assurer l’encadrement et le suivi des couples ;
Développer la recherche de l’harmonie et le bonheur conjugal ;
Assurer l’encadrement des enfants pour asseoir l’éducation chrétienne.

Caractérisée par un enseignement axé sur la multidisciplinarité, la Communauté Famille Chrétienne exerce un leadership reconnu en matière de réflexion sur la famille et le couple chrétiens et exerce une influence sur les pratiques de gestion dans ces domaines dans toutes les communautés catholiques où elle existe.

Les membres effectifs de la CFC sont des couples estimés à ce jours à plusieurs dizaines de milliers dans le monde : à Kinshasa, la CFC est implantée dans 76 paroisses d’accueil et dans environ 15 provinces de la République Démocratique du Congo. En Afrique, elle est présente en Afrique-Sud (Johannesburg, Pretoria, Sandton Kempton park), en Angola (Cabinda), au Gabon, etc. En Europe, la Communauté Famille Chrétienne est opérationnelle à Bruxelles en l’Eglise Saint Roch (Belgique), à Rome à l’Eglise de la Communauté Catholique Congolaise (Aumônerie, PIAZZA PASQUINO, 2 Roma) et elle est en gestation en France, en Angleterre, etc. En Amérique du nord, en gestation, au Canada. 

Les principales activités de la CFC sont de (d’) : 
  👉 Organiser, hebdomadairement, la prière qui se fait selon le mode du Renouveau Charismatique Catholique ;
  
  👉 Organiser, une fois l’an, la campagne d’évangélisation dans un stade à Kinshasa ;
  
  👉 Organiser, une fois l’an, la journée récréative qui regroupe les parents et les enfants dans un site ;
  
  👉 Assurer à ses membres une formation humaine, à travers la Fondation pour la Famille Asbl, une émanation de la CFC, spécialisée ;
  
  👉 Organiser un forum périodique pour discuter de questions pertinentes sur la famille ;
  
  👉 Assurer la publication des ouvrages et revues sur la famille ;
  
  👉 Diffuser de l’information et des enseignements sur des sujets liés à la famille ;
  
  👉 Faire valoir les préoccupations des familles auprès des autorités politiques et autres organismes ;
  
  👉 Fournir de l’aide aux personnes vulnérables ;
  
  👉 Faire l’évaluation en couple, à la fin de l’année, à partir d’un questionnaire élaboré.



Les prières de la CFC sont organisées de la manière suivante : 
  ✨ Quinze couples ou plus se réunissent le vendredi et de façon bihebdomadaire, de 18h00’ à 20h00’, en réunion de prière dans la structure appelée Noyaux d’affermissement et dirigé par un couple berger de noyau (BN) ;
  
  ✨ Chaque mardi ou mercredi, les membres des noyaux se réunissent, de 17h30’ à 19h30’, en réunion de prière à la paroisse d’accueil appelée Communauté locale et dirigée par un couple Berger de la Communauté Locale (BCL) assisté d’un adjoint, le couple Berger de la Communauté Locale Adjoint (BCLA) ;
  
  ✨ Chaque lundi ou mardi, de 17h00’ à 19h00’, tous les membres des communautés locales proches du point de vue géographique, se constituant en un Pool dirigé par un couple Berger Coordonnateur de Pool (BCP), se réunissent en prière spéciale en une paroisse indiquée (une cathédrale), et pour ceux de Kinshasa, au siège de la CFC à Kinshasa.
"""),
                  RichText(
                    text: TextSpan(
                      text: "Pour en savoir plus, visitez le site officiel de la CFC : ",
                      style: Theme.of(context).textTheme.labelMedium,
                      children: const [TextSpan(text: "https://www.c-f-c.cd/", style: TextStyle(color: Colors.blue))],
                    ),
                  ),
                  LinkifySelectableText(
                    """
                    
Siège :
78, rue Banalia
Commune de Kasa-vubu
Ville province de Kinshasa
République Démocratique du Congo
E-mail : cfcrdc@yahoo.fr

Responsable de l’association
Léon BOTOLO MAGOZA
Contacts : +243998911122, +243999920890
E-mail : botmago@hotmail.com
""",
                    linkStyle: const TextStyle(color: Colors.blue),
                    textStyle: Theme.of(context).textTheme.labelMedium,
                    linkTypes: const [LinkType.url, LinkType.phone, LinkType.email],
                    onTap: (link) {},
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
