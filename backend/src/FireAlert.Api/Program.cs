using FireAlert.Application.Interfaces;
using FireAlert.Application.Services;
using FireAlert.Infrastructure.Data;
using FireAlert.Infrastructure.Hubs;
using FireAlert.Infrastructure.Notifications;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

// Add Controllers & JSON Options
builder.Services.AddControllers()
    .AddJsonOptions(options =>
    {
        options.JsonSerializerOptions.PropertyNamingPolicy = System.Text.Json.JsonNamingPolicy.CamelCase;
    });

// Add SignalR
builder.Services.AddSignalR();

// Configure CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy.SetIsOriginAllowed(_ => true)
              .AllowAnyHeader()
              .AllowAnyMethod()
              .AllowCredentials();
    });
});

// Configure Database
var dbProvider = builder.Configuration.GetValue<string>("UseDatabaseProvider") ?? "Sqlite";
var postgresConnection = builder.Configuration.GetConnectionString("DefaultConnection");
var sqliteConnection = builder.Configuration.GetConnectionString("SqliteConnection") ?? "Data Source=firealert.db";

builder.Services.AddDbContext<FireAlertDbContext>(options =>
{
    if (dbProvider.Equals("PostgreSql", StringComparison.OrdinalIgnoreCase) && !string.IsNullOrEmpty(postgresConnection))
    {
        options.UseNpgsql(postgresConnection);
    }
    else
    {
        options.UseSqlite(sqliteConnection);
    }
});

// Dependency Injection
builder.Services.AddScoped<IFireReportRepository, FireReportRepository>();
builder.Services.AddScoped<IBlogRepository, BlogRepository>();
builder.Services.AddScoped<IFireNotificationService, SignalRFireNotificationService>();
builder.Services.AddScoped<IFireReportService, FireReportService>();
builder.Services.AddScoped<IBlogService, BlogService>();

// Swagger / OpenAPI
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo
    {
        Title = "FireAlert API",
        Version = "v1",
        Description = "FireAlert - Sosyal Yangın Farkındalık Platformu REST & SignalR API",
        Contact = new OpenApiContact
        {
            Name = "FireAlert Team",
            Email = "info@firealert.example.com"
        }
    });
});

var app = builder.Build();

// Auto-migrate & Seed database
using (var scope = app.Services.CreateScope())
{
    var dbContext = scope.ServiceProvider.GetRequiredService<FireAlertDbContext>();
    await dbContext.Database.EnsureCreatedAsync();
    await DataSeeder.SeedAsync(dbContext);
}

// Middleware pipeline
if (app.Environment.IsDevelopment() || true)
{
    app.UseSwagger();
    app.UseSwaggerUI(c =>
    {
        c.SwaggerEndpoint("/swagger/v1/swagger.json", "FireAlert API v1");
        c.RoutePrefix = "swagger";
    });
}

app.UseRouting();
app.UseCors("AllowAll");

app.MapControllers();
app.MapHub<FireHub>(FireHub.HubUrl);

// Root health & info endpoint
app.MapGet("/", () => Results.Ok(new
{
    application = "FireAlert API",
    version = "1.0.0",
    status = "Healthy",
    time = DateTime.UtcNow,
    swagger = "/swagger",
    signalRHub = "/hubs/fire"
}));

app.Run();
