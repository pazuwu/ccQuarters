using VirtualTourAPI.Endpoints;
using VirtualTourAPI.Repository;

var builder = WebApplication.CreateBuilder(args);

builder.Services.Configure<DocumentDBOptions>(options =>
    builder.Configuration.GetSection(nameof(DocumentDBOptions)).Bind(options));

builder.Services.AddScoped<IVTRepository, VTRepository>();

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.MapGet("/tours/{tourId}", TourEndpoints.Get).WithOpenApi();

app.MapPost("/tours/{tourId}/areas", AreaEndpoints.Post).WithOpenApi();
app.MapDelete("/tours/{tourId}/areas/{areaId}", AreaEndpoints.Delete).WithOpenApi();

app.MapPost("/tours/{tourId}/scenes", SceneEndpoints.Post).WithOpenApi();
app.MapDelete("/tours/{tourId}/scenes/{sceneId}", SceneEndpoints.Delete).WithOpenApi();

app.MapPost("/tours/{tourId}/links", LinkEndpoints.Post).WithOpenApi();
app.MapPut("/tours/{tourId}/links/{linkId}", LinkEndpoints.Put).WithOpenApi();
app.MapDelete("/tours/{tourId}/links/{linkId}", LinkEndpoints.Delete).WithOpenApi();


app.Run();
