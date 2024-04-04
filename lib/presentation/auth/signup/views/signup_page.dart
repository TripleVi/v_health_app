import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enum/user_enum.dart';
import '../../../../core/resources/style.dart';
import '../../../../core/utilities/utils.dart';
import '../../../../domain/entities/user.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/loading_indicator.dart';
import '../cubit/signup_cubit.dart';

class SignUpPage extends StatelessWidget {
  final _dobController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _credentialFormKey = GlobalKey<FormState>();
  final _personalFormKey = GlobalKey<FormState>();
  final _fitnessFormKey = GlobalKey<FormState>();

  var _gender = UserGender.male;
  // io.File? _avatar;
  // Uint8List? _editedAvatar;

  SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(),
      child: BlocConsumer<SignUpCubit, SignUpState>(
        listener: (context, state) {
          if(state.snackMsg != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
                  backgroundColor: AppStyle.surfaceColor,
                  appBar: CustomAppBar.get(
                    title: "Sign up",
                    leading: GestureDetector(
                      onTap: () => _backPressed(context, state),
                      child: const Icon(Icons.arrow_back_rounded, size: 32.0),
                    ),
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        bodyBuilder(context, state), 
                        _buildProgressIndicator(state),
                      ],
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
        return _buildFitnessForm(context);
      case 0:
      default:
        return _buildCredentialForm(context, state);
    }
  }

  Widget _buildProgressIndicator(SignUpState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(state.totalIndex+1, (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          height: 4.0,
          width: 40.0,
          color: state.activeIndex == index
              ? AppStyle.primaryColor
              : Colors.black54,
        ), growable: false,
      ),
    );
  }

  Widget _buildPaddedForm({
    required List<Widget> inputs,
    required String headline,
    required String description,
    required GlobalKey<FormState> formKey,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40.0),
            Text(headline, style: AppStyle.heading1(height: 1.0)),
            const SizedBox(height: 4.0),
            Text(description, style: AppStyle.bodyText()),
            const SizedBox(height: 28.0),
            Column(children: inputs),
          ],
        ),
      ),
    );
  }

  InputDecoration _getInputDecoration(String labelText) {
    return InputDecoration(
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      labelText: labelText,
      contentPadding: const EdgeInsets.all(20.0),
    );
  }

  Widget _buildFitnessForm(BuildContext context) {
    return _buildPaddedForm(
      headline: "Fitness Status",
      description: "Let's get to know more about your current fitness status.",
      formKey: _fitnessFormKey,
      inputs: [
        TextFormField(
          validator: MyUtils.requiredDoubleField,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: _heightController,
          keyboardType: const TextInputType.numberWithOptions(decimal: false),
          decoration: _getInputDecoration("Height"),
        ),
        const SizedBox(height: 20.0),
        TextFormField(
          validator: MyUtils.requiredDoubleField,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: _weightController,
          keyboardType: const TextInputType.numberWithOptions(decimal: false),
          decoration: _getInputDecoration("Weight"),
        ),
        const SizedBox(height: 20.0),
        _buildNextButton(() {
          if(!_fitnessFormKey.currentState!.validate()) return;
          MyUtils.closeKeyboard(context);
          final user = User.empty()
          ..username = _usernameController.text
          ..password = _passwordController.text
          ..dateOfBirth = _dobController.text
          ..gender = _gender
          ..weight = double.parse(_weightController.text)
          ..height = double.parse(_heightController.text);
          context.read<SignUpCubit>().signUp(user);
        }),
        const SizedBox(height: 32.0),
      ],
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
      headline: "Personal Details",
      description: "Please answer the following questions",
      formKey: _personalFormKey,
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
            prefixIconConstraints: BoxConstraints(
              maxHeight: 1, maxWidth: 1, minHeight: 0, minWidth: 0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            labelText: "Gender",
            contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 20.0),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<UserGender>(
              value: _gender,
              isDense: true,
              items: UserGender.values.map((value) => DropdownMenuItem(
                value: value, 
                child: Text(value.stringValue),
              )).toList(growable: false),
              onChanged: (value) {
                _gender = value!;
                context.read<SignUpCubit>().refreshPage();
              },
            ),
          ),
        ),
        const SizedBox(height: 20.0),
        TextFormField(
          validator: MyUtils.requiredDateField,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: _dobController,
          readOnly: true,
          onTap: () => showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1920),
            lastDate: DateTime(2101),
          ).then((value) {
            if(value == null) return;
            _dobController.text = MyUtils.getFormattedDate(value);
            context.read<SignUpCubit>().refreshPage();
          }),
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            labelText: "Date of Birth",
            suffixIcon: Icon(Icons.event),
            contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 20.0),
          ),
        ),
        const SizedBox(height: 20.0),
        _buildNextButton(() {
          if (_personalFormKey.currentState!.validate()) {
            context.read<SignUpCubit>().nextForm();
          }
        }),
        const SizedBox(height: 32.0),
      ],
    );
  }

  // Widget get validationForm {
  //   return paddedForm(<Widget>[
  //     Padding(
  //         padding: const EdgeInsets.symmetric(vertical: 10),
  //         child: TextFormField(
  //           obscureText: !_passwordVisible,
  //           validator: (value) {
  //             // if (value == "") {
  //             //   return "Please fill this field";
  //             // } else if (value != user.password) {
  //             //   return "Old password does not match!";
  //             // }
  //             return null;
  //           },
  //           controller: controllerPassword,
  //           keyboardType: TextInputType.visiblePassword,
  //           decoration: const InputDecoration(
  //             border: OutlineInputBorder(
  //               borderRadius: BorderRadius.all(Radius.circular(10)),
  //             ),
  //             labelText: "Password",
  //             contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 20.0),
  //           ),
  //         )),
  //     Padding(
  //         padding: const EdgeInsets.symmetric(vertical: 10),
  //         child: TextFormField(
  //           obscureText: !_passwordVisible,
  //           validator: (value) {
  //             // if (value == "") {
  //             //   return "Please fill this field";
  //             // } else if (value == user.password) {
  //             //   print("Does not match");
  //             //   return "Please enter a new password!";
  //             // }
  //             return null;
  //           },
  //           controller: controllerNewPassword,
  //           keyboardType: TextInputType.visiblePassword,
  //           decoration: const InputDecoration(
  //             border: OutlineInputBorder(
  //               borderRadius: BorderRadius.all(Radius.circular(10)),
  //             ),
  //             labelText: "New Password",
  //             contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 20.0),
  //           ),
  //         )),
  //     Padding(
  //         padding: const EdgeInsets.symmetric(vertical: 10),
  //         child: TextFormField(
  //           obscureText: !_passwordVisible,
  //           validator: (value) {
  //             if (value == "") {
  //               return "Please fill this field";
  //             } else if (value != controllerNewPassword.text) {
  //               print("Does not match");
  //               return "New password does not match with confirmation!";
  //             }
  //             return null;
  //           },
  //           controller: controllerConfirmPassword,
  //           keyboardType: TextInputType.visiblePassword,
  //           decoration: const InputDecoration(
  //             border: OutlineInputBorder(
  //               borderRadius: BorderRadius.all(Radius.circular(10)),
  //             ),
  //             labelText: "Confirm Your Password",
  //             contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 20.0),
  //           ),
  //         )),
  //     Padding(
  //       padding: const EdgeInsets.symmetric(vertical: 10.0),
  //       child: SizedBox(
  //           width: double.infinity,
  //           height: 55,
  //           child: ElevatedButton(
  //               onPressed: () async {
  //                 handleSubmit();
  //               },
  //               style: ButtonStyle(
  //                   backgroundColor: MaterialStateProperty.all<Color>(
  //                       Constants.primaryColor),
  //                   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
  //                       RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(12.0)))),
  //               child: const Text("Change Password"))),
  //     ),
  //   ],
  //       "Editing Password",
  //       "Please enter your current password to confirm your identity",
  //       validationFormKey);
  // }

  Widget _buildCredentialForm(BuildContext context, SignUpState state) {
    return _buildPaddedForm(
      headline: "Registration Form",
      description: "Let's start by enter your login credentials",
      formKey: _credentialFormKey,
      inputs: [
        TextFormField(
          validator: MyUtils.requiredTextField,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: _usernameController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            labelText: "Username",
            errorText: state.errorMsg,
            contentPadding: const EdgeInsets.all(20.0),
          ),
        ),
        const SizedBox(height: 20.0),
        TextFormField(
          obscureText: !state.passwordVisible,
          validator: MyUtils.requiredTextField,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: _passwordController,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            suffixIcon: GestureDetector(
              onTapUp: (_) => context.read<SignUpCubit>().togglePassword(),
              onTapDown: (_) => context.read<SignUpCubit>().togglePassword(),
              onLongPressEnd: (_) => context.read<SignUpCubit>().togglePassword(),
              child: state.passwordVisible
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off),
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            labelText: "Password",
            contentPadding: const EdgeInsets.all(20.0),
          ),
        ),
        const SizedBox(height: 20.0),
        TextFormField(
          obscureText: !state.confirmPasswordVisible,
          validator: (value) {
            if (value == "") {
              return "Please fill this field";
            } else if (value != _passwordController.text) {
              print("Does not match");
              return "New password does not match with confirmation!";
            }
            return null;
          },
          controller: _confirmPasswordController,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            suffixIcon: GestureDetector(
              onTapUp: (_) => context.read<SignUpCubit>().toggleConfirmPassword(),
              onTapDown: (_) => context.read<SignUpCubit>().toggleConfirmPassword(),
              onLongPressEnd: (_) => context.read<SignUpCubit>().toggleConfirmPassword(),
              child: state.confirmPasswordVisible
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off),
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            labelText: "Confirm Your Password",
            contentPadding: const EdgeInsets.all(20.0),
          ),
        ),
        const SizedBox(height: 20.0),
        _buildNextButton(() {
          if(!_credentialFormKey.currentState!.validate()) return;
          MyUtils.closeKeyboard(context);
          context.read<SignUpCubit>().submitCredentialForm(
            _usernameController.text, _passwordController.text
          );
        }),
        const SizedBox(height: 32.0),
      ],
    );
  }

  Widget _buildNextButton(void Function() onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 52.0,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppStyle.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: Text(
          "Next",
          style: AppStyle.heading2(height: 1.0, color: Colors.white),
        ),
      ),
    );
  }

  // void handleSubmit() async {
  //   if (widget.isEdit == 1) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text("Account edited!"),
  //     ));
  //     await GetIt.instance<UserRepo>().updateUserLocal(user);
  //     await FirebaseFirestore.instance
  //         .collection(UserFields.container)
  //         .doc(user.id)
  //         .set(user.toMap())
  //         .then((value) {
  //       FocusManager.instance.primaryFocus?.unfocus();
  //     }).then((value) {
  //       Navigator.of(context, rootNavigator: true).pushReplacement(
  //           MaterialPageRoute(
  //               builder: (BuildContext context) => const MainContainer()));
  //     });
  //   } else if (widget.isEdit == 2) {
  //     if (validationFormKey.currentState!.validate()) {
  //       user.password = controllerNewPassword.text;
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text("Password edited!"),
  //       ));
  //       await GetIt.instance<UserRepo>().updateUserLocal(user);
  //       await FirebaseFirestore.instance
  //           .collection(UserFields.container)
  //           .doc(user.id)
  //           .set(user.toMap())
  //           .then((value) {
  //         FocusManager.instance.primaryFocus?.unfocus();
  //       }).then((value) {
  //         Navigator.of(context, rootNavigator: true).pushReplacement(
  //             MaterialPageRoute(
  //                 builder: (BuildContext context) => const MainContainer()));
  //       });
  //     }
  //   } else {
  //     user.id = const Uuid().v4();
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text("Registration successfully, please login!"),
  //     ));
  //     try {
  //       if (user.avatarName.isNotEmpty) {
  //         final path = StorageService.join(user.username, user.avatarName);
  //         await StorageService.uploadFile(path: path, file: _avatar!);
  //         user.avatarUrl = await StorageService.getFileUrl(path);
  //         final name = MyUtils.getFileName(_avatar!);
  //         final file = await MyUtils.getAppTempFile(name);
  //         if(file.existsSync()) {
  //           _avatar!.deleteSync();
  //         }
  //       }
  //       await FirebaseFirestore.instance
  //           .collection(UserFields.container)
  //           .doc(user.id)
  //           .set(user.toMap())
  //           .then((value) {
  //         FocusManager.instance.primaryFocus?.unfocus();
  //       }).then((value) {
  //         Navigator.of(context).pushAndRemoveUntil(
  //             MaterialPageRoute(
  //                 builder: (BuildContext context) => const Login()),
  //             (route) => false);
  //       });
  //     } catch (e) {
  //       print(e);
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text(
  //           "Registration failed, please re-try!",
  //           style: AppStyle.bodyText(color: AppStyle.dangerColor),
  //         ),
  //       ));
  //     }
  //   }
  // }

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
