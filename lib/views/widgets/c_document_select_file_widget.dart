import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/theme/c_transition_thme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class CDocumentSelectFileWidget extends StatefulWidget {
  const CDocumentSelectFileWidget({super.key, required this.onSelect});

  final Function(String? filePath)? onSelect;

  @override
  State<CDocumentSelectFileWidget> createState() => _CDocumentSelectFileWidgetState();
}

class _CDocumentSelectFileWidgetState extends State<CDocumentSelectFileWidget> {
  // DATAS ------------------------------------------------------------------------------------------------------------------>
  XFile? selectedFile;

  // INITIALIZER ------------------------------------------------------------------------------------------------------------>
  @override
  void setState(VoidCallback fn) => super.setState(fn);

  // VIEW ------------------------------------------------------------------------------------------------------------------->
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: CConstants.GOLDEN_SIZE),
      child: Padding(
        padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE / 2),
        child: Row(children: [
          // Pan
          const SizedBox(width: CConstants.GOLDEN_SIZE),
          Expanded(
            child: GestureAnimator(
              onTap: selectedFile == null && widget.onSelect != null ? selectFile : null,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text("Attacher un document : docx, doc, pfd ou txt"),
                Text(selectedFile?.name ?? 'Aucun document sélectionné', style: Theme.of(context).textTheme.labelMedium),
              ]),
            ),
          ),

          // -- Action --
          if (selectedFile == null)
            IconButton.filledTonal(
              onPressed: widget.onSelect == null ? null : selectFile,
              icon: const Icon(CupertinoIcons.rectangle_paperclip),
            ).animate(effects: CTransitionsTheme.model_1)
          else
            IconButton(onPressed: widget.onSelect == null ? null : unSelectFile, icon: const Icon(Icons.close)),
        ]),
      ),
    );
  }

  // METHOD ----------------------------------------------------------------------------------------------------------------->
  Future<void> selectFile() async {
    FilePickerResult? filePicker = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['doc', 'docx', 'txt', 'pdf'],
    );

    setState(() => selectedFile = filePicker?.xFiles.first);

    widget.onSelect?.call(selectedFile?.path);
  }

  void unSelectFile() => setState(() {
        selectedFile = null;
        widget.onSelect?.call(null);
      });
}
