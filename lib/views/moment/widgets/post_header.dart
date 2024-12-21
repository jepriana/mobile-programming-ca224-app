import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/moment.dart';
import '../bloc/moment_bloc.dart';

class PostHeader extends StatelessWidget {
  const PostHeader({
    super.key,
    required this.momentItem,
  });
  final Moment momentItem;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
            momentItem.creatorImageUrl ?? 'https://i.pravatar.cc/150'),
      ),
      title: Text(
        momentItem.creatorUsername.toString(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white70,
        ),
      ),
      subtitle: Text(
        momentItem.location,
        style: const TextStyle(
          color: Colors.white60,
        ),
      ),
      trailing: PopupMenuButton(
        itemBuilder: (context) {
          return [
            const PopupMenuItem(
              value: 'Update',
              child: Text('Update'),
            ),
            const PopupMenuItem(
              value: 'Delete',
              child: Text('Delete'),
            ),
          ];
        },
        onSelected: (value) {
          if (value == 'Update') {
            context
                .read<MomentBloc>()
                .add(MomentNavigateToUpdateEvent(momentItem.id!));
          } else if (value == 'Delete') {
            context
                .read<MomentBloc>()
                .add(MomentNavigateToDeleteEvent(momentItem.id!));
          }
        },
        child: const Icon(
          Icons.more_vert_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}
