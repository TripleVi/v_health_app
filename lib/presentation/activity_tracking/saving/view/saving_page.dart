import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enum/social.dart';
import '../../../../core/resources/colors.dart';
import '../../../../core/resources/style.dart';
import '../../../widgets/appBar.dart';
import '../../../widgets/dialog.dart';
import '../../../widgets/loading_indicator.dart';
import '../../bloc/activity_tracking_bloc.dart';
import '../cubit/saving_cubit.dart';

class SavingPage extends StatelessWidget {
  const SavingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final params = ModalRoute.of(context)!.settings.arguments as TrackingResult;
    return BlocProvider(
      create: (context) => SavingCubit(params),
      child: SavingView(),
    );
  }
}

class SavingView extends StatelessWidget {
  final _txtTitle = TextEditingController();
  final _txtContent = TextEditingController();

  SavingView({super.key});

  Widget _discardBtn(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: Icon(
        Icons.close_rounded,
        size: 24.0,
        color: AppColor.onBackgroundColor,
      ),
    );
  }

  Widget _resumeBtn(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: Text(
        "Resume",
        style: AppStyle.paragraph(color: AppColor.primaryColor),
      ),
    );
  }

  Future<void> _showModalBottomSheetHelper({
    required BuildContext context,
    required String title,
    required ListView child,
  }) {
    return showModalBottomSheet(
      backgroundColor: AppColor.backgroundColor,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppStyle.borderRadius)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppStyle.horizontalPadding,
            vertical: 4.0,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: AppStyle.heading_1(fontSize: 20.0, height: 1),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close_rounded,
                      color: AppColor.onBackgroundColor,
                      size: 24.0,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: child,
              ),
            ],
          ),
        );
      },
    );
  }

  ListView _postPrivacyListView(
    BuildContext context, 
    PostPrivacy selectedPrivacy,
  ) {
    return ListView(
      children: PostPrivacy.values.map((item) {
        return ListTile(
          onTap: () {
            Navigator.of(context).pop();
            context.read<SavingCubit>().selectPostPrivacy(item);
          },
          horizontalTitleGap: AppStyle.horizontalPadding,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppStyle.horizontalPadding,
          ),
          iconColor: AppColor.onBackgroundColor,
          selectedColor: AppColor.primaryColor,
          selected: item == selectedPrivacy,
          leading: Icon(
            item.iconData,
            size: 24.0,
            color: item == selectedPrivacy ? AppColor.primaryColor : null,
          ),
          title: Text(
            item.stringValue,
            style: AppStyle.heading_2(),
          ),
          subtitle: Text(
            item.description,
            style: AppStyle.paragraph(),
          ),
          trailing: item == selectedPrivacy
              ? const Icon(Icons.check_rounded, size: 32.0)
              : const SizedBox(width: 32.0),
        );
      }).toList(growable: false),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    String hintText = "",
    int minLines = 1,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      textAlignVertical: TextAlignVertical.center,
      style: AppStyle.paragraph(color: AppColor.textColor),
      controller: controller,
      cursorColor: AppColor.textColor,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppStyle.paragraph(),
        enabledBorder: OutlineInputBorder(
          borderRadius:
              const BorderRadius.all(Radius.circular(AppStyle.borderRadius)),
          borderSide: BorderSide(color: AppColor.controlNormalColor),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(AppStyle.borderRadius)),
          borderSide: BorderSide(color: AppColor.textColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppStyle.horizontalPadding,
          vertical: 12.0,
        ),
      ),
      minLines: minLines,
      maxLines: maxLines,
    );
  }

  Widget _dropdownButton({
    required BuildContext context,
    required void Function() onTap,
    required IconData prefixIconData,
    String? content,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52.0,
        padding:
            const EdgeInsets.symmetric(horizontal: AppStyle.horizontalPadding),
        decoration: BoxDecoration(
          color: AppColor.secondaryColor,
          border: Border.all(color: AppColor.controlNormalColor),
          borderRadius:
              const BorderRadius.all(Radius.circular(AppStyle.borderRadius)),
        ),
        child: Row(
          children: [
            Icon(
              prefixIconData,
              color: AppColor.textColor,
              size: 20.0,
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                content ?? "Choose",
                style: AppStyle.paragraph(
                  color: content == null
                      ? AppColor.paragraphColor
                      : AppColor.textColor,
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            const Icon(
              Icons.keyboard_arrow_down,
              color: AppColor.textColor,
              size: 24.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _mapSection(BuildContext context, SavingLoaded state) {
    return AspectRatio(
      aspectRatio: 2 / 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppStyle.borderRadius),
        child: Image.file(state.map,
          filterQuality: FilterQuality.high,
          fit: BoxFit.contain,
          isAntiAlias: true,
          errorBuilder: (context, error, stackTrace) {
            print("$error: $stackTrace");
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColor.controlNormalColor),
                borderRadius: const BorderRadius
                    .all(Radius.circular(AppStyle.borderRadius)),
              ),
              child: Center(
                child: Icon(
                  Icons.broken_image_rounded, 
                  color: AppColor.onBackgroundColor, 
                  size: 40.0,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _mainSection(BuildContext context, SavingLoaded state) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppStyle.horizontalPadding,
            vertical: 16.0,
          ),
          child: Wrap(
            runSpacing: 16.0,
            children: [
              _textField(
                controller: _txtTitle,
                hintText: state.titleHint,
                maxLines: 3,
              ),
              _textField(
                controller: _txtContent,
                hintText: "How'd it go? Share more about your activity.",
                minLines: 5,
                maxLines: 12,
                keyboardType: TextInputType.multiline,
              ),
              _mapSection(context, state),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text("Visibility", style: AppStyle.heading_1()),
                  const SizedBox(height: 20.0),
                  Wrap(
                    runSpacing: 16,
                    children: [
                      Text("Who can see", style: AppStyle.heading_2()),
                      _dropdownButton(
                        context: context,
                        onTap: () => _showModalBottomSheetHelper(
                          context: context,
                          title: "Who can see this activity?",
                          child: _postPrivacyListView(
                              context, state.privacy),
                        ),
                        content: state.privacy.stringValue,
                        prefixIconData: state.privacy.iconData,
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 350.0)
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.all(AppStyle.horizontalPadding),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColor.secondaryColor,
              boxShadow: [
                BoxShadow(
                  color: AppColor.onBackgroundColor,
                  blurRadius: 4.0,
                ),
              ],
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 40.0),
              child: TextButton(
                onPressed: () => context.read<SavingCubit>().savePost(
                  title: _txtTitle.text,
                  content: _txtContent.text,
                ),
                style: TextButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppStyle.borderRadius),
                  ),
                ),
                child: Text(
                  "Save Activity",
                  style: AppStyle.heading_2(
                      color: AppColor.secondaryColor),
                ),
              ),
            ),
          ),
        ),
        state.isProcessing 
            ? const AppProcessingIndicator() 
            : const SizedBox(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: CustomAppBar.get(
        actions: [_discardBtn(context)],
        title: "Save Activity",
        leading: _resumeBtn(context),
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColor.onBackgroundColor),
          ),
        ),
        child: BlocConsumer<SavingCubit, SavingState>(
          listener: (blocContext, state) {
            if (state is SavingLoaded && state.errorMsg != null) {
              MyDialog.showSingleOptionsDialog(
                context: context, 
                title: "Post Creation", 
                message: state.errorMsg!,
              );
            } else if (state is SavingSuccess) {
              Navigator.pop<bool>(context, true);
            }
          },
          builder: (context, state) {
            if (state is SavingLoading) {
              return const AppLoadingIndicator();
            }
            if (state is SavingLoaded) {
              return _mainSection(context, state);
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
