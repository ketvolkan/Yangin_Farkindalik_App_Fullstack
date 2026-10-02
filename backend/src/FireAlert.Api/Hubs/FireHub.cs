using Microsoft.AspNetCore.SignalR;

namespace FireAlert.Api.Hubs;

public class FireHub : Hub
{
    public const string HubUrl = "/hubs/fire";

    public async Task SendMessage(string user, string message)
    {
        await Clients.All.SendAsync("ReceiveMessage", user, message);
    }
}
