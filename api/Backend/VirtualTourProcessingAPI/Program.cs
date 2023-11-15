using AuthLibrary;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using System.Net.Http.Headers;
using System.Reflection;
using VirtualTourAPI.ServiceClient;
using VirtualTourProcessingServer.OperationExecutors;
using VirtualTourProcessingServer.OperationExecutors.Interfaces;
using VirtualTourProcessingServer.OperationExecutors.Render;
using VirtualTourProcessingServer.OperationRepository;
using VirtualTourProcessingServer.Processing;
using VirtualTourProcessingServer.Processing.Interfaces;
using VirtualTourProcessingServer.Services;

var builder = Host.CreateApplicationBuilder();

builder.Configuration.AddUserSecrets(Assembly.GetExecutingAssembly());

builder.Services.AddHttpContextAccessor();
builder.Services.AddTransient<ITokenProvider, TokenProvider>();

builder.Services.AddTransient<VTClient>();
builder.Services.AddHttpClient<VTClient>((sp, http) => 
{
    var tokenProvider = sp.GetService<ITokenProvider>();
    var token = tokenProvider!.GetServerToken().GetAwaiter().GetResult();

    http.BaseAddress = new Uri(builder.Configuration["VTApiOptions:Url"]!);
    http.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
});

builder.Services.Configure<DocumentDBOptions>(options =>
    builder.Configuration.GetSection(nameof(DocumentDBOptions)).Bind(options));

builder.Services.AddSingleton<IOperationRepository, OperationRepository>();

builder.Services.Configure<ProcessingOptions>(options =>
    builder.Configuration.GetSection(nameof(ProcessingOptions)).Bind(options));

builder.Services.AddSingleton<IOperationManager, OperationManager>();
builder.Services.AddSingleton<IOperationRunner, OperationRunner>();
builder.Services.AddSingleton<IMultiOperationRunner, MultiOperationRunner>();

builder.Services.AddSingleton<IDownloadExecutor, DownloadExecutor>();

builder.Services.Configure<RenderOptions>(options =>
    builder.Configuration.GetSection(nameof(RenderOptions)).Bind(options));
builder.Services.AddSingleton<IRenderSettingsGenerator, RenderSettingsGenerator>();

builder.Services.AddSingleton<IUploadExecutor, UploadExecutor>();

builder.Services.Configure<NerfStudioOptions>(options =>
    builder.Configuration.GetSection(nameof(NerfStudioOptions)).Bind(options));
builder.Services.AddSingleton<NerfStudioExecutor>();
builder.Services.AddSingleton<IColmapExecutor>(x => x.GetRequiredService<NerfStudioExecutor>());
builder.Services.AddSingleton<ITrainExecutor>(x => x.GetRequiredService<NerfStudioExecutor>());
builder.Services.AddSingleton<IRenderExecutor>(x => x.GetRequiredService<NerfStudioExecutor>());

builder.Services.AddMediatR(cfg => cfg.RegisterServicesFromAssembly(Assembly.GetExecutingAssembly()));
builder.Services.AddHostedService<OperationListener>();

using IHost host = builder.Build();
host.Run();