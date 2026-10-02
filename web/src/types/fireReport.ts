export interface FireReport {
  id: number;
  reporterName: string;
  fireType: string;
  description?: string | null;
  latitude: number;
  longitude: number;
  imageUrl?: string | null;
  status: string;
  createdAt: string;
  updatedAt?: string | null;
}

export interface CreateFireReportRequest {
  reporterName: string;
  fireType: string;
  description?: string;
  latitude: number;
  longitude: number;
  imageUrl?: string;
}
