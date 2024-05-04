import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_picker/flutter_picker.dart";

import "../../../../core/enum/user_enum.dart";
import "../../../../core/resources/style.dart";
import "../../../../core/utilities/utils.dart";
import "../../../widgets/app_bar.dart";
import "../cubit/profile_details_cubit.dart";

class ProfileDetailsPage extends StatelessWidget {
  const ProfileDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileDetailsCubit>(
      create: (context) => ProfileDetailsCubit(),
      child: const ProfileDetailsView(),
    );
  }
}

class ProfileDetailsView extends StatelessWidget {
  const ProfileDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.get(title: "Edit profile"),
      backgroundColor: AppStyle.surfaceColor,
      body: Container(
        height: double.infinity,
        constraints: const BoxConstraints(maxWidth: 520.0),
        padding: const EdgeInsets.all(12.0),
        child: BlocConsumer<ProfileDetailsCubit, ProfileDetailsState>(
          listener: (context, state) {
            if(state is ProfileDetailsLoaded && state.snackMsg != null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: AppStyle.backgroundColor,
                showCloseIcon: true,
                closeIconColor: AppStyle.secondaryIconColor,
                content: Text(
                  state.snackMsg!,
                  style: AppStyle.bodyText(),
                ),
              ));
            }
          },
          builder: (context, state) {
            if(state is ProfileDetailsLoading) {
              return const SizedBox();
            }
            if(state is ProfileDetailsLoaded) {
              return _mainContent(context, state);
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _mainContent(BuildContext context, ProfileDetailsLoaded state) {
    const iconSize = 72;
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: iconSize / 2,
                    backgroundColor: AppStyle.surfaceColor,
                    backgroundImage: Image.asset(
                      "assets/images/avatar.jpg",
                      cacheWidth: iconSize,
                      cacheHeight: iconSize,
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.contain,
                      isAntiAlias: true,
                    ).image,
                    foregroundImage: CachedNetworkImageProvider(
                      state.user.avatarUrl, 
                      maxWidth: iconSize, 
                      maxHeight: iconSize,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {

                    },
                    child: Container(
                      width: iconSize*1.0,
                      height: iconSize*1.0,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.photo_camera_outlined,
                        size: 24.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Text("Change avatar", style: AppStyle.heading5()),
            ],
          ),
          const SizedBox(height: 36.0),
          SizedBox(
            width: double.infinity, 
            child: Text(
              "About you", 
              style: AppStyle.caption1(), 
              textAlign: TextAlign.start,
            ),
          ),
          const SizedBox(height: 8.0),
          userInfoItem(
            onTap: () {
              Navigator
                  .pushNamed<bool>(context, "/profileForm", arguments: 0)
                  .then<void>((value) {
                    if(value == true) {
                      context.read<ProfileDetailsCubit>().onProfileEdited();
                    }
                  });
            },
            label: "Name",
            content: state.user.name,
          ),
          userInfoItem(
            onTap: () {
              Navigator
                  .pushNamed<bool>(context, "/profileForm", arguments: 1)
                  .then<void>((value) {
                    if(value == true) {
                      context.read<ProfileDetailsCubit>().onProfileEdited();
                    }
                  });
            },
            label: "Username",
            content: state.user.username,
          ),
          userInfoItem(
            onTap: () => showGenderPicker(
              context: context,
              initValue: state.user.gender.index,
              onSaved: (values) {
                context.read<ProfileDetailsCubit>().updateGender(values.first);
              },
            ),
            label: "Gender",
            content: state.user.gender.name,
          ),
          userInfoItem(
            onTap: () {},
            label: "Date of birth",
            content: state.user.dateOfBirth,
          ),
          userInfoItem(
            onTap: () {
              final values = state.user.weight.toString().split(".");
              showPickerNumber(
                context: context,
                title: "Weight",
                description: "How many kilograms do you weight?",
                begin: 30,
                end: 450,
                jump: 1,
                wholeInit: int.parse(values.first),
                fractionalInit: int.parse(values.last),
                isDecimal: true,
                onSaved: (values) {
                  final txtValue = "${values.first}.${values.last}";
                  context.read<ProfileDetailsCubit>().updateWeight(txtValue);
                },
              );
            },
            label: "Weight",
            content: "${state.user.weight} kg",
          ),
          userInfoItem(
            onTap: () => showPickerNumber(
              context: context,
              title: "Height",
              description: "How tall are you in centimeters?",
              begin: 30,
              end: 272,
              jump: 1,
              wholeInit: state.user.height,
              onSaved: (values) {
                context.read<ProfileDetailsCubit>().updateHeight(values.first);
              },
            ),
            label: "Height",
            content: "${state.user.height} cm",
          ),
        ],
      ),
    );
  }

  Widget userInfoItem({
    required String label,
    required String content,
    IconData? iconData,
    required void Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppStyle.bodyText()),
            Row(
              children: [
                Text(content, style: AppStyle.bodyText()),
                const SizedBox(width: 2.0),
                Icon(
                  iconData ?? Icons.arrow_forward_ios_rounded,
                  size: 12.0,
                  color: AppStyle.secondaryIconColor,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  showPickerNumber({
    required BuildContext context,
    required String title,
    required String description,
    required int begin,
    required int end,
    required int jump,
    required int wholeInit,
    int? fractionalInit,
    bool isDecimal = false,
    required void Function(List<int>) onSaved,
  }) {
    BuildContext? dialogContext;
    final data = [NumberPickerColumn(
      begin: begin, 
      end: end, 
      jump: jump, 
      initValue: wholeInit,
    )];
    if(isDecimal) {
      data.add(NumberPickerColumn(
        begin: 0, 
        end: 9, 
        jump: 1, 
        initValue: fractionalInit,
      ));
    }
    Picker(
      adapter: NumberPickerAdapter(data: data),
      textStyle: AppStyle.bodyText(),
      itemExtent: 40.0,
      cancel: const SizedBox(),
      confirmText: "OK",
      backgroundColor: AppStyle.surfaceColor,
      confirmTextStyle: const TextStyle(color: AppStyle.primaryColor),
      hideHeader: true,
      delimiter: isDecimal ? [PickerDelimiter(
        child: Container(
          width: 4.0,
          height: 4.0,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppStyle.neutralColor400,
          ),
        ),
      )] : null,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title, style: AppStyle.heading3()),
              ),
              const SizedBox(width: 8.0),
              GestureDetector(
                onTap: () => Navigator.pop<void>(dialogContext!),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                    color: AppStyle.sBtnBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 20.0,
                    color: AppStyle.primaryIconColor,
                  ),
                )
              ),
            ],
          ),
          const SizedBox(height: 4.0),
          Text(description, style: AppStyle.caption1()),
        ],
      ),
      onConfirm: (Picker picker, List value) {
        onSaved(List<int>.from(picker.getSelectedValues()));
      }
    ).showDialog(
      context, 
      backgroundColor: AppStyle.surfaceColor, 
      surfaceTintColor: AppStyle.surfaceColor,
      builder: (context, pickerWidget) {
        dialogContext = context;
        return pickerWidget;
      },
    );
  }

  showGenderPicker({
    required BuildContext context,
    required int initValue,
    required void Function(List<int>) onSaved,
  }) {
    BuildContext? dialogContext;
    Picker(
      adapter: NumberPickerAdapter(data: [
        NumberPickerColumn(
          begin: 0, 
          end: 1, 
          jump: 1, 
          initValue: initValue,
          onFormatValue: (value) => UserGender.values[value].name,
        ),
      ]),
      textStyle: AppStyle.bodyText(),
      itemExtent: 40.0,
      cancel: const SizedBox(),
      confirmText: "OK",
      backgroundColor: AppStyle.surfaceColor,
      confirmTextStyle: const TextStyle(color: AppStyle.primaryColor),
      hideHeader: true,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text("Gender", style: AppStyle.heading3()),
              ),
              const SizedBox(width: 8.0),
              GestureDetector(
                onTap: () => Navigator.pop<void>(dialogContext!),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                    color: AppStyle.sBtnBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 20.0,
                    color: AppStyle.primaryIconColor,
                  ),
                )
              ),
            ],
          ),
          const SizedBox(height: 4.0),
          Text("What is your gender?", style: AppStyle.caption1()),
        ],
      ),
      onConfirm: (Picker picker, List value) {
        onSaved(List<int>.from(picker.getSelectedValues()));
      }
    ).showDialog(
      context, 
      backgroundColor: AppStyle.surfaceColor, 
      surfaceTintColor: AppStyle.surfaceColor,
      builder: (context, pickerWidget) {
        dialogContext = context;
        return pickerWidget;
      },
    );
  }
}