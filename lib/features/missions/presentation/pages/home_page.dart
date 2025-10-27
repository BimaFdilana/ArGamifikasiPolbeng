import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/bloc/auth_bloc.dart';
import '../../bloc_data/mission_bloc.dart';
import 'mission_detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<MissionBloc>().add(
      const MissionEvent.missionsFetched(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Misi'),
        actions: [
          // Tombol Logout
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              context.read<AuthBloc>().add(
                AuthEvent.logoutRequest(),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<MissionBloc, MissionState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(
              child: Text('Selamat Datang!'),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            loaded: (missions) {
              if (missions.isEmpty) {
                return const Center(
                  child: Text('Belum ada misi tersedia.'),
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<MissionBloc>().add(
                    const MissionEvent.missionsFetched(),
                  );
                },
                child: ListView.builder(
                  itemCount: missions.length,
                  itemBuilder: (context, index) {
                    final mission = missions[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: mission.badge != null
                              ? Image.network(
                                  mission.badge!.iconUrl,
                                )
                              : const Icon(
                                  Icons.star_outline,
                                ),
                        ),
                        title: Text(mission.title),
                        subtitle: Text(
                          '${mission.pointsReward} Poin',
                        ),
                        trailing: const Icon(
                          Icons.chevron_right,
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  MissionDetailPage(
                                    missionId: mission.id,
                                  ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            },
            error: (message) => Center(
              child: Text(
                message,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        },
      ),
    );
  }
}
