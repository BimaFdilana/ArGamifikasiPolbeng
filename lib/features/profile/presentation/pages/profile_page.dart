import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/data/model/user_model.dart';
import '../../bloc/profile_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ProfileBloc>().add(
      const ProfileEvent.profileFetched(),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Profil Saya')),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(child: Text('...')),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (message) =>
                Center(child: Text(message)),
            loaded: (user) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ProfileBloc>().add(
                    const ProfileEvent.profileFetched(),
                  );
                },
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    _buildProfileHeader(user),
                    const SizedBox(height: 24),
                    _buildStatsGrid(user),
                    const SizedBox(height: 24),
                    _buildBadgeGallery(user),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(User user) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          child: Text(
            user.name.isNotEmpty
                ? user.name[0].toUpperCase()
                : 'U',
            style: const TextStyle(fontSize: 40),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          user.name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          user.email,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(User user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatCard(
          'Total Poin',
          user.totalPoints.toString(),
        ),
        _buildStatCard('Level', user.level.toString()),
      ],
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeGallery(User user) {
    final badges = user.badgesEarned;

    if (badges == null || badges.isEmpty) {
      return const Center(
        child: Text('Belum ada lencana yang didapat.'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lencana Saya',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
          itemCount: badges.length,
          itemBuilder: (context, index) {
            final badge = badges[index];
            return Tooltip(
              message: badge.name,
              child: CircleAvatar(
                radius: 30,
                child: Image.network(badge.iconUrl),
              ),
            );
          },
        ),
      ],
    );
  }
}
