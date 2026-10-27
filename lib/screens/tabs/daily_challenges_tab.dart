import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/loyalty_provider.dart';
import '../../theme/app_theme.dart';

class DailyChallengesTab extends StatelessWidget {
  const DailyChallengesTab({super.key});

  IconData _resolveIcon(String iconName) {
    switch (iconName) {
      case 'sports_soccer':
        return Icons.sports_soccer_rounded;
      case 'military_tech':
        return Icons.military_tech_rounded;
      case 'spellcheck':
        return Icons.spellcheck_rounded;
      case 'verified':
        return Icons.verified_rounded;
      default:
        return Icons.star_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoyaltyProvider>();
    final bundle = provider.bundle;

    if (provider.isLoading || bundle == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.accentGold),
      );
    }

    final challenges = bundle.dailyChallenges;

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
                'Ежедневные События и Миссии',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Проходи ежедневные квизы тура, поддерживай серию и забирай бонусы',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 14),

              // Streak Card in Baltbet Slate Style
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: AppTheme.accentRose.withAlpha(25),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppTheme.accentRose.withAlpha(80)),
                          ),
                          child: const Icon(
                            Icons.local_fire_department_rounded,
                            color: AppTheme.accentRose,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${provider.streakDays} дн. непрерывной серии',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Серия активных дней увеличивает множитель наград',
                                style: GoogleFonts.inter(
                                  fontSize: 11.5,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 7-day streak indicators
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(7, (i) {
                          final dayNum = i + 1;
                          final isPassed = dayNum <= provider.streakDays;
                          final isToday = dayNum == provider.streakDays;

                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: isPassed ? AppTheme.accentGold.withAlpha(30) : AppTheme.surface,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isToday
                                    ? AppTheme.accentGold
                                    : (isPassed ? AppTheme.accentGold.withAlpha(120) : AppTheme.surfaceBorder),
                                width: isToday ? 1.8 : 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'День $dayNum',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: isPassed ? AppTheme.accentGold : AppTheme.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Icon(
                                  isPassed ? Icons.check_circle_rounded : Icons.lock_outline_rounded,
                                  size: 16,
                                  color: isPassed ? AppTheme.accentGold : AppTheme.textMuted,
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Daily Bonus Claim Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: provider.dailyBonusClaimed
                            ? null
                            : () {
                                provider.claimDailyBonus();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: AppTheme.surfaceHighlight,
                                    content: Text(
                                      '🎉 Ежедневный бонус получен: +100 баллов, +50 XP!',
                                      style: GoogleFonts.inter(
                                        color: AppTheme.accentGold,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              provider.dailyBonusClaimed ? AppTheme.surfaceBorder : AppTheme.accentGold,
                          foregroundColor:
                              provider.dailyBonusClaimed ? AppTheme.textMuted : AppTheme.background,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          provider.dailyBonusClaimed
                              ? 'Бонус на сегодня уже забран'
                              : 'Забрать Бонус Дня (+100 баллов)',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w800,
                            fontSize: 13.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Challenges List Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Линейка Заданий Тура',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceCard,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppTheme.surfaceBorder),
                    ),
                    child: Text(
                      'Обновление: 24ч',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: challenges.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final challenge = challenges[index];
                  final isCompleted = provider.isChallengeCompleted(challenge.id);
                  final isClaimed = provider.isChallengeClaimed(challenge.id);
                  final progress = provider.getChallengeProgress(challenge.id);
                  final progressRatio = (progress / challenge.target).clamp(0.0, 1.0);

                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isCompleted ? AppTheme.secondary.withAlpha(90) : AppTheme.surfaceBorder,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: (isCompleted ? AppTheme.secondary : AppTheme.primaryLight)
                                    .withAlpha(25),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                _resolveIcon(challenge.icon),
                                color: isCompleted ? AppTheme.secondary : AppTheme.primaryLight,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    challenge.title,
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    challenge.description,
                                    style: GoogleFonts.inter(
                                      fontSize: 11.5,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Progress Bar & Indicators
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Прогресс: $progress / ${challenge.target}',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '+${challenge.xpReward} XP',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.primaryLight,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.monetization_on_rounded,
                                        color: AppTheme.accentGold, size: 12),
                                    const SizedBox(width: 2),
                                    Text(
                                      '+${challenge.coinsReward}',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        color: AppTheme.accentGold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progressRatio,
                            backgroundColor: AppTheme.surface,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isCompleted ? AppTheme.secondary : AppTheme.accentGold,
                            ),
                            minHeight: 5,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Action Button
                        SizedBox(
                          width: double.infinity,
                          child: isClaimed
                              ? Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: AppTheme.surface,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.check_circle_rounded,
                                        size: 15,
                                        color: AppTheme.secondary,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Награда получена',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.secondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: isCompleted
                                      ? () {
                                          provider.claimDailyChallenge(challenge);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              backgroundColor: AppTheme.surfaceHighlight,
                                              content: Text(
                                                '🏆 Награда получена: +${challenge.coinsReward} баллов, +${challenge.xpReward} XP!',
                                                style: GoogleFonts.inter(
                                                  color: AppTheme.accentGold,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        isCompleted ? AppTheme.secondary : AppTheme.surfaceBorder,
                                    foregroundColor:
                                        isCompleted ? Colors.black : AppTheme.textMuted,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    isCompleted ? 'Забрать награду' : 'В процессе выполнения',
                                    style: GoogleFonts.inter(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
