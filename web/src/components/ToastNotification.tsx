import React from 'react';
import { FireReport } from '../types/fireReport';
import { Bell, Flame, MapPin, X } from 'lucide-react';

interface ToastNotificationProps {
  toast: {
    id: string;
    report: FireReport;
  } | null;
  onClose: () => void;
  onClick: (report: FireReport) => void;
}

export const ToastNotification: React.FC<ToastNotificationProps> = ({
  toast,
  onClose,
  onClick,
}) => {
  if (!toast) return null;

  const { report } = toast;

  return (
    <div className="fixed bottom-5 right-5 z-50 max-w-sm w-full animate-bounce-short">
      <div className="p-4 rounded-2xl bg-surface border-2 border-fireRed shadow-2xl shadow-fireRed/30 backdrop-blur-xl">
        <div className="flex items-start justify-between gap-3">
          <div className="flex items-start gap-3">
            <div className="p-2.5 rounded-xl bg-fireRed text-white shrink-0 shadow-lg shadow-fireRed/50 animate-pulse">
              <Flame className="w-5 h-5" />
            </div>

            <div>
              <div className="flex items-center gap-1.5 text-xs font-extrabold text-fireRedLight uppercase tracking-wider mb-0.5">
                <Bell className="w-3.5 h-3.5" />
                <span>Yeni Yangın İhbarı!</span>
              </div>

              <h4 className="text-sm font-bold text-white mb-1">
                {report.fireType} Yangını · {report.reporterName}
              </h4>

              {report.description && (
                <p className="text-xs text-textSecondary line-clamp-1 italic mb-1.5">
                  "{report.description}"
                </p>
              )}

              <div className="flex items-center gap-2 text-[11px] text-textMuted font-mono">
                <span className="flex items-center gap-1">
                  <MapPin className="w-3 h-3 text-fireRedLight" />
                  {report.latitude.toFixed(4)}, {report.longitude.toFixed(4)}
                </span>
              </div>
            </div>
          </div>

          <button
            onClick={onClose}
            className="p-1 rounded-lg text-textMuted hover:text-white hover:bg-surfaceLight transition-colors"
          >
            <X className="w-4 h-4" />
          </button>
        </div>

        <div className="mt-3 pt-2.5 border-t border-cardBorder flex items-center justify-between">
          <span className="text-[10px] text-textMuted">SignalR Canlı Bildirim</span>
          <button
            onClick={() => onClick(report)}
            className="text-xs font-bold text-orangeAccent hover:underline"
          >
            Haritada Göster →
          </button>
        </div>
      </div>
    </div>
  );
};
