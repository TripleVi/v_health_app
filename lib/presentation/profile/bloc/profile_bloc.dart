import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/utilities/image.dart';
import '../../../data/sources/sqlite/dao/user_dao.dart';
import '../../../domain/entities/user.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const ProfileLoading()) {
    on<UserFetched>((event, emit) async {
      // final user = await GetIt.instance<UserDao>().getUser();
      // io.File? avatarFile;
      // if(user.avatarName.isNotEmpty) {
      //   avatarFile = await ImageUtils.getUserFile(user.avatarName);
      // }
      // emit(ProfileLoaded(user, avatarFile));
    });

    add(const UserFetched());
  }
}
