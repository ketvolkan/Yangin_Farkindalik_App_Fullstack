import { FireReport, CreateFireReportRequest } from '../types/fireReport';
import { BlogPost } from '../types/blog';
import { FireStatistics } from '../types/statistics';

const API_BASE = import.meta.env.VITE_API_BASE_URL
  ? `${import.meta.env.VITE_API_BASE_URL.replace(/\/$/, '')}/api`
  : '/api';

export const api = {
  // Fire Reports - Strictly from Backend
  async getAllReports(): Promise<FireReport[]> {
    const res = await fetch(`${API_BASE}/fire-reports`);
    if (!res.ok) throw new Error(`Yangın bildirimleri alınamadı (HTTP ${res.status})`);
    return res.json();
  },

  async getActiveReports(): Promise<FireReport[]> {
    const res = await fetch(`${API_BASE}/fire-reports/active`);
    if (!res.ok) throw new Error(`Aktif yangın bildirimleri alınamadı (HTTP ${res.status})`);
    return res.json();
  },

  async getReportById(id: number): Promise<FireReport> {
    const res = await fetch(`${API_BASE}/fire-reports/${id}`);
    if (!res.ok) throw new Error(`Yangın bildirimi bulunamadı (HTTP ${res.status})`);
    return res.json();
  },

  async createReport(data: CreateFireReportRequest): Promise<FireReport> {
    const res = await fetch(`${API_BASE}/fire-reports`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data),
    });
    if (!res.ok) throw new Error(`Yangın bildirimi gönderilemedi (HTTP ${res.status})`);
    return res.json();
  },

  // Statistics - Strictly from Backend
  async getStatistics(): Promise<FireStatistics> {
    const res = await fetch(`${API_BASE}/statistics`);
    if (!res.ok) throw new Error(`İstatistikler alınamadı (HTTP ${res.status})`);
    return res.json();
  },

  // Blog - Strictly from Backend
  async getBlogPosts(): Promise<BlogPost[]> {
    const res = await fetch(`${API_BASE}/blog`);
    if (!res.ok) throw new Error(`Blog yazıları alınamadı (HTTP ${res.status})`);
    return res.json();
  },

  async getBlogPostBySlug(slug: string): Promise<BlogPost> {
    const res = await fetch(`${API_BASE}/blog/${slug}`);
    if (!res.ok) throw new Error(`Blog yazısı bulunamadı (HTTP ${res.status})`);
    return res.json();
  },
};
