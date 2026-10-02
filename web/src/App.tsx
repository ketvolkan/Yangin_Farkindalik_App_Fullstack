import React, { useEffect, useState } from 'react';
import { FireReport } from './types/fireReport';
import { FireStatistics } from './types/statistics';
import { BlogPost } from './types/blog';
import { api } from './services/api';
import { signalRService } from './services/signalrService';
import { Navbar } from './components/Navbar';
import { ToastNotification } from './components/ToastNotification';
import { ReportModal } from './components/ReportModal';
import { DashboardPage } from './pages/DashboardPage';
import { BlogDetailPage } from './pages/BlogDetailPage';
import { BlogSection } from './components/BlogSection';
import { AlertTriangle, RefreshCw } from 'lucide-react';

export const App: React.FC = () => {
  const [currentPage, setCurrentPage] = useState<'dashboard' | 'blog' | 'blog-detail'>('dashboard');
  const [selectedBlogSlug, setSelectedBlogSlug] = useState<string>('');

  const [reports, setReports] = useState<FireReport[]>([]);
  const [stats, setStats] = useState<FireStatistics>({
    today: 0,
    thisWeek: 0,
    thisMonth: 0,
    total: 0,
  });
  const [blogs, setBlogs] = useState<BlogPost[]>([]);
  const [selectedReport, setSelectedReport] = useState<FireReport | null>(null);

  const [isLoading, setIsLoading] = useState<boolean>(true);
  const [apiError, setApiError] = useState<string>('');
  const [isReportModalOpen, setIsReportModalOpen] = useState<boolean>(false);
  const [toast, setToast] = useState<{ id: string; report: FireReport } | null>(null);

  // Fetch data strictly from Backend API (No Dummy Data)
  const loadInitialData = async () => {
    setIsLoading(true);
    setApiError('');
    try {
      const [activeReports, initialStats, blogPosts] = await Promise.all([
        api.getActiveReports(),
        api.getStatistics(),
        api.getBlogPosts(),
      ]);

      setReports(activeReports);
      setStats(initialStats);
      setBlogs(blogPosts);
    } catch (err: any) {
      console.error('Backend API veri çekme hatası:', err);
      setApiError(
        'Backend API ile bağlantı kurulamadı. Lütfen .NET API servisinin çalıştığından emin olun (http://localhost:5000).'
      );
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    loadInitialData();

    // Start SignalR connection to Backend
    signalRService.startConnection();

    // Subscribe to real-time FireReportCreated event from Backend
    const unsubscribeFire = signalRService.onFireReportCreated((newReport) => {
      console.log('⚡ [App] Backend SignalR Yeni Yangın Bildirimi:', newReport);

      // 1. Update live reports state
      setReports((prev) => {
        const exists = prev.some((r) => r.id === newReport.id);
        if (exists) return prev;
        return [newReport, ...prev];
      });

      // 2. Update live statistics state
      if (newReport.stats) {
        setStats(newReport.stats);
      } else {
        setStats((prev) => ({
          today: prev.today + 1,
          thisWeek: prev.thisWeek + 1,
          thisMonth: prev.thisMonth + 1,
          total: prev.total + 1,
        }));
      }

      // 3. Trigger Toast Notification
      setToast({
        id: String(newReport.id || Date.now()),
        report: newReport,
      });

      setTimeout(() => {
        setToast((current) => (current?.report.id === newReport.id ? null : current));
      }, 7000);
    });

    // Subscribe to real-time StatisticsUpdated event from Backend
    const unsubscribeStats = signalRService.onStatisticsUpdated((updatedStats) => {
      console.log('⚡ [App] Backend SignalR İstatistik Güncellemesi:', updatedStats);
      setStats(updatedStats);
    });

    return () => {
      unsubscribeFire();
      unsubscribeStats();
    };
  }, []);

  const handleSelectBlogPost = (post: BlogPost) => {
    setSelectedBlogSlug(post.slug);
    setCurrentPage('blog-detail');
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  const handleToastClick = (report: FireReport) => {
    setCurrentPage('dashboard');
    setSelectedReport(report);
    setToast(null);
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  return (
    <div className="min-h-screen flex flex-col bg-background text-textPrimary">
      {/* Navbar */}
      <Navbar
        currentPage={currentPage}
        onNavigateToHome={() => setCurrentPage('dashboard')}
        onNavigateToBlog={() => setCurrentPage('blog')}
        onOpenReportModal={() => setIsReportModalOpen(true)}
      />

      {/* API Connection Error Banner */}
      {apiError && (
        <div className="bg-fireRed/15 border-b border-fireRed/30 px-4 py-3">
          <div className="max-w-7xl mx-auto flex items-center justify-between gap-4 flex-wrap">
            <div className="flex items-center gap-2 text-xs sm:text-sm text-fireRedLight font-semibold">
              <AlertTriangle className="w-4 h-4 shrink-0" />
              <span>{apiError}</span>
            </div>
            <button
              onClick={loadInitialData}
              className="px-3 py-1 rounded-lg bg-fireRed text-white text-xs font-bold hover:bg-fireRedLight transition-colors flex items-center gap-1.5 shrink-0"
            >
              <RefreshCw className="w-3 h-3" />
              <span>Tekrar Dene</span>
            </button>
          </div>
        </div>
      )}

      {/* Main Content Area */}
      <main className="flex-1 max-w-7xl w-full mx-auto px-4 sm:px-6 lg:px-8 py-6 sm:py-8">
        {currentPage === 'dashboard' && (
          <DashboardPage
            reports={reports}
            stats={stats}
            blogs={blogs}
            isLoading={isLoading}
            selectedReport={selectedReport}
            onSelectReport={setSelectedReport}
            onRefresh={loadInitialData}
            onSelectBlogPost={handleSelectBlogPost}
            onOpenReportModal={() => setIsReportModalOpen(true)}
          />
        )}

        {currentPage === 'blog' && (
          <div className="space-y-8">
            <div className="text-center max-w-2xl mx-auto py-6">
              <span className="text-xs font-bold text-orangeAccent uppercase tracking-widest">
                Toplumsal Farkındalık
              </span>
              <h1 className="text-3xl sm:text-4xl font-extrabold text-white mt-2 mb-3">
                Yangın Güvenliği & Bilinç Makaleleri
              </h1>
              <p className="text-sm text-textSecondary">
                Yangın anında doğru müdahale, tahliye yöntemleri ve önleyici güvenlik bilgileri.
              </p>
            </div>
            <BlogSection posts={blogs} onSelectPost={handleSelectBlogPost} isLoading={isLoading} />
          </div>
        )}

        {currentPage === 'blog-detail' && (
          <BlogDetailPage slug={selectedBlogSlug} onBack={() => setCurrentPage('dashboard')} />
        )}
      </main>

      {/* Footer */}
      <footer className="border-t border-cardBorder bg-surface py-8 mt-12">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 flex flex-col sm:flex-row items-center justify-between gap-4 text-center sm:text-left">
          <div>
            <div className="flex items-center justify-center sm:justify-start gap-2 mb-1">
              <span className="text-lg">🔥</span>
              <span className="font-bold text-white text-sm">FireAlert Platformu</span>
            </div>
            <p className="text-xs text-textMuted max-w-md">
              Bu platform kar amacı gütmeyen açık bir sosyal farkındalık projesidir.
              Resmi acil durumlar için lütfen 112'yi arayınız.
            </p>
          </div>

          <div className="flex items-center gap-4 text-xs text-textSecondary">
            <span>Türkiye Yangın Farkındalık Ağı</span>
            <span>·</span>
            <span className="text-fireRedLight font-bold">112 Acil Çağrı</span>
          </div>
        </div>
      </footer>

      {/* Toast notification for real-time fire alert */}
      <ToastNotification
        toast={toast}
        onClose={() => setToast(null)}
        onClick={handleToastClick}
      />

      {/* Report Modal */}
      <ReportModal
        isOpen={isReportModalOpen}
        onClose={() => setIsReportModalOpen(false)}
        onSuccess={() => {
          loadInitialData();
        }}
      />
    </div>
  );
};

export default App;
