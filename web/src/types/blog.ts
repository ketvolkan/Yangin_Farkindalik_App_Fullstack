export interface BlogPost {
  id: number;
  title: string;
  slug: string;
  content: string;
  coverImageUrl?: string | null;
  createdAt: string;
  updatedAt?: string | null;
}
