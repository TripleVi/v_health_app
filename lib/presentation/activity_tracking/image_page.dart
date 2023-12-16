import 'dart:io' as io;

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/resources/colors.dart';
import '../../core/resources/style.dart';
import '../widgets/image_editor.dart';
import '../widgets/loading_indicator.dart';

class ImageView extends StatefulWidget {
  final String? url;
  final io.File? file;
  final void Function() onDelete;
  final void Function() onSave;
  final void Function(Uint8List originalBytes, Uint8List bytes) onEdited;

  const ImageView({
    this.url,
    this.file,
    required this.onDelete,
    required this.onSave, 
    required this.onEdited,
    super.key,
  });

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  late final Uint8List _originalBytes;
  Uint8List? _bytes;
  final _visibilityChange = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _loadBytes();
  }

  Future<void> _loadBytes() async {
    if(widget.url != null) {
      _originalBytes = (await NetworkAssetBundle(Uri.parse(widget.url!))
        .load(widget.url!)).buffer.asUint8List();
    }else if(widget.file != null) {
      _originalBytes = await widget.file!.readAsBytes();
    }
    setState(() {
      _bytes = _originalBytes;
    });
  }

  Future<bool?> _showConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete Photo?'),
        content: const Text('Are you sure to delete this photo?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop<bool>(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop<bool>(context, true),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _optionsSection(BuildContext context) {
    return showModalBottomSheet<void>(
      constraints: const BoxConstraints(
        minHeight: 200.0,
        minWidth: double.infinity,
      ),
      backgroundColor: AppColor.backgroundColor,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12.0),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppStyle.horizontalPadding,
            vertical: 4.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: ListTile.divideTiles(
              context: context,
              color: Colors.grey.shade400,
              tiles: [
                TextButton(
                  onPressed: () {
                    widget.onSave();
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text("Save Photo",
                      textAlign: TextAlign.center,
                      style: AppStyle.heading_2(height: 1.0),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop<void>(context);
                    final value = await Navigator.push<Uint8List>(
                      context, 
                      MaterialPageRoute(builder: (context) => ImageEditor(_bytes!)),
                    );
                    if(value != null) {
                      // widget._file.writeAsBytesSync(value);
                      setState(() {
                        _bytes = value;
                      });
                    }
                  }, 
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: SizedBox( 
                    width: double.infinity,
                    child: Text("Edit Photo",
                      textAlign: TextAlign.center,
                      style: AppStyle.heading_2(height: 1.0),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _showConfirmationDialog(context).then((value) {
                      if(value == true) {
                        Navigator.pop<void>(context);
                        Navigator.pop<void>(context);
                        widget.onDelete();
                      }
                    });
                  }, 
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text("Delete Photo",
                      textAlign: TextAlign.center,
                      style: AppStyle.heading_2(height: 1.0),
                    ),
                  ),
                ),
              ],
            ).toList(growable: false),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).viewPadding.top;
    return GestureDetector(
      onTap: () => _visibilityChange.value = !_visibilityChange.value,
      child: Container(
        color: Colors.black87.withOpacity(0.8),
        margin: EdgeInsets.only(top: statusBarHeight),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            _bytes == null 
                ? const AppLoadingIndicator()
                : ExtendedImage.memory(_bytes!,
                  fit: BoxFit.contain,
                  enableLoadState: true,
                  filterQuality: FilterQuality.high,
                  isAntiAlias: true,
                  mode: ExtendedImageMode.gesture,
                  initGestureConfigHandler: (state) {
                    return GestureConfig(
                      minScale: 0.9,
                      animationMinScale: 0.7,
                      maxScale: 3.0,
                      animationMaxScale: 3.5,
                      speed: 1.0,
                      inertialSpeed: 100.0,
                      initialScale: 1.0,
                      inPageView: false,
                    );
                  },
                ),
            ValueListenableBuilder(
              builder: (context, value, child) {
                return value
                  ? Align(
                      alignment: AlignmentDirectional.topCenter,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop<void>(context),
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              minimumSize: Size.zero,
                              backgroundColor: Colors.white,
                              shadowColor: Colors.white,
                              foregroundColor: Colors.white,
                              surfaceTintColor: Colors.white,
                              padding: const EdgeInsets.all(2.0),
                            ),
                            child: Icon(Icons.close_rounded,
                              color: AppColor.onBackgroundColor,
                              size: 32.0,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _optionsSection(context);
                            },
                            iconSize: 32.0,
                            icon: const Icon(Icons.more_horiz_rounded, 
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox();
              },
              valueListenable: _visibilityChange,
            ),
          ],
        ),
      ),
    );
  }
}