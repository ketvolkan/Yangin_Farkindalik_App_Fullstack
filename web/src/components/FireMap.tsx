import React, { useState } from 'react';
import { MapContainer, TileLayer, Marker, Popup, useMap } from 'react-leaflet';
import L from 'leaflet';
import { FireReport } from '../types/fireReport';
import { Clock, Eye, Filter, Flame, MapPin, RefreshCw, User } from 'lucide-react';

interface FireMapProps {
  reports: FireReport[];
  isLoading?: boolean;
  onRefresh?: () => void;
  selectedReport?: FireReport | null;
  onSelectReport?: (report: FireReport | null) => void;
}

// Custom emoji icon generator for leaflet markers
const createCustomFireIcon = (fireType: string, isSelected: boolean) => {
  let emoji = '🔥';
  switch (fireType?.toLowerCase()) {
    case 'forest':
      emoji = '🌲';
      break;
    case 'building':
      emoji = '🏠';
      break;
    case 'vehicle':
      emoji = '🚗';
      break;
    case 'electric':
      emoji = '⚡';
      break;
    default:
      emoji = '🔥';
  }

  const pulseClass = isSelected ? 'ring-4 ring-orangeAccent scale-125' : 'fire-marker-pulse';

  return L.divIcon({
    className: 'custom-fire-marker',
    html: `
      <div class="w-9 h-9 rounded-full bg-fireRed border-2 border-white flex items-center justify-center text-sm shadow-lg cursor-pointer ${pulseClass} transition-transform">
        <span>${emoji}</span>
      </div>
    `,
    iconSize: [36, 36],
    iconAnchor: [18, 18],
    popupAnchor: [0, -20],
  });
};

const formatTime = (isoString: string) => {
  const date = new Date(isoString);
  return date.toLocaleTimeString('tr-TR', { hour: '2-digit', minute: '2-digit' });
};

const formatDate = (isoString: string) => {
  const date = new Date(isoString);
  return date.toLocaleDateString('tr-TR', { day: 'numeric', month: 'short' });
};

const getFireTypeLabel = (fireType: string) => {
  switch (fireType?.toLowerCase()) {
    case 'forest':
      return 'Orman Yangını';
    case 'building':
      return 'Bina Yangını';
    case 'vehicle':
      return 'Araç Yangını';
    case 'electric':
      return 'Elektrik Yangını';
    default:
      return 'Diğer Yangın';
  }
};

// Sub-component to re-center map when needed
const MapController: React.FC<{ center: [number, number]; zoom: number }> = ({ center, zoom }) => {
  const map = useMap();
  React.useEffect(() => {
    map.setView(center, zoom);
  }, [center, zoom, map]);
  return null;
};

export const FireMap: React.FC<FireMapProps> = ({
  reports,
  isLoading,
  onRefresh,
  selectedReport,
  onSelectReport,
}) => {
  const [selectedFilter, setSelectedFilter] = useState<string>('all');
  const defaultCenter: [number, number] = [38.9637, 35.2433]; // Turkey Center
  const [mapCenter, setMapCenter] = useState<[number, number]>(
    reports.length > 0 ? [reports[0].latitude, reports[0].longitude] : defaultCenter
  );
  const [mapZoom, setMapZoom] = useState<number>(reports.length > 0 ? 7 : 6);

  // Filtered reports
  const filteredReports = reports.filter((r) => {
    if (selectedFilter === 'all') return true;
    return r.fireType.toLowerCase() === selectedFilter.toLowerCase();
  });

  const handleMarkerClick = (report: FireReport) => {
    setMapCenter([report.latitude, report.longitude]);
    setMapZoom(11);
    onSelectReport?.(report);
  };

  const handleResetView = () => {
    if (reports.length > 0) {
      setMapCenter([reports[0].latitude, reports[0].longitude]);
      setMapZoom(7);
    } else {
      setMapCenter(defaultCenter);
      setMapZoom(6);
    }
    onSelectReport?.(null);
  };

  return (
    <div className="relative w-full h-[520px] lg:h-[620px] rounded-2xl overflow-hidden border border-cardBorder bg-card shadow-lg flex flex-col">
      {/* Top Map Controls Bar */}
      <div className="absolute top-3 left-3 right-3 z-[1000] flex flex-wrap items-center justify-between gap-2 pointer-events-none">
        {/* Left Filter & Status */}
        <div className="flex items-center gap-2 pointer-events-auto bg-surface/90 backdrop-blur-md px-3 py-1.5 rounded-xl border border-cardBorder shadow-md">
          <span className="flex items-center gap-1.5 text-xs font-bold text-white">
            <span className="w-2.5 h-2.5 rounded-full bg-fireRed animate-ping" />
            <span className="w-2.5 h-2.5 rounded-full bg-fireRed absolute" />
            {filteredReports.length} Aktif Yangın
          </span>

          <div className="h-4 w-[1px] bg-cardBorder mx-1" />

          {/* Filter Dropdown */}
          <div className="flex items-center gap-1">
            <Filter className="w-3.5 h-3.5 text-textMuted" />
            <select
              value={selectedFilter}
              onChange={(e) => setSelectedFilter(e.target.value)}
              className="bg-transparent text-xs text-textSecondary font-semibold focus:outline-none cursor-pointer"
            >
              <option value="all" className="bg-surface text-white">Tüm Türler</option>
              <option value="forest" className="bg-surface text-white">🌲 Orman</option>
              <option value="building" className="bg-surface text-white">🏠 Bina</option>
              <option value="vehicle" className="bg-surface text-white">🚗 Araç</option>
              <option value="electric" className="bg-surface text-white">⚡ Elektrik</option>
              <option value="other" className="bg-surface text-white">🔥 Diğer</option>
            </select>
          </div>
        </div>

        {/* Right Action Buttons */}
        <div className="flex items-center gap-2 pointer-events-auto">
          <button
            onClick={handleResetView}
            className="px-3 py-1.5 bg-surface/90 hover:bg-surfaceLight backdrop-blur-md rounded-xl border border-cardBorder text-xs font-semibold text-textSecondary hover:text-white shadow-md transition-colors flex items-center gap-1.5"
            title="Haritayı Sıfırla"
          >
            <Eye className="w-3.5 h-3.5 text-orangeAccent" />
            <span>Merkeze Al</span>
          </button>

          {onRefresh && (
            <button
              onClick={onRefresh}
              disabled={isLoading}
              className="p-2 bg-surface/90 hover:bg-surfaceLight backdrop-blur-md rounded-xl border border-cardBorder text-textSecondary hover:text-white shadow-md transition-colors"
              title="Yenile"
            >
              <RefreshCw className={`w-3.5 h-3.5 ${isLoading ? 'animate-spin text-fireRed' : ''}`} />
            </button>
          )}
        </div>
      </div>

      {/* Leaflet Map */}
      <div className="w-full h-full">
        {(() => {
          const mapboxToken = import.meta.env.VITE_MAPBOX_ACCESS_TOKEN;
          const tileUrl = mapboxToken
            ? `https://api.mapbox.com/styles/v1/mapbox/dark-v11/tiles/512/{z}/{x}/{y}@2x?access_token=${mapboxToken}`
            : 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png';
          const attribution = mapboxToken
            ? '&copy; <a href="https://www.mapbox.com/">Mapbox</a> &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>'
            : '&copy; <a href="https://carto.com/">CartoDB</a>, &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>';

          return (
            <MapContainer
              center={mapCenter}
              zoom={mapZoom}
              scrollWheelZoom={true}
              className={`w-full h-full ${mapboxToken ? '' : 'dark-tiles'}`}
            >
              <MapController center={mapCenter} zoom={mapZoom} />

              <TileLayer
                attribution={attribution}
                url={tileUrl}
                tileSize={mapboxToken ? 512 : 256}
                zoomOffset={mapboxToken ? -1 : 0}
                maxZoom={19}
              />

              {filteredReports.map((report) => (
                <Marker
                  key={report.id}
                  position={[report.latitude, report.longitude]}
                  icon={createCustomFireIcon(report.fireType, selectedReport?.id === report.id)}
                  eventHandlers={{
                    click: () => handleMarkerClick(report),
                  }}
                >
                  <Popup className="custom-fire-popup">
                    <div className="p-1 min-w-[220px]">
                      {/* Header */}
                      <div className="flex items-center justify-between gap-2 border-b border-cardBorder pb-2 mb-2">
                        <span className="text-xs font-bold text-fireRedLight uppercase tracking-wider flex items-center gap-1">
                          <Flame className="w-3.5 h-3.5" />
                          {getFireTypeLabel(report.fireType)}
                        </span>
                        <span className="text-[10px] text-textMuted bg-surfaceLight px-1.5 py-0.5 rounded font-mono">
                          #{report.id}
                        </span>
                      </div>

                      {/* Reporter & Time */}
                      <div className="space-y-1.5 text-xs text-textSecondary mb-3">
                        <div className="flex items-center gap-1.5">
                          <User className="w-3.5 h-3.5 text-orangeAccent shrink-0" />
                          <span className="font-semibold text-textPrimary">{report.reporterName}</span>
                        </div>

                        <div className="flex items-center gap-1.5">
                          <Clock className="w-3.5 h-3.5 text-textMuted shrink-0" />
                          <span>{formatTime(report.createdAt)} · {formatDate(report.createdAt)}</span>
                        </div>

                        <div className="flex items-center gap-1.5">
                          <MapPin className="w-3.5 h-3.5 text-fireRed shrink-0" />
                          <span className="font-mono text-[11px] text-textMuted">
                            {report.latitude.toFixed(4)}, {report.longitude.toFixed(4)}
                          </span>
                        </div>
                      </div>

                      {/* Description */}
                      {report.description && (
                        <div className="p-2 rounded-lg bg-surfaceLight/80 text-xs text-textPrimary italic border border-cardBorder/50 mb-2">
                          "{report.description}"
                        </div>
                      )}

                      {/* Emergency notice */}
                      <div className="text-[10px] text-textMuted text-center border-t border-cardBorder pt-1.5">
                        Acil durumlar için <strong className="text-fireRedLight">112</strong>'yi arayın.
                      </div>
                    </div>
                  </Popup>
                </Marker>
              ))}
            </MapContainer>
          );
        })()}
      </div>
    </div>
  );
};
