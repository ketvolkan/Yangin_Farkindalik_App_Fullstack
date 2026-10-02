using FireAlert.Domain.Entities;
using FireAlert.Domain.Enums;
using Microsoft.EntityFrameworkCore;

namespace FireAlert.Infrastructure.Data;

public class FireAlertDbContext : DbContext
{
    public FireAlertDbContext(DbContextOptions<FireAlertDbContext> options) : base(options)
    {
    }

    public DbSet<FireReport> FireReports => Set<FireReport>();
    public DbSet<BlogPost> BlogPosts => Set<BlogPost>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // FireReport configuration
        modelBuilder.Entity<FireReport>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.ReporterName).IsRequired().HasMaxLength(150);
            entity.Property(e => e.FireType).HasConversion<string>().HasMaxLength(50);
            entity.Property(e => e.Status).HasConversion<string>().HasMaxLength(50);
            entity.Property(e => e.Description).HasMaxLength(1000);
            entity.Property(e => e.ImageUrl).HasMaxLength(500);
            entity.Property(e => e.Latitude).IsRequired();
            entity.Property(e => e.Longitude).IsRequired();
            entity.Property(e => e.CreatedAt).IsRequired();

            entity.HasIndex(e => e.Status);
            entity.HasIndex(e => e.CreatedAt);
        });

        // BlogPost configuration
        modelBuilder.Entity<BlogPost>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.Title).IsRequired().HasMaxLength(250);
            entity.Property(e => e.Slug).IsRequired().HasMaxLength(250);
            entity.Property(e => e.Content).IsRequired();
            entity.Property(e => e.CoverImageUrl).HasMaxLength(500);
            entity.Property(e => e.CreatedAt).IsRequired();

            entity.HasIndex(e => e.Slug).IsUnique();
        });
    }
}
