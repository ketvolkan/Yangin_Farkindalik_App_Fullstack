import React from 'react';
import { ShieldCheck, Flame, Users } from 'lucide-react';

export const FirefighterHero: React.FC = () => {
  return (
    <div className="relative overflow-hidden rounded-3xl bg-gradient-to-r from-[#2B1714] via-[#1F212E] to-[#171A24] border border-orangeAccent/30 p-6 sm:p-8 shadow-xl">
      {/* Background fire glow effects */}
      <div className="absolute top-0 right-0 w-96 h-96 bg-fireRed/10 rounded-full blur-3xl pointer-events-none -mr-20 -mt-20" />
      <div className="absolute bottom-0 left-1/3 w-64 h-64 bg-orangeAccent/10 rounded-full blur-2xl pointer-events-none" />

      <div className="relative z-10 max-w-3xl">
        {/* Badge */}
        <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-orangeAccent/15 border border-orangeAccent/30 text-orangeAccent text-xs font-bold mb-4">
          <span className="text-base">🚒</span>
          <span>25 Eylül - 1 Ekim · İtfaiye Haftası & Toplumsal Bilinç</span>
        </div>

        {/* Title */}
        <h2 className="text-2xl sm:text-3xl font-extrabold text-white tracking-tight leading-tight mb-3">
          Kahraman İtfaiyecilerimize Şükranla, <br className="hidden sm:block" />
          <span className="text-transparent bg-clip-text bg-gradient-to-r from-orangeAccent via-fireRedLight to-yellowWarning">
            Birlikte Daha Güvenli Bir Gelecek.
          </span>
        </h2>

        {/* Description */}
        <p className="text-sm sm:text-base text-textSecondary leading-relaxed mb-6">
          Yangınla mücadelede her saniye hayati değer taşır. FireAlert, vatandaşlar ile
          farkındalık ağını birleştirerek erken uyarının gücünü topluma sunar. Doğru bilgi
          ve hızlı iletişim hayat kurtarır.
        </p>

        {/* Feature Pill Tags */}
        <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
          <div className="flex items-center gap-2.5 p-3 rounded-xl bg-surface/80 border border-cardBorder">
            <div className="p-2 rounded-lg bg-fireRed/15 text-fireRedLight">
              <Flame className="w-4 h-4" />
            </div>
            <div>
              <h4 className="text-xs font-bold text-white">Erken Farkındalık</h4>
              <p className="text-[11px] text-textMuted">Görgü tanığı bildirimleri</p>
            </div>
          </div>

          <div className="flex items-center gap-2.5 p-3 rounded-xl bg-surface/80 border border-cardBorder">
            <div className="p-2 rounded-lg bg-orangeAccent/15 text-orangeAccent">
              <ShieldCheck className="w-4 h-4" />
            </div>
            <div>
              <h4 className="text-xs font-bold text-white">Arama & Kurtarma</h4>
              <p className="text-[11px] text-textMuted">Afet bilinci ve rehberler</p>
            </div>
          </div>

          <div className="flex items-center gap-2.5 p-3 rounded-xl bg-surface/80 border border-cardBorder">
            <div className="p-2 rounded-lg bg-greenSuccess/15 text-greenSuccess">
              <Users className="w-4 h-4" />
            </div>
            <div>
              <h4 className="text-xs font-bold text-white">Açık Dayanışma</h4>
              <p className="text-[11px] text-textMuted">Toplumsal sorumluluk</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};
