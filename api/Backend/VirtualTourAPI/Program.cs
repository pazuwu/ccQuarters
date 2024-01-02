using AuthLibrary;
using CloudStorageLibrary;
using RepositoryLibrary;
using VirtualTourAPI.Endpoints;
using VirtualTourAPI.Repository;
using VirtualTourAPI.Service;

var builder = WebApplication.CreateBuilder(args);

builder.AddFirebaseAuthorizarion();
builder.AddFirebaseAuthentication();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c => c.AddFirebaseSecurityDefinition());
builder.Services.AddCors(c => c.AddLocationHeaderCorsOptions());

builder.Services.Configure<DocumentDBOptions>(options =>
    builder.Configuration.GetSection(nameof(DocumentDBOptions)).Bind(options));

builder.Services.AddHttpContextAccessor();
builder.Services.AddTransient<ITokenProvider, TokenProvider>();
builder.Services.AddTransient<IStorage, FirebaseCloudStorage>();
builder.Services.AddTransient<IDocumentDBRepository, DocumentDBRepository>();
builder.Services.AddTransient<IVTService, VTService>();

var app = builder.Build();

app.UseCors(options => options.AllowAnyMethod().
                   AllowAnyHeader().
                   SetIsOriginAllowed(_ => true).
                   AllowCredentials());

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseRouting();
app.UseAuthentication();
app.UseAuthorization();
app.UseCors(LocationHeaderCorsPolicy.LocationPolicyName);

app.MapGet("/tours/{tourId}", TourEndpoints.Get).WithOpenApi().RequireFBAuthorization();
app.MapGet("/tours/{tourId}/forEdit", TourEndpoints.GetForEdit).WithOpenApi().RequireFBAuthorization();
app.MapGet("/tours/my", TourEndpoints.GetMy).WithOpenApi().RequireFBAuthorization();
app.MapPost("tours", TourEndpoints.Post).WithOpenApi().RequireFBAuthorization();
app.MapPut("tours/{tourId}", TourEndpoints.Put).WithOpenApi().RequireFBAuthorization();
app.MapDelete("tours", TourEndpoints.Delete).WithOpenApi().RequireFBAuthorization();

app.MapPost("/tours/{tourId}/areas", AreaEndpoints.Post).WithOpenApi().RequireFBAuthorization();
app.MapDelete("/tours/{tourId}/areas/{areaId}", AreaEndpoints.Delete).WithOpenApi().RequireFBAuthorization();
app.MapPost("/tours/{tourId}/areas/{areaId}/process", AreaEndpoints.Process).WithOpenApi().RequireFBAuthorization();
app.MapPost("/tours/{tourId}/areas/{areaId}/photos", AreaEndpoints.PostPhotos).WithOpenApi().RequireFBAuthorization();
app.MapGet("/tours/{tourId}/areas/{areaId}/photos", AreaEndpoints.GetPhotos).WithOpenApi().RequireFBAuthorization();

app.MapPost("/tours/{tourId}/scenes", SceneEndpoints.Post).WithOpenApi().RequireFBAuthorization();
app.MapDelete("/tours/{tourId}/scenes/{sceneId}", SceneEndpoints.Delete).WithOpenApi().RequireFBAuthorization();
app.MapPost("/tours/{tourId}/scenes/{sceneId}/photo", SceneEndpoints.PostPhoto).WithOpenApi().RequireFBAuthorization();

app.MapPost("/tours/{tourId}/links", LinkEndpoints.Post).WithOpenApi().RequireFBAuthorization();
app.MapPut("/tours/{tourId}/links/{linkId}", LinkEndpoints.Put).WithOpenApi().RequireFBAuthorization();
app.MapDelete("/tours/{tourId}/links/{linkId}", LinkEndpoints.Delete).WithOpenApi().RequireFBAuthorization();


app.Run();
