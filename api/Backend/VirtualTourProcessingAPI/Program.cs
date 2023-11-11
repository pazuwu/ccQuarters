using CloudStorageLibrary;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using System.Reflection;
using VirtualTourProcessingServer.OperationExecutors;
using VirtualTourProcessingServer.OperationExecutors.Interfaces;
using VirtualTourProcessingServer.OperationExecutors.Render;
using VirtualTourProcessingServer.OperationRepository;
using VirtualTourProcessingServer.Processing;
using VirtualTourProcessingServer.Processing.Interfaces;
using VirtualTourProcessingServer.Services;

var builder = Host.CreateApplicationBuilder();

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