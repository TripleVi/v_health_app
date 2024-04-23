import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_picker/flutter_picker.dart";

import "../../../../core/enum/user_enum.dart";
import "../../../../core/resources/style.dart";
import "../../../../core/utilities/utils.dart";
import "../../../widgets/app_bar.dart";
import "../../../widgets/loading_indicator.dart";
import "../cubit/signup_cubit.dart";

class SignUpPage extends StatelessWidget {
  // io.File? _avatar;
  // Uint8List? _editedAvatar;

  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(),
      child: BlocConsumer<SignUpCubit, SignUpState>(
        listener: (context, state) {
          if(state.snackMsg != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: AppStyle.surfaceColor,
              showCloseIcon: true,
              closeIconColor: AppStyle.secondaryIconColor,
              content: Text(
                state.snackMsg!,
                style: AppStyle.bodyText(),
              ),
            ));
          }
          if(state.success) {
            Navigator.pop<bool>(context, true);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              WillPopScope(
                onWillPop: () async {
                  _backPressed(context, state);
                  return false;
                },
                child: Scaffold(
                  backgroundColor: AppStyle.backgroundColor,
                  appBar: CustomAppBar.get(
                    title: "Sign up",
                    leading: GestureDetector(
                      onTap: () => _backPressed(context, state),
                      child: const Icon(Icons.arrow_back_rounded),
                    ),
                  ),
                  body: Center(
                    child: Container(
                      height: double.infinity,
                      constraints: const BoxConstraints(maxWidth: 320.0),
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(height: 40.0),
                                bodyBuilder(context, state),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: _buildProgressIndicator(context, state),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              state.isProcessing 
                ? const AppProcessingIndicator() 
                : const SizedBox(),
            ]
          );
        },
      )
    );
  }

  void _backPressed(BuildContext context, SignUpState state) {
    if (state.activeIndex == 0) {
      return Navigator.pop<bool>(context, false);
    }
    context.read<SignUpCubit>().previousForm();
  }

  Widget bodyBuilder(BuildContext context, SignUpState state) {
    switch (state.activeIndex) {
      case 1:
        return _buildPersonalForm(context, state);
      case 2:
        return _buildFitnessForm(context, state);
      case 0:
      default:
        return _buildCredentialForm(context, state);
    }
  }

  Function() submitBtnExecutor(BuildContext context, SignUpState state) {
    switch (state.activeIndex) {
      case 1:
        return () {
          if (!state.personalFormKey.currentState!.validate()) return;
          context.read<SignUpCubit>().nextForm();
        };
      case 2:
        return () {
          if(!state.fitnessFormKey.currentState!.validate()) return;
          MyUtils.closeKeyboard(context);
          context.read<SignUpCubit>().signUp();
        };
      case 0:
      default:
        return () {
          if(!state.credentialFormKey.currentState!.validate()) return;
          MyUtils.closeKeyboard(context);
          context.read<SignUpCubit>().submitCredentialForm();
        };
    }
  }

  Widget _buildProgressIndicator(BuildContext context, SignUpState state) {
    const btnWidth = 80.0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: btnWidth),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(state.totalIndex+1, (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              height: 6.0,
              width: 6.0,
              decoration: BoxDecoration(
                color: state.activeIndex == index
                    ? AppStyle.primaryColor
                    : AppStyle.secondaryIconColor,
                shape: BoxShape.circle,
              ),
            ), growable: false,
          ),
        ),
        _buildNextButton(btnWidth, submitBtnExecutor(context, state)),
      ],
    );
  }

  Widget _buildPaddedForm({
    required List<Widget> inputs,
    required String headline,
    required String description,
    required GlobalKey<FormState> formKey,
  }) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(headline, style: AppStyle.heading4()),
          const SizedBox(height: 8.0),
          Text(description, style: AppStyle.caption1()),
          const SizedBox(height: 32.0),
          Column(children: inputs),
        ],
      ),
    );
  }

  InputDecoration _getInputDecoration(String labelText) {
    return InputDecoration(
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppStyle.borderRadius)),
        borderSide: BorderSide(color: AppStyle.neutralColor400),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppStyle.borderRadius)),
        borderSide: BorderSide(color: AppStyle.neutralColor400),
      ),
      labelText: labelText,
      suffixIcon: const Icon(
        Icons.arrow_drop_down, 
        size: 24.0,
        color: AppStyle.secondaryIconColor,
      ),
    );
  }

  Widget _buildFitnessForm(BuildContext context, SignUpState state) {
    return _buildPaddedForm(
      headline: "How is your physical condition?",
      description: "Your fitness information will help the system calculate more accurate indicators.",
      formKey: state.fitnessFormKey,
      inputs: [
        TextFormField(
          readOnly: true,
          style: AppStyle.bodyText(),
          validator: MyUtils.requiredField,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onTap: () => showPickerNumber(
            context: context,
            title: "Height",
            description: "How tall are you in centimeters?",
            begin: 30,
            end: 272,
            jump: 1,
            initial: 150,
            onSaved: (values) {
              state.heightController.text = "${values.first} cm";
            },
          ),
          controller: state.heightController,
          decoration: _getInputDecoration("Height"),
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          readOnly: true,
          style: AppStyle.bodyText(),
          validator: MyUtils.requiredField,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onTap: () => showPickerNumber(
            context: context,
            title: "Weight",
            description: "How many kilograms do you weight?",
            begin: 30,
            end: 450,
            jump: 1,
            initial: 40,
            isDecimal: true,
            onSaved: (values) {
              state.weightController.text = "${values.first}.${values.last} kg";
            },
          ),
          controller: state.weightController,
          decoration: _getInputDecoration("Weight"),
        ),
      ],
    );
  }

  showPickerNumber({
    required BuildContext context,
    required String title,
    required String description,
    required int begin,
    required int end,
    required int jump,
    required int initial,
    bool isDecimal = false,
    required void Function(List<int>) onSaved,
  }) {
    BuildContext? dialogContext;
    final data = [NumberPickerColumn(
      begin: begin, 
      end: end, 
      jump: jump, 
      initValue: initial,
    )];
    if(isDecimal) {
      data.add(const NumberPickerColumn(
        begin: 0, 
        end: 9, 
        jump: 1, 
        initValue: 0,
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

  // Future<void> _onAvatarTapped(BuildContext context) async {
  //   if (_avatar == null) return;
  //   _editedAvatar = await Navigator.push<Uint8List>(
  //     context,
  //     MaterialPageRoute(builder: (context) => ImageEditor(_avatar!)),
  //   );
  //   if (_editedAvatar != null) {
  //     // setState(() {});
  //   }
  // }

  Widget _buildPersonalForm(BuildContext context, SignUpState state) {
    return _buildPaddedForm(
      headline: "Introduce yourself",
      description: "Your personal information is private. You can update it at any time.",
      formKey: state.personalFormKey,
      inputs: [
        // Row(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     Stack(
        //       clipBehavior: Clip.none,
        //       children: [
        //         Container(
        //           decoration: BoxDecoration(
        //             borderRadius: BorderRadius.circular(100.0),
        //             border: Border.all(
        //               color: AppStyle.neutralColor400,
        //               width: 2.0,
        //             ),
        //           ),
        //           child: GestureDetector(
        //             onTap: () => _onAvatarTapped(context),
        //             child: CircleAvatar(
        //               radius: 48.0,
        //               backgroundColor: Colors.white,
        //               backgroundImage: Image.asset(
        //                 "assets/images/avatar.jpg",
        //                 cacheWidth: 48,
        //                 cacheHeight: 48,
        //                 filterQuality: FilterQuality.high,
        //                 isAntiAlias: true,
        //                 fit: BoxFit.contain,
        //               ).image,
        //               foregroundImage: _editedAvatar != null
        //                   ? Image.memory(
        //                       _editedAvatar!,
        //                       filterQuality: FilterQuality.high,
        //                       isAntiAlias: true,
        //                       cacheWidth: 48,
        //                       cacheHeight: 48,
        //                       fit: BoxFit.contain,
        //                     ).image
        //                   : _avatar != null
        //                       ? Image.file(
        //                           io.File(_avatar!.path),
        //                           filterQuality: FilterQuality.high,
        //                           isAntiAlias: true,
        //                           cacheWidth: 48,
        //                           cacheHeight: 48,
        //                           fit: BoxFit.contain,
        //                         ).image
        //                       : null,
        //             ),
        //           ),
        //         ),
        //         Positioned(
        //           bottom: -12.0,
        //           right: -12.0,
        //           child: Container(
        //             width: 44.0,
        //             height: 44.0,
        //             alignment: AlignmentDirectional.center,
        //             decoration: BoxDecoration(
        //               borderRadius: BorderRadius.circular(100.0),
        //               border: Border.all(
        //                 color: AppStyle.surfaceColor,
        //                 width: 2.0,
        //               ),
        //             ),
        //             child: IconButton(
        //               iconSize: 24.0,
        //               padding: const EdgeInsets.all(6.0),
        //               onPressed: () => _showAvatarSelection(context),
        //               icon: const Icon(
        //                 Icons.add_a_photo_rounded,
        //                 color: Colors.white,
        //               ),
        //             ),
        //           )
        //         ),
        //       ],
        //     ),
        //   ],
        // ),
        // const SizedBox(height: 20.0),
        // TextFormField(
        //   validator: MyUtils.requiredTextField,
        //   autovalidateMode: AutovalidateMode.onUserInteraction,
        //   controller: _firstNameController,
        //   keyboardType: TextInputType.text,
        //   decoration: const InputDecoration(
        //     border: OutlineInputBorder(
        //       borderRadius: BorderRadius.all(Radius.circular(8.0)),
        //     ),
        //     labelText: "First name",
        //     contentPadding: EdgeInsets.all(20.0),
        //   ),
        // ),
        // const SizedBox(height: 20.0),
        // TextFormField(
        //   validator: MyUtils.requiredTextField,
        //   autovalidateMode: AutovalidateMode.onUserInteraction,
        //   controller: _lastNameController,
        //   keyboardType: TextInputType.text,
        //   decoration: const InputDecoration(
        //     border: OutlineInputBorder(
        //       borderRadius: BorderRadius.all(Radius.circular(8.0)),
        //     ),
        //     labelText: "Last name",
        //     contentPadding: EdgeInsets.all(20.0),
        //   ),
        // ),
        // const SizedBox(height: 20.0),
        InputDecorator(
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(AppStyle.borderRadius)),
              borderSide: BorderSide(color: AppStyle.neutralColor400),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(AppStyle.borderRadius)),
              borderSide: BorderSide(color: AppStyle.neutralColor400),
            ),
            labelText: "Gender",
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<UserGender>(
              style: AppStyle.bodyText(),
              iconEnabledColor: AppStyle.secondaryIconColor,
              dropdownColor: AppStyle.surfaceColor,
              value: state.gender,
              isDense: true,
              items: UserGender.values.map((value) => DropdownMenuItem(
                value: value, 
                child: Text(value.stringValue),
              )).toList(growable: false),
              onChanged: (value) {
                if(value == null) return;
                context.read<SignUpCubit>().selectGender(value);
              },
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          validator: MyUtils.requiredField,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: state.dobController,
          readOnly: true,
          style: AppStyle.bodyText(),
          onTap: () => showDatePicker(
            context: context,
            initialDate: DateTime(DateTime.now().year-6),
            firstDate: DateTime(DateTime.now().year-150),
            lastDate: DateTime(DateTime.now().year-6, 12, 31),
          ).then((value) {
            if(value == null) return;
            state.dobController.text = MyUtils.getFormattedDate1(value);
          }),
          decoration: const InputDecoration(
            labelText: "Date of Birth",
            suffixIcon: Icon(
              Icons.event,
              size: 24.0,
              color: AppStyle.secondaryIconColor,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(AppStyle.borderRadius)),
              borderSide: BorderSide(color: AppStyle.neutralColor400),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(AppStyle.borderRadius)),
              borderSide: BorderSide(color: AppStyle.neutralColor400),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCredentialForm(BuildContext context, SignUpState state) {
    return _buildPaddedForm(
      headline: "Create your account",
      description: "You can log into the system using your username and password.",
      formKey: state.credentialFormKey,
      inputs: [
        TextFormField(
          validator: MyUtils.usernameValidator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: state.usernameController,
          keyboardType: TextInputType.text,
          style: AppStyle.bodyText(),
          decoration: InputDecoration(
            errorMaxLines: 2,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(AppStyle.borderRadius)),
              borderSide: BorderSide(color: AppStyle.neutralColor400),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(AppStyle.borderRadius)),
              borderSide: BorderSide(color: AppStyle.neutralColor400),
            ),
            labelText: "Username",
            errorText: state.errorMsg,
          ),
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          obscureText: !state.passwordVisible,
          validator: MyUtils.passwordValidator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: state.passwordController,
          keyboardType: TextInputType.visiblePassword,
          style: AppStyle.bodyText(),
          decoration: InputDecoration(
            errorMaxLines: 3,
            suffixIcon: GestureDetector(
              onTapUp: (_) => context.read<SignUpCubit>().togglePassword(),
              onTapDown: (_) => context.read<SignUpCubit>().togglePassword(),
              onLongPressEnd: (_) => context.read<SignUpCubit>().togglePassword(),
              child: Icon(
                state.passwordVisible ? Icons.visibility : Icons.visibility_off, 
                size: 24.0,
                color: AppStyle.secondaryIconColor,
              ),
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(AppStyle.borderRadius)),
              borderSide: BorderSide(color: AppStyle.neutralColor400),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(AppStyle.borderRadius)),
              borderSide: BorderSide(color: AppStyle.neutralColor400),
            ),
            labelText: "Password",
          ),
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          obscureText: !state.confirmPasswordVisible,
          validator: (value) {
            if(value == null || value.isEmpty) {
              return "Please fill this field";
            }
            return value == state.passwordController.text 
                ? null 
                : "Confirm password does not match.";
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: state.confirmPasswordController,
          keyboardType: TextInputType.visiblePassword,
          style: AppStyle.bodyText(),
          decoration: InputDecoration(
            suffixIcon: GestureDetector(
              onTapUp: (_) => context.read<SignUpCubit>().toggleConfirmPassword(),
              onTapDown: (_) => context.read<SignUpCubit>().toggleConfirmPassword(),
              onLongPressEnd: (_) => context.read<SignUpCubit>().toggleConfirmPassword(),
              child: Icon(
                state.passwordVisible ? Icons.visibility : Icons.visibility_off, 
                size: 24.0,
                color: AppStyle.secondaryIconColor,
              ),
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(AppStyle.borderRadius)),
              borderSide: BorderSide(color: AppStyle.neutralColor400),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(AppStyle.borderRadius)),
              borderSide: BorderSide(color: AppStyle.neutralColor400),
            ),
            labelText: "Confirm Password",
          ),
        ),
      ],
    );
  }

  Widget _buildNextButton(double width, void Function() onPressed) {
    return SizedBox(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: Size.fromWidth(width),
          backgroundColor: AppStyle.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppStyle.borderRadius),
          ),
        ),
        child: Text(
          "Next",
          style: AppStyle.caption1(color: AppStyle.pBtnTextColor),
        ),
      ),
    );
  }

  Widget _avatarSelectionItem({
    required String title,
    required IconData iconData,
    Color? iconColor,
    required void Function() onTap,
  }) {
    return ListTile(
      onTap: onTap,
      horizontalTitleGap: AppStyle.horizontalPadding,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppStyle.horizontalPadding,
      ),
      iconColor: iconColor ?? Colors.grey.shade500,
      leading: Icon(
        iconData,
        size: 28.0,
      ),
      title: Text(
        title,
        style: AppStyle.heading2(),
      ),
    );
  }

  // Future<io.File?> _pickPhotoFromLibrary() async {
  //   final images = await AssetPicker.pickAssets(
  //     context,
  //     pickerConfig: const AssetPickerConfig(
  //       textDelegate: EnglishAssetPickerTextDelegate(),
  //       maxAssets: 1,
  //       gridThumbnailSize: ThumbnailSize.square(100),
  //       requestType: RequestType.image,
  //     ),
  //     useRootNavigator: false,
  //   );
  //   return images?.first.file;
  // }

  // Future<void> _showAvatarSelection(BuildContext context) {
  //   return showModalBottomSheet<void>(
  //     constraints: BoxConstraints.loose(const Size(double.infinity, 160.0)),
  //     backgroundColor: AppStyle.surfaceColor,
  //     context: context,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(
  //         top: Radius.circular(AppStyle.borderRadius),
  //       ),
  //     ),
  //     builder: (context) {
  //       return Padding(
  //         padding: const EdgeInsets.symmetric(
  //           horizontal: AppStyle.horizontalPadding,
  //           vertical: 4.0,
  //         ),
  //         child: Column(
  //           children: [
  //             _avatarSelectionItem(
  //               onTap: () async {
  //                 // Navigator.pop<void>(context);
  //                 // final file = await _pickPhotoFromLibrary();
  //                 // if (file != null) {
  //                 //   setState(() {
  //                 //     _avatar = file;
  //                 //     _editedAvatar = null;
  //                 //   });
  //                 //   _onAvatarTapped();
  //                 // }
  //               },
  //               title: "Choose from library",
  //               iconData: Icons.photo_outlined,
  //             ),
  //             _avatarSelectionItem(
  //               onTap: () async {
  //                 Navigator.pop<void>(context);
  //                 final params = await Navigator.push<PictureParams>(
  //                   context,
  //                   MaterialPageRoute(builder: (context) => const CameraPage()),
  //                 );
  //                 if (params?.file != null) {
  //                   // setState(() {
  //                   //   _avatar = params!.file;
  //                   //   _editedAvatar = null;
  //                   // });
  //                   _onAvatarTapped(context);
  //                 }
  //               },
  //               title: "Take picture",
  //               iconData: Icons.camera_alt_outlined,
  //             ),
  //             _avatar != null
  //                 ? _avatarSelectionItem(
  //                     onTap: () {
  //                       // Navigator.pop<void>(context);
  //                       // setState(() {
  //                       //   _avatar = null;
  //                       //   _editedAvatar = null;
  //                       // });
  //                     },
  //                     title: "Remove current picture",
  //                     iconData: Icons.delete_outline,
  //                     iconColor: AppStyle.dangerColor,
  //                   )
  //                 : const SizedBox(),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
}
