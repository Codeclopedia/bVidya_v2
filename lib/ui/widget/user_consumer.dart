import '/controller/providers/user_auth_provider.dart';
// import '/core/constants/route_list.dart';
import '/core/state.dart';
import '/core/ui_core.dart';
import '/data/models/response/auth/login_response.dart';

class UserConsumer extends ConsumerWidget {
  final Widget Function(BuildContext context, User user, WidgetRef ref) builder;
  const UserConsumer({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.listen(userAuthChangeProvider, ((previous, next) {
    //   // print('listen called ${next.isUserSigned}');
    //   if (next.user == null && next.isUserSigned) {
    //     ref.read(userAuthChangeProvider).setUserSigned(false);
    //     // print('User is null');
    //     Navigator.pushNamedAndRemoveUntil(
    //         context, RouteList.login, (route) => route.isFirst);
    //   }
    // }));
    // final user = ref.watch(userAuthChangeProvider).user;
    final user = ref.watch(userLoginStateProvider);
    if (user == null) {
      return const SizedBox.shrink();
    }
    return builder(context, user, ref);
  }
}
