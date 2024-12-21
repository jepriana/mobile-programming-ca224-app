import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/models/moment.dart';
import 'package:myapp/views/authentication/bloc/authentication_bloc.dart';
import 'package:myapp/views/user/bloc/user_data_bloc.dart';
import 'package:myapp/views/user/pages/user_follower_page.dart';
import 'package:myapp/views/user/pages/user_following_page.dart';
import 'package:myapp/views/user/widgets/user_data_item.dart';

import '../../../core/resources/dimensions.dart';
import '../../moment/widgets/post_item_square.dart';
import 'user_setting_page.dart';

class UserPage extends StatefulWidget {
  static const routeName = '/user';
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  void initState() {
    context.read<UserDataBloc>().add(UserDataGetEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final activeUser = context.watch<AuthenticationBloc>().activeUser;
    return BlocConsumer<UserDataBloc, UserDataState>(
      listener: (context, state) {
        if (state is UserDataFailedActionState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      builder: (context, state) {
        List<Moment> moments = [];
        final isLoading = state is UserDataLoadingState;
        if (state is UserDataGetSuccessState) {
          moments = state.moments;
        }
        return isLoading ? const Center(child: CircularProgressIndicator()) : Padding(
          padding: const EdgeInsets.symmetric(horizontal: largeSize),
          child: Column(
            children: [
              Card(
                margin: const EdgeInsets.all(smallSize),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(xLargeSize),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          activeUser?.imageUrl ?? 'https://i.pravatar.cc/150',
                        ),
                      ),
                      title: Text(activeUser?.username ?? 'Username'),
                      subtitle: Text(activeUser != null
                          ? '${activeUser.firstName} ${activeUser.lastName}'
                              .trim()
                          : 'User Full Name'),
                      trailing: IconButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, UserSettingPage.routeName);
                        },
                        icon: const Icon(
                          Icons.settings_rounded,
                        ),
                      ),
                    ),
                    const Divider(
                      indent: largeSize,
                      endIndent: largeSize,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        largeSize,
                        0,
                        largeSize,
                        largeSize,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          UserDataItem(
                            label: 'Moments',
                            value: moments.length.toString(),
                          ),
                          const UserDataItem(
                            label: 'Bookmarks',
                            value: '0',
                          ),
                          UserDataItem(
                            label: 'Followers',
                            value: '${activeUser?.followerCount ?? 0}',
                            onTap: () {
                              Navigator.pushNamed(
                                  context, UserFollowerPage.routeName);
                            },
                          ),
                          UserDataItem(
                            label: 'Following',
                            value: '${activeUser?.followingCount ?? 0}',
                            onTap: () {
                              Navigator.pushNamed(
                                  context, UserFollowingPage.routeName);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: mediumSize),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (context, index) => PostItemSquare(
                    momentId: moments[index].id!,
                    imageUrl: moments[index].imageUrl,
                  ),
                  itemCount: moments.length,
                ),
              ),
              const SizedBox(height: largeSize),
            ],
          ),
        );
      },
    );
  }
}
