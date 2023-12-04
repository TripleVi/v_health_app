import 'dart:io' as io;
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as i;

import '../../core/resources/colors.dart';
import '../../core/resources/style.dart';


class ImageEditor extends StatelessWidget {
  final _editorKey = GlobalKey<ExtendedImageEditorState>();
  final io.File _file;

  ImageEditor(this._file, {super.key});

  Uint8List _editImage() {
    final state = _editorKey.currentState!;
    final editAction = state.editAction!;
    final cropRect = state.getCropRect()!;
    final data = state.rawImageData;
    var src = i.decodeJpg(data)!;
    i.bakeOrientation(src);
    if(editAction.needCrop) {
      src = i.copyCrop(src,
        x: cropRect.left.toInt(), y: cropRect.top.toInt(), 
        width: cropRect.width.toInt(), height: cropRect.height.toInt(),
      );
    }
    if (editAction.needFlip) {
      i.FlipDirection direction;
      if (editAction.flipY) {
        direction = i.FlipDirection.horizontal;
      } else if (editAction.flipX) {
        direction = i.FlipDirection.vertical;
      } else {
        direction = i.FlipDirection.both;
      }
      src = i.flip(src, direction: direction);
    }
    if (editAction.hasRotateAngle) {
      src = i.copyRotate(src, angle: editAction.rotateAngle);
    }
    return i.encodeJpg(src);
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).viewPadding.top),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel", 
                  style: AppStyle.paragraph(
                    color: Colors.white,
                    height: 1.0,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  try {
                    final rawImage = _editImage();
                    Navigator.pop<Uint8List>(context, rawImage);
                  } catch (e) {
                    print(e);
                    Navigator.pop<void>(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        "Image editing failed. Please re-try!",
                        style: AppStyle.paragraph(color: AppColor.dangerColor),
                      ),
                    ));
                  }
                },
                child: Text(
                  "Done", 
                  style: AppStyle.paragraph(
                    color: Colors.white,
                    height: 1.0,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ExtendedImage.file(_file,
              fit: BoxFit.contain,
              mode: ExtendedImageMode.editor,
              filterQuality: FilterQuality.high,
              isAntiAlias: true,
              cacheRawData: true,
              extendedImageEditorKey: _editorKey,
              initEditorConfigHandler: (state) {
                return EditorConfig(
                  maxScale: 1.0,
                  hitTestSize: 20.0,
                  cropAspectRatio: CropAspectRatios.ratio1_1,
                  lineColor: Colors.white,
                  cornerColor: Colors.white,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    final state = _editorKey.currentState!;
                    state.rotate();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.rotate_right_sharp, 
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          "Rotate", 
                          style: AppStyle.paragraph(
                            color: Colors.white, 
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    final state = _editorKey.currentState!;
                    state.reset();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 24.0),
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.restore_sharp, 
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          "Reset", 
                          style: AppStyle.paragraph(
                            color: Colors.white, 
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    final state = _editorKey.currentState!;
                    state.flip();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.flip_rounded, 
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          "Flip", 
                          style: AppStyle.paragraph(
                            color: Colors.white, 
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}