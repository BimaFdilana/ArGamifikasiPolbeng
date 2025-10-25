import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../../bloc_detail/mission_detail_bloc.dart';
import '../../data/model/mission_model.dart';

class MissionDetailPage extends StatelessWidget {
  final int missionId;

  const MissionDetailPage({
    super.key,
    required this.missionId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MissionDetailBloc>()
        ..add(
          MissionDetailEvent.fetched(missionId: missionId),
        ),
      child: Scaffold(
        appBar: AppBar(),
        body:
            BlocBuilder<
              MissionDetailBloc,
              MissionDetailState
            >(
              builder: (context, state) {
                return state.when(
                  initial: () =>
                      const Center(child: Text('...')),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (message) =>
                      Center(child: Text(message)),
                  loaded: (mission) {
                    // Tampilkan detail misi jika berhasil dimuat
                    return _buildMissionDetails(
                      context,
                      mission,
                    );
                  },
                );
              },
            ),
      ),
    );
  }

  // Widget untuk menampilkan konten detail
  Widget _buildMissionDetails(
    BuildContext context,
    Mission mission,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Judul Misi
          Text(
            mission.title,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Poin & Hadiah Lencana
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
                    child: Image.network(
                      mission.badge!.iconUrl,
                    ),
                  ),
                  label: Text(mission.badge!.name),
                  backgroundColor: Colors.amber.shade100,
                ),
            ],
          ),
          const SizedBox(height: 24),

          // Deskripsi
          Text(
            mission.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const Spacer(), // Dorong tombol ke bawah
          // Tombol Aksi
          ElevatedButton.icon(
            icon: const Icon(Icons.camera_alt_outlined),
            label: const Text('MULAI MISI AR'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              // TODO: Ganti ini dengan logika penyelesaian misi
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logika AR belum dibuat'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
