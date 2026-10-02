import React from 'react';
import { FireReport } from '../types/fireReport';
import { Clock, Flame, MapPin, User } from 'lucide-react';

interface FireReportListProps {
  reports: FireReport[];
  selectedReport?: FireReport | null;
  onSelectReport: (report: FireReport) => void;
  isLoading?: boolean;
}

const getFireTypeBadge = (fireType: string) => {
  switch (fireType?.toLowerCase()) {
    case 'forest':
      return { label: '🌲 Orman', color: 'bg-emerald-500/10 text-emerald-400 border-emerald-500/20' };
    case 'building':
      return { label: '🏠 Bina', color: 'bg-orange-500/10 text-orange-400 border-orange-500/20' };
    case 'vehicle':
      return { label: '🚗 Araç', color: 'bg-amber-500/10 text-amber-400 border-amber-500/20' };
    case 'electric':
      return { label: '⚡ Elektrik', color: 'bg-purple-500/10 text-purple-400 border-purple-500/20' };
    default:
      return { label: '🔥 Diğer', color: 'bg-gray-500/10 text-gray-400 border-gray-500/20' };
  }
};

const formatTimeAgo = (isoString: string) => {
  const date = new Date(isoString);
  const now = new Date();
  const diffMinutes = Math.floor((now.getTime() - date.getTime()) / 60000);

  if (diffMinutes < 1) return 'Az önce';
  if (diffMinutes < 60) return `${diffMinutes} dk önce`;
  const diffHours = Math.floor(diffMinutes / 60);
  if (diffHours < 24) return `${diffHours} sa önce`;
  return `${Math.floor(diffHours / 24)} gün önce`;
};

export const FireReportList: React.FC<FireReportListProps> = ({
  reports,
  selectedReport,
  onSelectReport,
  isLoading,
}) => {
  if (isLoading) {
    return (
      <div className="space-y-3">
        {[1, 2, 3].map((i) => (
          <div key={i} className="p-4 rounded-2xl bg-card border border-cardBorder animate-pulse">
            <div className="h-4 bg-surfaceLight rounded w-1/3 mb-2" />
            <div className="h-3 bg-surfaceLight rounded w-2/3" />
          </div>
        ))}
      </div>
    );
  }

  if (reports.length === 0) {
    return (
      <div className="p-8 rounded-2xl bg-card border border-cardBorder text-center">
        <div className="w-12 h-12 rounded-full bg-surfaceLight mx-auto flex items-center justify-center mb-3">
          <Flame className="w-6 h-6 text-textMuted" />
        </div>
        <h4 className="text-sm font-bold text-white mb-1">Aktif Yangın Bildirimi Yok</h4>
        <p className="text-xs text-textSecondary">
          Şu anda sistemde açık veya işlemde olan yangın ihbarı bulunmuyor.
        </p>
      </div>
    );
  }

  return (
    <div className="space-y-2.5 max-h-[620px] overflow-y-auto pr-1">
      {reports.map((report) => {
        const badge = getFireTypeBadge(report.fireType);
        const isSelected = selectedReport?.id === report.id;

        return (
          <div
            key={report.id}
            onClick={() => onSelectReport(report)}
            className={`p-4 rounded-2xl border transition-all cursor-pointer ${
              isSelected
                ? 'bg-surfaceLight border-fireRed/50 shadow-md ring-1 ring-fireRed/30'
                : 'bg-card border-cardBorder hover:border-textMuted/40 hover:bg-surfaceLight/50'
            }`}
          >
            {/* Top row: badge & time */}
            <div className="flex items-center justify-between gap-2 mb-2">
              <span
                className={`px-2.5 py-0.5 rounded-full text-xs font-bold border ${badge.color}`}
              >
                {badge.label}
              </span>
              <span className="text-[11px] font-medium text-textMuted flex items-center gap-1">
                <Clock className="w-3 h-3" />
                {formatTimeAgo(report.createdAt)}
              </span>
            </div>

            {/* Reporter Name */}
            <div className="flex items-center gap-1.5 text-xs text-textSecondary mb-1.5">
              <User className="w-3.5 h-3.5 text-orangeAccent" />
              <span className="font-semibold text-textPrimary">{report.reporterName}</span>
            </div>

            {/* Description if any */}
            {report.description && (
              <p className="text-xs text-textSecondary line-clamp-2 mb-2 italic">
                "{report.description}"
              </p>
            )}

            {/* Coordinates */}
            <div className="flex items-center gap-1 text-[11px] font-mono text-textMuted">
              <MapPin className="w-3 h-3 text-fireRedLight" />
              <span>
                {report.latitude.toFixed(4)}, {report.longitude.toFixed(4)}
              </span>
            </div>
          </div>
        );
      })}
    </div>
  );
};
