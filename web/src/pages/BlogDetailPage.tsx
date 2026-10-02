import React, { useEffect, useState } from 'react';
import { BlogPost } from '../types/blog';
import { api } from '../services/api';
import { ArrowLeft, BookOpen, Calendar, ShieldAlert } from 'lucide-react';

interface BlogDetailPageProps {
  slug: string;
  onBack: () => void;
}

export const BlogDetailPage: React.FC<BlogDetailPageProps> = ({ slug, onBack }) => {
  const [post, setPost] = useState<BlogPost | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    const fetchPost = async () => {
      setIsLoading(true);
      try {
        const data = await api.getBlogPostBySlug(slug);
        setPost(data);
      } catch (err: any) {
        setError('Makale yüklenemedi.');
      } finally {
        setIsLoading(false);
      }
    };
    fetchPost();
  }, [slug]);

  if (isLoading) {
    return (
      <div className="max-w-4xl mx-auto px-4 py-12">
        <div className="animate-pulse space-y-4">
          <div className="h-6 bg-surfaceLight rounded w-1/4" />
          <div className="h-10 bg-surfaceLight rounded w-3/4" />
          <div className="h-48 bg-surfaceLight rounded" />
        </div>
      </div>
    );
  }

  if (error || !post) {
    return (
      <div className="max-w-4xl mx-auto px-4 py-12 text-center">
        <h3 className="text-lg font-bold text-white mb-2">Makale Bulunamadı</h3>
        <p className="text-sm text-textSecondary mb-4">Aradığınız makale mevcut değil veya kaldırılmış olabilir.</p>
        <button
          onClick={onBack}
          className="px-4 py-2 rounded-xl bg-surfaceLight text-white text-sm font-semibold hover:bg-cardBorder"
        >
          Geri Dön
        </button>
      </div>
    );
  }

  return (
    <div className="max-w-3xl mx-auto px-4 sm:px-6 py-8">
      {/* Back button */}
      <button
        onClick={onBack}
        className="inline-flex items-center gap-2 text-sm font-bold text-textSecondary hover:text-white transition-colors mb-6 group"
      >
        <ArrowLeft className="w-4 h-4 group-hover:-translate-x-1 transition-transform" />
        <span>Geri Dön</span>
      </button>

      {/* Article Header */}
      <div className="mb-6">
        <div className="flex items-center gap-2 text-xs text-orangeAccent font-bold mb-2">
          <BookOpen className="w-4 h-4" />
          <span>YANGIN GÜVENLİĞİ REHBERİ</span>
        </div>

        <h1 className="text-2xl sm:text-4xl font-extrabold text-white tracking-tight leading-tight mb-4">
          {post.title}
        </h1>

        <div className="flex items-center gap-2 text-xs text-textMuted border-b border-cardBorder pb-4">
          <Calendar className="w-3.5 h-3.5" />
          <span>
            {new Date(post.createdAt).toLocaleDateString('tr-TR', {
              day: 'numeric',
              month: 'long',
              year: 'numeric',
            })}
          </span>
        </div>
      </div>

      {/* Article Content */}
      <div className="prose prose-invert max-w-none text-textPrimary text-base leading-relaxed space-y-4 mb-8">
        <p className="whitespace-pre-line">{post.content}</p>
      </div>

      {/* Emergency reminder card */}
      <div className="p-5 rounded-2xl bg-card border border-fireRed/30 flex items-start gap-3.5">
        <div className="p-2.5 rounded-xl bg-fireRed/15 text-fireRedLight shrink-0">
          <ShieldAlert className="w-5 h-5" />
        </div>
        <div>
          <h4 className="text-sm font-bold text-white mb-1">Acil Durum Hatırlatması</h4>
          <p className="text-xs text-textSecondary leading-relaxed">
            Yangın veya acil durumlarda panik yapmadan güvenli alana tahliye olun ve derhal{' '}
            <strong className="text-fireRedLight">112 Acil Çağrı Merkezi</strong>'ni arayarak ekipleri yönlendirin.
          </p>
        </div>
      </div>
    </div>
  );
};
