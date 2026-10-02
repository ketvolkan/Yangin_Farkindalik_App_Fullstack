import React, { useState } from 'react';
import { api } from '../services/api';
import { AlertTriangle, CheckCircle2, Flame, Loader2, MapPin, X } from 'lucide-react';

interface ReportModalProps {
  isOpen: boolean;
  onClose: () => void;
  onSuccess: () => void;
}

export const ReportModal: React.FC<ReportModalProps> = ({ isOpen, onClose, onSuccess }) => {
  const [reporterName, setReporterName] = useState('');
  const [fireType, setFireType] = useState('Forest');
  const [description, setDescription] = useState('');
  const [latitude, setLatitude] = useState<number | ''>(38.4237);
  const [longitude, setLongitude] = useState<number | ''>(27.1428);
  const [isLocating, setIsLocating] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState('');
  const [isSuccess, setIsSuccess] = useState(false);

  if (!isOpen) return null;

  const handleGetCurrentLocation = () => {
    if (!navigator.geolocation) {
      setError('Tarayıcınız konum servisini desteklemiyor.');
      return;
    }
    setIsLocating(true);
    setError('');

    navigator.geolocation.getCurrentPosition(
      (pos) => {
        setLatitude(pos.coords.latitude);
        setLongitude(pos.coords.longitude);
        setIsLocating(false);
      },
      (err) => {
        setError(`Konum alınamadı: ${err.message}. Varsayılan koordinatlar kullanılıyor.`);
        setIsLocating(false);
      },
      { timeout: 10000, enableHighAccuracy: true }
    );
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');

    if (!reporterName.trim() || reporterName.trim().length < 3) {
      setError('Ad Soyad en az 3 karakter olmalıdır.');
      return;
    }

    if (latitude === '' || longitude === '') {
      setError('Lütfen geçerli bir konum giriniz.');
      return;
    }

    setIsSubmitting(true);
    try {
      await api.createReport({
        reporterName: reporterName.trim(),
        fireType,
        description: description.trim() || undefined,
        latitude: Number(latitude),
        longitude: Number(longitude),
      });

      setIsSuccess(true);
      setTimeout(() => {
        onSuccess();
        setIsSuccess(false);
        setReporterName('');
        setDescription('');
        onClose();
      }, 1800);
    } catch (err: any) {
      setError(err.message || 'İhbar gönderilemedi.');
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/80 backdrop-blur-sm animate-fade-in">
      <div className="relative w-full max-w-lg rounded-3xl bg-surface border border-cardBorder shadow-2xl overflow-hidden p-6 sm:p-8 max-h-[90vh] overflow-y-auto">
        {/* Close button */}
        <button
          onClick={onClose}
          className="absolute top-5 right-5 p-2 rounded-xl text-textMuted hover:text-white hover:bg-surfaceLight transition-colors"
        >
          <X className="w-5 h-5" />
        </button>

        {isSuccess ? (
          <div className="py-12 text-center space-y-4">
            <div className="w-16 h-16 rounded-full bg-greenSuccess/15 border border-greenSuccess/30 text-greenSuccess flex items-center justify-center mx-auto">
              <CheckCircle2 className="w-10 h-10" />
            </div>
            <h3 className="text-xl font-extrabold text-white">İhbarınız Alındı</h3>
            <p className="text-sm text-textSecondary max-w-xs mx-auto">
              Bildiriminiz canlı haritaya eklendi ve tüm kullanıcılara aktarıldı.
            </p>
          </div>
        ) : (
          <div>
            {/* Header */}
            <div className="flex items-center gap-3 mb-4">
              <div className="p-2.5 rounded-xl bg-fireRed/15 text-fireRedLight">
                <Flame className="w-6 h-6" />
              </div>
              <div>
                <h3 className="text-xl font-extrabold text-white">Yangın İhbarı Bildir</h3>
                <p className="text-xs text-textSecondary">Gördüğünüz yangını toplulukla paylaşın</p>
              </div>
            </div>

            {/* Disclaimer Banner */}
            <div className="p-3 rounded-xl bg-fireRed/10 border border-fireRed/30 text-xs text-textSecondary flex items-start gap-2 mb-5">
              <AlertTriangle className="w-4 h-4 text-fireRedLight shrink-0 mt-0.5" />
              <span>
                Bu bildirim resmi acil ihbar değildir. Acil durumlarda derhal <strong>112</strong>'yi arayın.
              </span>
            </div>

            {/* Form */}
            <form onSubmit={handleSubmit} className="space-y-4">
              {/* Reporter Name */}
              <div>
                <label className="block text-xs font-bold text-textSecondary mb-1.5">
                  Ad Soyad *
                </label>
                <input
                  type="text"
                  required
                  placeholder="Örn: Volkan Ket"
                  value={reporterName}
                  onChange={(e) => setReporterName(e.target.value)}
                  className="w-full px-4 py-2.5 rounded-xl bg-surfaceLight border border-cardBorder text-white text-sm focus:outline-none focus:border-fireRed"
                />
              </div>

              {/* Fire Type */}
              <div>
                <label className="block text-xs font-bold text-textSecondary mb-1.5">
                  Yangın Türü *
                </label>
                <select
                  value={fireType}
                  onChange={(e) => setFireType(e.target.value)}
                  className="w-full px-4 py-2.5 rounded-xl bg-surfaceLight border border-cardBorder text-white text-sm focus:outline-none focus:border-fireRed"
                >
                  <option value="Forest">🌲 Orman Yangını</option>
                  <option value="Building">🏠 Bina Yangını</option>
                  <option value="Vehicle">🚗 Araç Yangını</option>
                  <option value="Electric">⚡ Elektrik Yangını</option>
                  <option value="Other">🔥 Diğer</option>
                </select>
              </div>

              {/* Coordinates */}
              <div>
                <div className="flex items-center justify-between mb-1.5">
                  <label className="text-xs font-bold text-textSecondary">Konum Koordinatları *</label>
                  <button
                    type="button"
                    onClick={handleGetCurrentLocation}
                    disabled={isLocating}
                    className="text-xs font-bold text-orangeAccent hover:underline flex items-center gap-1"
                  >
                    <MapPin className="w-3.5 h-3.5" />
                    <span>{isLocating ? 'Alınıyor...' : 'Konumumu Bul'}</span>
                  </button>
                </div>
                <div className="grid grid-cols-2 gap-2">
                  <input
                    type="number"
                    step="any"
                    required
                    placeholder="Enlem (Lat)"
                    value={latitude}
                    onChange={(e) => setLatitude(e.target.value === '' ? '' : parseFloat(e.target.value))}
                    className="px-4 py-2 rounded-xl bg-surfaceLight border border-cardBorder text-white text-sm font-mono focus:outline-none focus:border-fireRed"
                  />
                  <input
                    type="number"
                    step="any"
                    required
                    placeholder="Boylam (Lng)"
                    value={longitude}
                    onChange={(e) => setLongitude(e.target.value === '' ? '' : parseFloat(e.target.value))}
                    className="px-4 py-2 rounded-xl bg-surfaceLight border border-cardBorder text-white text-sm font-mono focus:outline-none focus:border-fireRed"
                  />
                </div>
              </div>

              {/* Description */}
              <div>
                <label className="block text-xs font-bold text-textSecondary mb-1.5">
                  Açıklama (Opsiyonel)
                </label>
                <textarea
                  rows={2}
                  placeholder="Örn: Yoğun duman görülüyor, batı rüzgarı var."
                  value={description}
                  onChange={(e) => setDescription(e.target.value)}
                  className="w-full px-4 py-2 rounded-xl bg-surfaceLight border border-cardBorder text-white text-sm focus:outline-none focus:border-fireRed resize-none"
                />
              </div>

              {error && (
                <div className="p-3 rounded-xl bg-fireRed/15 border border-fireRed/40 text-xs text-fireRedLight">
                  {error}
                </div>
              )}

              {/* Submit button */}
              <button
                type="submit"
                disabled={isSubmitting}
                className="w-full py-3 rounded-xl bg-fireRed hover:bg-fireRedLight text-white font-extrabold text-sm shadow-lg shadow-fireRed/30 transition-all flex items-center justify-center gap-2"
              >
                {isSubmitting ? (
                  <>
                    <Loader2 className="w-4 h-4 animate-spin" />
                    <span>Gönderiliyor...</span>
                  </>
                ) : (
                  <>
                    <Flame className="w-4 h-4" />
                    <span>İhbarı Gönder</span>
                  </>
                )}
              </button>
            </form>
          </div>
        )}
      </div>
    </div>
  );
};
