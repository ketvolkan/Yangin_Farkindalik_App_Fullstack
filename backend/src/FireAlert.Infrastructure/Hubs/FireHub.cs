using Microsoft.AspNetCore.SignalR;

namespace FireAlert.Infrastructure.Hubs;

public class FireHub : Hub
{
    public const string HubUrl = "/hubs/fire";
}
