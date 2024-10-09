import 'package:flutter/cupertino.dart';
import 'package:quiz_app_flutter/services/media/media_service_interface.dart';

class ImagePickerActionSheet extends StatelessWidget {
  const ImagePickerActionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: const Text('Take Photo'),
          onPressed: () => Navigator.of(context).pop(AppImageSource.camera),
        ),
        CupertinoActionSheetAction(
          child: const Text('Upload From Gallery'),
          onPressed: () => Navigator.of(context).pop(AppImageSource.gallery),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: const Text('Cancel'),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}
