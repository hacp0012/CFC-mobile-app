import 'package:cfc_christ/classes/c_sections_types_enum.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/views/components/c_comments_view_handler_component.dart';
import 'package:cfc_christ/views/layouts/default_layout.dart';
import 'package:flutter/material.dart';

class UserCommentsAdminScreen extends StatefulWidget {
  static const String routeName = 'comment.admin';
  static const String routePath = 'comments/admin';

  const UserCommentsAdminScreen({super.key, required this.sectionName, required this.sectionId});

  final String? sectionId;
  final String? sectionName;

  @override
  State<UserCommentsAdminScreen> createState() => _UserCommentsAdminScreenState();
}

class _UserCommentsAdminScreenState extends State<UserCommentsAdminScreen> {
  // DATAS ------------------------------------------------------------------------------------------------------------------>

  // INITIALIZER ------------------------------------------------------------------------------------------------------------>
  @override
  void initState() {
    super.initState();
  }

  // VIEW ------------------------------------------------------------------------------------------------------------------->
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Commentaires'),
        ),

        // --> BODY:
        body: RefreshIndicator(
          onRefresh: () async {},
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              CConstants.GOLDEN_SIZE,
              CConstants.GOLDEN_SIZE,
              CConstants.GOLDEN_SIZE,
              CConstants.GOLDEN_SIZE * 7,
            ),
            children: [
              CCommentsViewHandlerComponent(
                section: _provideGoodSection(),
                id: widget.sectionId ?? '--',
                administrator: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // METHODS ---------------------------------------------------------------------------------------------------------------->
  CSectionsTypesEnum _provideGoodSection() {
    CSectionsTypesEnum model = CSectionsTypesEnum.com;

    if (widget.sectionName == 'TEACHING') {
      model = CSectionsTypesEnum.teaching;
    } else if (widget.sectionName == 'ECHO') {
      model = CSectionsTypesEnum.echo;
    } else if (widget.sectionName == 'COM') {
      model = CSectionsTypesEnum.com;
    }

    return model;
  }
}
