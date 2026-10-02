import React from 'react';
import { BlogPost } from '../types/blog';
import { ArrowRight, BookOpen, Calendar } from 'lucide-react';

interface BlogSectionProps {
  posts: BlogPost[];
  onSelectPost: (post: BlogPost) => void;
  isLoading?: boolean;
}

const formatDate = (isoString: string) => {
  const date = new Date(isoString);
  return date.toLocaleDateString('tr-TR', { day: 'numeric', month: 'long', year: 'numeric' });
};

export const BlogSection: React.FC<BlogSectionProps> = ({
  posts,
  onSelectPost,
  isLoading,
}) => {
  return (
    <section className="space-y-4">
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-2">
          <BookOpen className="w-5 h-5 text-orangeAccent" />
          <h3 className="text-xl font-extrabold text-white tracking-tight">
            Yangın Güvenliği & Bilinç Rehberi
          </h3>
        </div>
        <span className="text-xs text-textMuted hidden sm:inline">
          Afet ve acil durumlara hazırlıklı olun
        </span>
      </div>

      {isLoading ? (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {[1, 2, 3].map((i) => (
            <div key={i} className="p-5 rounded-2xl bg-card border border-cardBorder animate-pulse space-y-3">
              <div className="h-4 bg-surfaceLight rounded w-3/4" />
              <div className="h-12 bg-surfaceLight rounded" />
              <div className="h-3 bg-surfaceLight rounded w-1/4" />
            </div>
          ))}
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {posts.map((post) => (
            <div
              key={post.id}
              onClick={() => onSelectPost(post)}
              className="group p-5 rounded-2xl bg-card border border-cardBorder hover:border-orangeAccent/40 hover:bg-surfaceLight/50 transition-all flex flex-col justify-between cursor-pointer shadow-sm"
            >
              <div>
                <div className="flex items-center justify-between text-xs text-textMuted mb-2.5">
                  <span className="px-2 py-0.5 rounded-md bg-orangeAccent/10 text-orangeAccent font-bold text-[11px]">
                    Güvenlik
                  </span>
                  <span className="flex items-center gap-1 font-medium">
                    <Calendar className="w-3 h-3" />
                    {formatDate(post.createdAt)}
                  </span>
                </div>

                <h4 className="text-base font-bold text-white group-hover:text-orangeAccent transition-colors mb-2 line-clamp-2">
                  {post.title}
                </h4>

                <p className="text-xs text-textSecondary line-clamp-3 leading-relaxed mb-4">
                  {post.content}
                </p>
              </div>

              <div className="flex items-center gap-1 text-xs font-bold text-orangeAccent group-hover:translate-x-1 transition-transform pt-2 border-t border-cardBorder/50">
                <span>Devamını Oku</span>
                <ArrowRight className="w-3.5 h-3.5" />
              </div>
            </div>
          ))}
        </div>
      )}
    </section>
  );
};
