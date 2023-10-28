using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using System.Reflection;
using VirtualTourProcessingServer.OperationExecutors;
using VirtualTourProcessingServer.OperationHub;
using VirtualTourProcessingServer.Services;

var builder = Host.CreateApplicationBuilder();

builder.Services.AddSingleton<IOperationHub, OperationHub>();
builder.Services.AddSingleton<IOperationRunner, OperationRunner>();

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