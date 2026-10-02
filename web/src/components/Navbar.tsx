import React from 'react';
import { Flame, PhoneCall, Radio, ShieldAlert } from 'lucide-react';

interface NavbarProps {
  onOpenReportModal: () => void;
  onNavigateToBlog: () => void;
  onNavigateToHome: () => void;
  currentPage: 'dashboard' | 'blog' | 'blog-detail';
}

export const Navbar: React.FC<NavbarProps> = ({
  onOpenReportModal,
  onNavigateToBlog,
  onNavigateToHome,
  currentPage,
}) => {
  return (
    <header className="sticky top-0 z-40 bg-surface/90 backdrop-blur-md border-b border-cardBorder">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between">
        {/* Brand */}
        <div
          onClick={onNavigateToHome}
          className="flex items-center gap-3 cursor-pointer group select-none"
        >
          <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-fireRed to-orangeAccent flex items-center justify-center shadow-lg shadow-fireRed/20 group-hover:scale-105 transition-transform">
            <Flame className="w-6 h-6 text-white" />
          </div>
          <div>
            <div className="flex items-center gap-2">
              <span className="font-extrabold text-xl tracking-tight text-white group-hover:text-fireRedLight transition-colors">
                FireAlert
              </span>
              <span className="hidden sm:inline-flex items-center gap-1.5 px-2 py-0.5 rounded-full text-xs font-semibold bg-fireRed/10 text-fireRedLight border border-fireRed/20">
                <Radio className="w-3 h-3 animate-pulse" />
                CANLI
              </span>
            </div>
            <p className="text-[10px] text-textMuted leading-none hidden sm:block">
              Sosyal Yangın Farkındalık Platformu
            </p>
          </div>
        </div>

        {/* Center / Navigation Links */}
        <nav className="flex items-center gap-2 sm:gap-4">
          <button
            onClick={onNavigateToHome}
            className={`px-3 py-1.5 rounded-lg text-sm font-medium transition-colors ${
              currentPage === 'dashboard'
                ? 'text-white bg-surfaceLight'
                : 'text-textSecondary hover:text-white hover:bg-surfaceLight/50'
            }`}
          >
            Harita & İstatistik
          </button>
          <button
            onClick={onNavigateToBlog}
            className={`px-3 py-1.5 rounded-lg text-sm font-medium transition-colors ${
              currentPage === 'blog' || currentPage === 'blog-detail'
                ? 'text-white bg-surfaceLight'
                : 'text-textSecondary hover:text-white hover:bg-surfaceLight/50'
            }`}
          >
            Yangın Rehberi & Blog
          </button>
        </nav>

        {/* Actions */}
        <div className="flex items-center gap-2.5 sm:gap-3">
          {/* Emergency 112 Dial */}
          <a
            href="tel:112"
            className="flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-fireRed/10 hover:bg-fireRed/20 text-fireRedLight border border-fireRed/30 text-xs sm:text-sm font-bold transition-colors"
            title="Acil Durum 112 Çağrı Merkezi"
          >
            <PhoneCall className="w-4 h-4 text-fireRed" />
            <span className="hidden xs:inline">112</span>
            <span>ACİL</span>
          </a>

          {/* Report Fire Button */}
          <button
            onClick={onOpenReportModal}
            className="flex items-center gap-2 px-3.5 py-1.5 sm:px-4 sm:py-2 rounded-xl bg-fireRed hover:bg-fireRedLight text-white font-bold text-xs sm:text-sm shadow-lg shadow-fireRed/25 hover:shadow-fireRed/40 transition-all hover:scale-[1.02] active:scale-[0.98]"
          >
            <ShieldAlert className="w-4 h-4" />
            <span>Yangın İhbarı Ver</span>
          </button>
        </div>
      </div>
    </header>
  );
};
