import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/loyalty_provider.dart';
import '../../theme/app_theme.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoyaltyProvider>();
    final bundle = provider.bundle;

    if (provider.isLoading || bundle == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.accentGold),
      );
    }

    final currentRank = provider.currentRank;
    final nextRank = provider.nextRank;
    final progress = provider.rankProgress;
    final leaderboard = bundle.leaderboard;
    final achievements = bundle.achievements;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Профиль и Статистика Эксперта',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Карта участника матч-центра, рейтинг и спортивные достижения',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 14),

              // Baltbet Member Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.surfaceBorder, width: 1.2),
                  boxShadow: AppTheme.baltbetCardShadow,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.primary.withAlpha(35),
                            border: Border.all(
                              color: AppTheme.primaryLight,
                              width: 2,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            currentRank.badge,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentRank.title,
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Уровень ${currentRank.level} • ${provider.xp} XP',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppTheme.accentGold,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.surface,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppTheme.surfaceBorder),
                          ),
                          child: Text(
                            'ID 849-204',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Progress to next rank
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          nextRank != null
                              ? 'До статуса «${nextRank.title}»'
                              : 'Максимальный ранг достигнут!',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        if (nextRank != null)
                          Text(
                            '${(progress * 100).toInt()}%',
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.accentGold,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: AppTheme.surface,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppTheme.accentGold,
                        ),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Stats 4-card Grid
              Text(
                'Сводка Результатов',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      title: 'Матч-квизов',
                      value: '${provider.completedQuizzes}',
                      icon: Icons.sports_soccer_rounded,
                      color: AppTheme.primaryLight,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildStatCard(
                      title: 'Точность прогнозов',
                      value: '${provider.accuracyRate.toStringAsFixed(0)}%',
                      icon: Icons.track_changes_rounded,
                      color: AppTheme.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      title: 'Верных ответов',
                      value: '${provider.correctAnswers}',
                      icon: Icons.check_circle_outline_rounded,
                      color: AppTheme.accentGold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildStatCard(
                      title: 'Серия входов',
                      value: '${provider.streakDays} дн.',
                      icon: Icons.local_fire_department_rounded,
                      color: AppTheme.accentRose,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Leaderboard Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Турнирная Таблица Знатоков РПЛ',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceCard,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppTheme.surfaceBorder),
                    ),
                    child: Text(
                      'Сезон 2026/27',
                      style: GoogleFonts.inter(
                        fontSize: 10.5,
                        color: AppTheme.accentGold,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Container(
                decoration: BoxDecoration(
                  color: AppTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.surfaceBorder),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: leaderboard.length,
                  separatorBuilder: (context, index) => const Divider(
                    height: 1,
                    color: AppTheme.surfaceBorder,
                  ),
                  itemBuilder: (context, index) {
                    final item = leaderboard[index];
                    final isTop3 = item.rank <= 3;
                    final rankColor = item.rank == 1
                        ? AppTheme.accentGold
                        : (item.rank == 2
                            ? const Color(0xFFC0C0C0)
                            : (item.rank == 3
                                ? const Color(0xFFCD7F32)
                                : AppTheme.textMuted));

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Row(
                        children: [
                          Container(
                            width: 26,
                            height: 26,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isTop3 ? rankColor.withAlpha(25) : AppTheme.surface,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${item.rank}',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: rankColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            item.avatar,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '${item.matches} матчей',
                                  style: GoogleFonts.inter(
                                    fontSize: 10.5,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${item.score} очков',
                            style: GoogleFonts.inter(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.accentGold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Achievements Section
              Text(
                'Зал Достижений и Наград',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: achievements.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final ach = achievements[index];
                  bool isUnlocked = false;
                  if (ach.id == 'ach_first_win' && provider.completedQuizzes >= 1) {
                    isUnlocked = true;
                  } else if (ach.id == 'ach_streak_3' && provider.streakDays >= 3) {
                    isUnlocked = true;
                  } else if (ach.id == 'ach_points_1000' && provider.xp >= 1000) {
                    isUnlocked = true;
                  } else if (ach.id == 'ach_words_5' &&
                      provider.getChallengeProgress('dc_3') >= 2) {
                    isUnlocked = true;
                  } else if (ach.id == 'ach_shop_buyer' &&
                      provider.unlockedRewards.isNotEmpty) {
                    isUnlocked = true;
                  }

                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceCard,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isUnlocked ? AppTheme.accentGold.withAlpha(80) : AppTheme.surfaceBorder,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: (isUnlocked ? AppTheme.accentGold : AppTheme.surfaceBorder)
                                .withAlpha(25),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            isUnlocked ? Icons.emoji_events_rounded : Icons.lock_outline_rounded,
                            color: isUnlocked ? AppTheme.accentGold : AppTheme.textMuted,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ach.title,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                ach.description,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isUnlocked)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppTheme.accentGold.withAlpha(20),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Открыто',
                              style: GoogleFonts.inter(
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.accentGold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppTheme.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
