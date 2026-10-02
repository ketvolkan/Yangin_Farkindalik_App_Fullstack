import { FireReport, CreateFireReportRequest } from '../types/fireReport';
import { BlogPost } from '../types/blog';
import { FireStatistics } from '../types/statistics';

const BASE_URL = '/api';

export const api = {
  // Fire Reports
  async getAllReports(): Promise<FireReport[]> {
    const res = await fetch(`${BASE_URL}/fire-reports`);
    if (!res.ok) throw new Error('Yangın bildirimleri alınamadı.');
    return res.json();
  },

  async getActiveReports(): Promise<FireReport[]> {
    const res = await fetch(`${BASE_URL}/fire-reports/active`);
    if (!res.ok) throw new Error('Aktif yangın bildirimleri alınamadı.');
    return res.json();
  },

  async getReportById(id: number): Promise<FireReport> {
    const res = await fetch(`${BASE_URL}/fire-reports/${id}`);
    if (!res.ok) throw new Error('Yangın bildirimi bulunamadı.');
    return res.json();
  },

  async createReport(data: CreateFireReportRequest): Promise<FireReport> {
    const res = await fetch(`${BASE_URL}/fire-reports`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data),
    });
    if (!res.ok) throw new Error('Yangın bildirimi gönderilemedi.');
    return res.json();
  },

  // Statistics
  async getStatistics(): Promise<FireStatistics> {
    const res = await fetch(`${BASE_URL}/statistics`);
    if (!res.ok) throw new Error('İstatistikler alınamadı.');
    return res.json();
  },

  // Blog
  async getBlogPosts(): Promise<BlogPost[]> {
    const res = await fetch(`${BASE_URL}/blog`);
    if (!res.ok) throw new Error('Blog yazıları alınamadı.');
    return res.json();
  },

  async getBlogPostBySlug(slug: string): Promise<BlogPost> {
    const res = await fetch(`${BASE_URL}/blog/${slug}`);
    if (!res.ok) throw new Error('Blog yazısı bulunamadı.');
    return res.json();
  },
};
