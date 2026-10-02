import React from 'react';
import { FireStatistics } from '../types/statistics';
import { Activity, Calendar, Flame, TrendingUp } from 'lucide-react';

interface StatisticsCardsProps {
  stats: FireStatistics;
  isLoading?: boolean;
}

export const StatisticsCards: React.FC<StatisticsCardsProps> = ({ stats, isLoading }) => {
  const statItems = [
    {
      id: 'today',
      title: 'BUGÜN',
      value: stats.today,
      subtext: 'Son 24 saatteki bildirimler',
      icon: Flame,
      iconColor: 'text-fireRedLight',
      bgGlow: 'from-fireRed/10 to-transparent',
      borderColor: 'border-fireRed/30',
    },
    {
      id: 'week',
      title: 'BU HAFTA',
      value: stats.thisWeek,
      subtext: 'Pazartesiden itibaren',
      icon: Activity,
      iconColor: 'text-orangeAccent',
      bgGlow: 'from-orangeAccent/10 to-transparent',
      borderColor: 'border-orangeAccent/20',
    },
    {
      id: 'month',
      title: 'BU AY',
      value: stats.thisMonth,
      subtext: 'Cari ay içindeki toplam',
      icon: Calendar,
      iconColor: 'text-yellowWarning',
      bgGlow: 'from-yellowWarning/10 to-transparent',
      borderColor: 'border-cardBorder',
    },
    {
      id: 'total',
      title: 'TOPLAM YANGIN',
      value: stats.total,
      subtext: 'Kayıtlı tüm ihbarlar',
      icon: TrendingUp,
      iconColor: 'text-textPrimary',
      bgGlow: 'from-surfaceLight to-transparent',
      borderColor: 'border-cardBorder',
    },
  ];

  return (
    <div className="grid grid-cols-2 lg:grid-cols-1 gap-3.5">
      {statItems.map((item) => {
        const Icon = item.icon;
        return (
          <div
            key={item.id}
            className={`relative overflow-hidden p-4 sm:p-5 rounded-2xl bg-card border ${item.borderColor} bg-gradient-to-br ${item.bgGlow} shadow-sm hover:border-textMuted/40 transition-all`}
          >
            <div className="flex items-center justify-between mb-2">
              <span className="text-xs font-bold tracking-wider text-textSecondary uppercase">
                {item.title}
              </span>
              <div className="p-2 rounded-xl bg-surfaceLight/80">
                <Icon className={`w-4 h-4 ${item.iconColor}`} />
              </div>
            </div>

            <div className="flex items-baseline gap-2">
              {isLoading ? (
                <div className="h-8 w-16 bg-surfaceLight animate-pulse rounded-lg my-1" />
              ) : (
                <span className="text-2xl sm:text-3xl font-extrabold text-white tracking-tight tabular-nums">
                  {item.value.toLocaleString('tr-TR')}
                </span>
              )}
            </div>

            <p className="text-[11px] text-textMuted mt-1">{item.subtext}</p>
          </div>
        );
      })}
    </div>
  );
};
