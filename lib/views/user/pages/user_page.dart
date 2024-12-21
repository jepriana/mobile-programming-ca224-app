import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/models/moment.dart';
import 'package:myapp/views/authentication/bloc/authentication_bloc.dart';
import 'package:myapp/views/user/pages/user_follower_page.dart';
import 'package:myapp/views/user/pages/user_following_page.dart';
import 'package:myapp/views/user/widgets/user_data_item.dart';
import 'package:nanoid2/nanoid2.dart';
import 'package:faker/faker.dart' as faker;

import '../../../core/resources/dimensions.dart';
import '../../moment/widgets/post_item_square.dart';
import 'user_setting_page.dart';

class UserPage extends StatelessWidget {
  static const routeName = '/user';
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final activeUser = context.watch<AuthenticationBloc>().activeUser;
    final oFaker = faker.Faker();
    List<Moment> moments = List.generate(
      6,
      (index) => Moment(
        id: nanoid(),
        momentDate: oFaker.date.dateTime(),
        creatorUsername: oFaker.person.name(),
        location: oFaker.address.city(),
        imageUrl: 'https://picsum.photos/800/600?random=$index',
        caption: oFaker.lorem.sentence(),
        totalLikes: faker.random.integer(1000),
        totalComments: faker.random.integer(100),
        totalBookmarks: faker.random.integer(10),
      ),
    );
    return Padding(
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
                      ? '${activeUser.firstName} ${activeUser.lastName}'.trim()
                      : 'User Full Name'),
                  trailing: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, UserSettingPage.routeName);
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
                        label: 'Posts',
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
  }
}
