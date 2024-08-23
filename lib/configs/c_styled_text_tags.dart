import 'package:cfc_christ/configs/c_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:styled_text/styled_text.dart';

class CStyledTextTags {
  CStyledTextTags({this.onTapLink, this.onTapNavigateLink});

  void Function(String? link)? onTapLink;
  void Function(String? routeName)? onTapNavigateLink;

  // -- TAGS ------------------------------------ >

  /// Specifie a link with tag attribute [href].
  StyledTextTag get link => StyledTextActionTag(
        (String? text, Map<String?, String?> attrs) => onTapLink!(attrs['href']),
        style: const TextStyle(/*decoration: TextDecoration.underline,*/ color: CConstants.PRIMARY_COLOR),
      );

  /// Specifie a page navigation route name with tag attribute [routename].
  StyledTextTag get navigate => StyledTextActionTag(
        (String? text, Map<String?, String?> attrs) => onTapNavigateLink!(attrs['routename']),
        style: const TextStyle(/*decoration: TextDecoration.underline,*/ color: CConstants.PRIMARY_COLOR),
      );

  /// Add an Icon link in text.
  StyledTextIconTag get linkIcon => StyledTextIconTag(CupertinoIcons.link, size: CConstants.GOLDEN_SIZE * 2);

  StyledTextTag get bold => StyledTextTag(style: const TextStyle(fontWeight: FontWeight.bold));

  StyledTextTag get italic => StyledTextTag(style: const TextStyle(fontStyle: FontStyle.italic));

  StyledTextTag get xsmall => StyledTextTag(style: const TextStyle(fontSize: CConstants.GOLDEN_SIZE, fontFamily: 'figtree'));

  StyledTextTag get small => StyledTextTag(style: const TextStyle(fontSize: 12, fontFamily: 'figtree'));

  StyledTextTag get medium => StyledTextTag(style: const TextStyle(fontSize: 14));

  StyledTextTag get large => StyledTextTag(style: const TextStyle(fontSize: 16));

  StyledTextTag get blue => StyledTextTag(style: const TextStyle(color: Colors.blue));
  // -- GET TAGS -------------------------------- >
  /// Get all tags.
  Map<String, StyledTextTagBase> get tags {
    return {
      'link': link,
      'navigate': navigate,
      'link-icon': linkIcon,
      'italic': italic,
      'bold': bold,
      'xsmall': xsmall,
      'small': small,
      'medium': medium,
      'large': large,
      'blue': blue,
    };
  }
}
