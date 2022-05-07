import 'package:bloc/bloc.dart';
import 'package:frontend/api/cache/cache_resource_service.dart';
import 'package:frontend/api/cache/cache_user_service.dart';
import 'package:frontend/api/grpc/grpc_resource_service.dart';
import 'package:frontend/api/grpc/grpc_user_service.dart';
import 'package:frontend/api/model/profile.dart';
import 'package:frontend/api/model/resource.dart';
import 'package:frontend/api/resource_service.dart';
import 'package:frontend/api/user_service.dart';
import 'package:meta/meta.dart';

part 'user_menu_event.dart';
part 'user_menu_state.dart';

class UserMenuBloc extends Bloc<UserMenuEvent, UserMenuState> {
  final UserService _userService = CacheUserService(GRPCUserService());
  final ResourceService _resourceService = CacheResourceService(GRPCResourceService("10.0.2.2", port: 8080));
  UserMenuBloc() : super(UserMenuInitial()) {
    on<LoadUserMenu>(_loadUserMenu);
  }
  void _loadUserMenu(LoadUserMenu event, Emitter<UserMenuState> emit) async {
    emit(UserMenuLoading());
    await Future.delayed(const Duration(seconds: 2)); //removeable

    var _profile = await _userService.getProfile(event.userId);

    emit(UserMenuWithoutPictureLoaded(_profile));
    await Future.delayed(const Duration(seconds: 2)); //removeable

    var _profileImage = await _resourceService.getResource(_profile.profileImageResourceId);

    emit(UserMenuLoaded(_profileImage));
  }
}
