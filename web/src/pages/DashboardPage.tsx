import React from 'react';
import { FireReport } from '../types/fireReport';
import { FireStatistics } from '../types/statistics';
import { BlogPost } from '../types/blog';
import { StatisticsCards } from '../components/StatisticsCards';
import { FireMap } from '../components/FireMap';
import { FireReportList } from '../components/FireReportList';
import { FirefighterHero } from '../components/FirefighterHero';
import { BlogSection } from '../components/BlogSection';
import { AlertCircle, Flame, ListOrdered } from 'lucide-react';

interface DashboardPageProps {
  reports: FireReport[];
  stats: FireStatistics;
  blogs: BlogPost[];
  isLoading: boolean;
  selectedReport: FireReport | null;
  onSelectReport: (report: FireReport | null) => void;
  onRefresh: () => void;
  onSelectBlogPost: (post: BlogPost) => void;
  onOpenReportModal: () => void;
}

export const DashboardPage: React.FC<DashboardPageProps> = ({
  reports,
  stats,
  blogs,
  isLoading,
  selectedReport,
  onSelectReport,
  onRefresh,
  onSelectBlogPost,
  onOpenReportModal,
}) => {
  return (
    <div className="space-y-8">
      {/* Top Disclaimer Banner */}
      <div className="p-3.5 rounded-2xl bg-fireRed/10 border border-fireRed/25 flex items-center justify-between gap-4 flex-wrap">
        <div className="flex items-center gap-3">
          <div className="p-2 rounded-xl bg-fireRed/20 text-fireRedLight shrink-0">
            <AlertCircle className="w-5 h-5" />
          </div>
          <div>
            <h4 className="text-xs font-bold text-white uppercase tracking-wider">
              Toplumsal Yangın Farkındalık Sistemi
            </h4>
            <p className="text-xs text-textSecondary">
              Kullanıcı bildirimleri resmi ihbar yerine geçmez. Acil durumlarda lütfen{' '}
              <a href="tel:112" className="text-fireRedLight font-bold underline">
                112 Acil Çağrı Merkezi
              </a>
              'ni arayınız.
            </p>
          </div>
        </div>

        <button
          onClick={onOpenReportModal}
          className="px-3.5 py-1.5 rounded-xl bg-fireRed hover:bg-fireRedLight text-white text-xs font-bold transition-colors flex items-center gap-1.5 shrink-0"
        >
          <Flame className="w-3.5 h-3.5" />
          <span>İhbar Gönder</span>
        </button>
      </div>

      {/* Main Grid: Left Stats | Center Map | Right Feed */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
        {/* Left Column: Live Statistics Cards (4 cols on lg) */}
        <div className="lg:col-span-3 space-y-4">
          <div className="flex items-center justify-between px-1">
            <h3 className="text-sm font-extrabold text-white tracking-wider uppercase flex items-center gap-1.5">
              <Flame className="w-4 h-4 text-fireRedLight" />
              <span>İstatistikler</span>
            </h3>
            <span className="text-[11px] font-medium text-textMuted">Canlı Veri</span>
          </div>

          <StatisticsCards stats={stats} isLoading={isLoading} />
        </div>

        {/* Center Column: Live Fire Map (6 cols on lg) */}
        <div className="lg:col-span-6 space-y-2">
          <FireMap
            reports={reports}
            isLoading={isLoading}
            onRefresh={onRefresh}
            selectedReport={selectedReport}
            onSelectReport={onSelectReport}
          />
        </div>

        {/* Right Column: Latest Active Reports Feed (3 cols on lg) */}
        <div className="lg:col-span-3 space-y-3">
          <div className="flex items-center justify-between px-1">
            <h3 className="text-sm font-extrabold text-white tracking-wider uppercase flex items-center gap-1.5">
              <ListOrdered className="w-4 h-4 text-orangeAccent" />
              <span>Son Bildirimler</span>
            </h3>
            <span className="px-2 py-0.5 rounded-full text-[11px] font-bold bg-surfaceLight text-textSecondary">
              {reports.length} İhbar
            </span>
          </div>

          <FireReportList
            reports={reports}
            selectedReport={selectedReport}
            onSelectReport={(r) => onSelectReport(r)}
            isLoading={isLoading}
          />
        </div>
      </div>

      {/* Hero Section: İtfaiye Haftası & Farkındalık */}
      <FirefighterHero />

      {/* Blog & Fire Safety Guides */}
      <BlogSection posts={blogs} onSelectPost={onSelectBlogPost} isLoading={isLoading} />
    </div>
  );
};
