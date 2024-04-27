import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../../core/enum/social.dart";
import "../../../../core/resources/style.dart";
import "../../../widgets/app_bar.dart";
import "../../../widgets/dialog.dart";
import "../../../widgets/loading_indicator.dart";
import "../../bloc/activity_tracking_bloc.dart";
import "../cubit/saving_cubit.dart";

class SavingPage extends StatelessWidget {
  const SavingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final params = ModalRoute.of(context)!.settings.arguments as TrackingResult;
    return BlocProvider(
      create: (context) => SavingCubit(params),
      child: const SavingView(),
    );
  }
}

class SavingView extends StatelessWidget {
  const SavingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.surfaceColor,
      appBar: CustomAppBar.get(
        actions: appBarActions(context),
        title: "Create post",
      ),
      body: Center(
        child: Container(
          height: double.infinity,
          constraints: const BoxConstraints(maxWidth: 520.0),
          padding: const EdgeInsets.all(12.0),
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
      ),
    );
  }

  List<Widget> appBarActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          Navigator.pop<void>(context);
          context
            .read<ActivityTrackingBloc>().add(const TrackingDestroyed());
        },
        icon: const Icon(Icons.delete_outline_rounded),
      ),
      TextButton(
        onPressed: () => context.read<SavingCubit>().savePost(),
        child: const Text("Post"),
      ),
    ];
  }

  Future<void> _showModalBottomSheetHelper({
    required BuildContext context,
    required String title,
    required ListView child,
  }) {
    return showModalBottomSheet(
      backgroundColor: AppStyle.surfaceColor,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppStyle.borderRadius)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: AppStyle.heading4()),
                  IconButton(
                    onPressed: () => Navigator.pop<void>(context),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppStyle.secondaryIconColor,
                      size: 20.0,
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
            Navigator.of(context).pop<void>();
            context.read<SavingCubit>().selectPostPrivacy(item);
          },
          horizontalTitleGap: AppStyle.horizontalPadding,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 0.0,
          ),
          iconColor: AppStyle.secondaryIconColor,
          selectedColor: AppStyle.primaryColor,
          selected: item == selectedPrivacy,
          leading: Icon(
            item.iconData,
            size: 20.0,
            color: item == selectedPrivacy ? AppStyle.primaryColor : null,
          ),
          title: Text(
            item.stringValue,
            style: AppStyle.heading5(),
          ),
          subtitle: Text(
            item.description,
            style: AppStyle.caption1(),
          ),
          trailing: item == selectedPrivacy
              ? const Icon(Icons.check_rounded, size: 20.0)
              : const SizedBox(width: 20.0),
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
      style: AppStyle.bodyText(),
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppStyle.borderRadius)),
          borderSide: BorderSide(color: AppStyle.neutralColor400),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppStyle.borderRadius)),
          borderSide: BorderSide(color: AppStyle.neutralColor400),
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
    required String content,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: AppStyle.surfaceColor,
          border: Border.all(color: AppStyle.neutralColor400),
          borderRadius:
              const BorderRadius.all(Radius.circular(AppStyle.borderRadius)),
        ),
        child: Row(
          children: [
            Icon(
              prefixIconData,
              color: AppStyle.primaryColor,
              size: 20.0,
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                content,
                style: AppStyle.bodyText(color: AppStyle.primaryColor),
              ),
            ),
            const SizedBox(width: 8.0),
            const Icon(
              Icons.keyboard_arrow_down,
              color: AppStyle.secondaryIconColor,
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
                border: Border.all(color: AppStyle.neutralColor400),
                borderRadius: const BorderRadius
                    .all(Radius.circular(AppStyle.borderRadius)),
              ),
              child: const Center(
                child: Icon(
                  Icons.broken_image_rounded, 
                  color: AppStyle.neutralColor400, 
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _textField(
                controller: state.titleController,
                hintText: state.titleHint,
                maxLines: 3,
              ),
              const SizedBox(height: 16.0),
              _textField(
                controller: state.contentController,
                hintText: "How'd it go? Share more about your activity.",
                minLines: 5,
                maxLines: 12,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 16.0),
              _mapSection(context, state),
              const SizedBox(height: 16.0),
              _dropdownButton(
                context: context,
                onTap: () => _showModalBottomSheetHelper(
                  context: context,
                  title: "Who can see this activity?",
                  child: _postPrivacyListView(context, state.privacy),
                ),
                content: state.privacy.stringValue,
                prefixIconData: state.privacy.iconData,
              ),
            ],
          ),
        ),
        state.isProcessing 
            ? const AppProcessingIndicator() 
            : const SizedBox(),
      ],
    );
  }
}
