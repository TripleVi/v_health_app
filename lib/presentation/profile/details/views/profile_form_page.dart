import "package:flutter/material.dart";
import "package:v_health/data/sources/api/user_api.dart";

import "../../../../core/resources/style.dart";
import "../../../../core/services/shared_pref_service.dart";
import "../../../../core/utilities/utils.dart";
import "../../../widgets/app_bar.dart";

class ProfileFormPage extends StatefulWidget {
  const ProfileFormPage({super.key});

  @override
  State<ProfileFormPage> createState() => _ProfileFormPageState();
}

class _ProfileFormPageState extends State<ProfileFormPage> {
  final textController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var type = -1;
  String? errorMsg;
  var labelText = "";
  String? Function(String?)? validator;

  @override
  void initState() {
    super.initState();
    fetchData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      type = ModalRoute.of(context)!.settings.arguments as int;
      fetchData();
    });
  }

  Future<void> fetchData() async {
    final user = await SharedPrefService.getCurrentUser();
    if(type == 0) {
      textController.text = user.name;
      labelText = "Name";
      validator = MyUtils.nameValidator;
    }else if(type == 1) {
      textController.text = user.username;
      labelText = "Username";
      validator = MyUtils.usernameValidator;
    }
    setState(() {});
  }

  Future<void> submit() async {
    if(!formKey.currentState!.validate()) return;
    final service = UserService();
    final user = await SharedPrefService.getCurrentUser();
    if(type == 0) {
      user.name = textController.text;
    }else if(type == 1) {
      user.username = textController.text;
    }
    final result = await service.editProfile(user);
    if(result) {
      await SharedPrefService.updateCurrentUser(user);
      if(!mounted) return;
      showSnackMsg("Edited profile successfully!");
      return Navigator.pop<bool>(context, true);
    }
    showSnackMsg("Oops, something went wrong!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.get(
        title: labelText,
        actions: appBarActions(),
      ),
      backgroundColor: AppStyle.surfaceColor,
      body: Container(
        height: double.infinity,
        constraints: const BoxConstraints(maxWidth: 520.0),
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: formKey,
          child: TextFormField(
            autofocus: true,
            validator: validator,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: textController,
            keyboardType: TextInputType.text,
            style: AppStyle.bodyText(),
            maxLength: 30,
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
              labelText: labelText,
              errorText: errorMsg,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> appBarActions() {
    return [
      TextButton(
        onPressed: submit,
        child: const Text("Done"),
      ),
    ];
  }

  void showSnackMsg(String content) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: AppStyle.backgroundColor,
      showCloseIcon: true,
      closeIconColor: AppStyle.secondaryIconColor,
      content: Text(
        content,
        style: AppStyle.bodyText(),
      ),
    ));
  }
}