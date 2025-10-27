import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc_data/mission_bloc.dart';
import '../../bloc_detail/mission_detail_bloc.dart';
import '../../bloc_completion/mission_completion_bloc.dart';
import '../../bloc_start/mission_start_bloc.dart';
import '../../../profile/bloc/profile_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../../data/model/mission_model.dart';

class MissionDetailPage extends StatelessWidget {
  final int missionId;

  const MissionDetailPage({
    super.key,
    required this.missionId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<MissionDetailBloc>()
            ..add(
              MissionDetailEvent.fetched(
                missionId: missionId,
              ),
            ),
        ),
        BlocProvider(
          create: (context) => sl<MissionCompletionBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<MissionStartBloc>(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('Detail Misi')),
        body: MultiBlocListener(
          listeners: [
            BlocListener<
              MissionCompletionBloc,
              MissionCompletionState
            >(
              listener: (context, completionState) {
                completionState.whenOrNull(
                  success: (message, totalPoints) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      SnackBar(
                        content: Text(message),
                        backgroundColor: Colors.green,
                      ),
                    );
                    context.read<ProfileBloc>().add(
                      const ProfileEvent.profileFetched(),
                    );
                    context.read<MissionBloc>().add(
                      const MissionEvent.missionsFetched(),
                    );
                  },
                  error: (message) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      SnackBar(
                        content: Text(message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  },
                );
              },
            ),
            BlocListener<
              MissionStartBloc,
              MissionStartState
            >(
              listener: (context, startState) {
                startState.whenOrNull(
                  success: (message) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      SnackBar(
                        content: Text(message),
                        backgroundColor: Colors.blue,
                      ),
                    );
                    // --- TODO: NAVIGASI KE LAYAR AR ---
                    // Navigator.of(context).pushNamed('/ar_camera', arguments: missionId);
                    print(
                      "NAVIGASI KE LAYAR AR UNTUK MISI ID: $missionId",
                    );
                  },
                  error: (message) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      SnackBar(
                        content: Text(message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  },
                );
              },
            ),
          ],
          // Builder utama tetap pakai MissionDetailBloc
          child: BlocBuilder<MissionDetailBloc, MissionDetailState>(
            builder: (context, detailState) {
              return detailState.when(
                initial: () => const Center(
                  child: Text('Memuat detail...'),
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (message) =>
                    Center(child: Text(message)),
                loaded: (mission) {
                  // Kita sekarang perlu state dari MissionStartBloc untuk tombol
                  return BlocBuilder<
                    MissionStartBloc,
                    MissionStartState
                  >(
                    builder: (context, startState) {
                      // Cek apakah sedang dalam proses memulai
                      final isStarting =
                          startState ==
                          MissionStartState.loading();

                      return _buildMissionDetails(
                        context,
                        mission,
                        isStarting,
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMissionDetails(
    BuildContext context,
    Mission mission,
    bool isStarting,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            mission.title,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Chip(
                label: Text('${mission.pointsReward} POIN'),
                backgroundColor: Colors.blue.shade100,
              ),
              const SizedBox(width: 10),
              if (mission.badge != null)
                Chip(
                  avatar: CircleAvatar(
                    backgroundImage: NetworkImage(
                      mission.badge!.iconUrl,
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                  label: Text(mission.badge!.name),
                  backgroundColor: Colors.amber.shade100,
                ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            mission.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const Spacer(),

          ElevatedButton.icon(
            icon: isStarting
                ? Container(
                    width: 24,
                    height: 24,
                    padding: const EdgeInsets.all(2.0),
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                : const Icon(Icons.camera_alt_outlined),
            label: Text(
              isStarting ? 'MEMULAI...' : 'MULAI MISI AR',
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: isStarting
                ? null
                : () {
                    context.read<MissionStartBloc>().add(
                      MissionStartEvent.started(
                        missionId: mission.id,
                      ),
                    );
                  },
          ),
        ],
      ),
    );
  }
}
