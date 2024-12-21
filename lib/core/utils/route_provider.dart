import 'package:flutter/material.dart';

import '../../views/authentication/pages/login_page.dart';
import '../../views/authentication/pages/register_page.dart';
import '../../views/authentication/widgets/authentication_navigator.dart';
import '../../views/comment/pages/comment_page.dart';
import '../../views/comment/pages/commment_entry_page.dart';
import '../../views/common/pages/main_page.dart';
import '../../views/moment/pages/moment_entry_page.dart';
import '../../views/moment/pages/moment_page.dart';
import '../../views/user/pages/user_follower_page.dart';
import '../../views/user/pages/user_following_page.dart';
import '../../views/user/pages/user_setting_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AuthenticationNavigator.routeName:
        return MaterialPageRoute(
            builder: (_) => const AuthenticationNavigator());
      case MainPage.routeName:
        return MaterialPageRoute(builder: (_) => const MainPage());
      case UserSettingPage.routeName:
        return MaterialPageRoute(builder: (_) => const UserSettingPage());
      case UserFollowerPage.routeName:
        return MaterialPageRoute(builder: (_) => const UserFollowerPage());
      case UserFollowingPage.routeName:
        return MaterialPageRoute(builder: (_) => const UserFollowingPage());
      case LoginPage.routeName:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case RegisterPage.routeName:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case MomentPage.routeName:
        return MaterialPageRoute(builder: (_) => const MomentPage());
      case MomentEntryPage.routeName:
        final momentId = settings.arguments as String?;
        return MaterialPageRoute(
            builder: (_) => MomentEntryPage(momentId: momentId));
      case CommentPage.routeName:
        final momentId = settings.arguments as String?;
        return MaterialPageRoute(
            builder: (_) => CommentPage(momentId: momentId!));
      case CommentEntryPage.routeName:
        final commentId = settings.arguments as String?;
        return MaterialPageRoute(
            builder: (_) => CommentEntryPage(commentId: commentId));
      default:
        return MaterialPageRoute(builder: (_) => const MainPage());
    }
  }
}
