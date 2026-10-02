import * as signalR from '@microsoft/signalr';
import { FireReport } from '../types/fireReport';
import { FireStatistics } from '../types/statistics';

type FireReportCreatedCallback = (data: FireReport & { stats?: FireStatistics }) => void;
type StatisticsUpdatedCallback = (data: FireStatistics) => void;

class SignalRService {
  private connection: signalR.HubConnection | null = null;
  private isConnecting = false;
  private fireCreatedListeners: FireReportCreatedCallback[] = [];
  private statsListeners: StatisticsUpdatedCallback[] = [];

  public startConnection() {
    if (this.connection && this.connection.state === signalR.HubConnectionState.Connected) {
      return;
    }

    if (this.isConnecting) return;
    this.isConnecting = true;

    const hubUrl = import.meta.env.VITE_API_BASE_URL
      ? `${import.meta.env.VITE_API_BASE_URL.replace(/\/$/, '')}/hubs/fire`
      : '/hubs/fire';

    this.connection = new signalR.HubConnectionBuilder()
      .withUrl(hubUrl, {
        skipNegotiation: false,
        transport: signalR.HttpTransportType.WebSockets | signalR.HttpTransportType.LongPolling,
      })
      .withAutomaticReconnect([0, 2000, 5000, 10000, 30000])
      .configureLogging(signalR.LogLevel.Information)
      .build();

    this.connection.on('FireReportCreated', (payload: any) => {
      console.log('🔥 [SignalR] FireReportCreated event received from Backend:', payload);
      this.fireCreatedListeners.forEach((callback) => callback(payload));
    });

    this.connection.on('StatisticsUpdated', (payload: FireStatistics) => {
      console.log('📊 [SignalR] StatisticsUpdated event received from Backend:', payload);
      this.statsListeners.forEach((callback) => callback(payload));
    });

    this.connection
      .start()
      .then(() => {
        console.log('🟢 [SignalR] Connected successfully to .NET backend hub');
        this.isConnecting = false;
      })
      .catch((err) => {
        console.warn('🔴 [SignalR] Connection to backend hub error (will retry automatically):', err);
        this.isConnecting = false;
      });

    this.connection.onreconnected(() => {
      console.log('🔄 [SignalR] Reconnected to backend hub');
    });

    this.connection.onclose(() => {
      console.log('⚪ [SignalR] Connection closed');
      this.isConnecting = false;
    });
  }

  public onFireReportCreated(callback: FireReportCreatedCallback) {
    this.fireCreatedListeners.push(callback);
    return () => {
      this.fireCreatedListeners = this.fireCreatedListeners.filter((cb) => cb !== callback);
    };
  }

  public onStatisticsUpdated(callback: StatisticsUpdatedCallback) {
    this.statsListeners.push(callback);
    return () => {
      this.statsListeners = this.statsListeners.filter((cb) => cb !== callback);
    };
  }

  public stopConnection() {
    if (this.connection) {
      this.connection.stop();
      this.connection = null;
    }
  }
}

export const signalRService = new SignalRService();
