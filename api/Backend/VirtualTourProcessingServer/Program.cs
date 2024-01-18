using AuthLibrary;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using RepositoryLibrary;
using System.Net.Http.Headers;
using System.Reflection;
using VirtualTourAPI.Client;
using VirtualTourProcessingServer.Model;
using VirtualTourProcessingServer.OperationExecutors;
using VirtualTourProcessingServer.OperationExecutors.Interfaces;
using VirtualTourProcessingServer.OperationExecutors.Render;
using VirtualTourProcessingServer.OperationListener;
using VirtualTourProcessingServer.Processing;
using VirtualTourProcessingServer.Processing.Interfaces;
using VirtualTourProcessingServer.Services;

var builder = Host.CreateApplicationBuilder();

builder.Configuration.AddUserSecrets(Assembly.GetExecutingAssembly());

builder.Services.AddHttpContextAccessor();
builder.Services.AddTransient<ITokenProvider, TokenProvider>();

builder.Services.AddHttpClient<VTClient>((sp, http) =>
{
    var tokenProvider = sp.GetService<ITokenProvider>();
    var token = tokenProvider!.GetServerToken().GetAwaiter().GetResult();

    http.BaseAddress = new Uri(builder.Configuration["VTApiOptions:Url"]!);
    http.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
});

builder.Services.AddTransient<IDocumentDBRepository,  DocumentDBRepository>();

builder.Services.AddSingleton<IOperationManager, OperationManager>();
builder.Services.AddTransient<HubResolver>(sp => (operationStage, hub, multiHub) =>
{
    return operationStage switch
    {
        OperationStage.Colmap 
        or OperationStage.Train 
        or OperationStage.Render => hub,

        OperationStage.Waiting 
        or OperationStage.PrepareRender 
        or OperationStage.SavingRender 
        or OperationStage.Finished => multiHub,

        _ => null,
    };
});

builder.Services.AddSingleton<IOperationRunner, OperationRunner>();
builder.Services.AddSingleton<IMultiOperationRunner, MultiOperationRunner>();


builder.Services.AddSingleton<IProcessRunner, ProcessRunner>();
builder.Services.AddSingleton<ColmapExecutor>();
builder.Services.AddSingleton<TrainExecutor>();
builder.Services.AddSingleton<RenderExecutor>();

builder.Services.AddTransient<ExecutorResolver>(sp => operationStage =>
{
    return operationStage switch
    {
        OperationStage.Colmap => sp.GetService<ColmapExecutor>(),
        OperationStage.Train => sp.GetService<TrainExecutor>(),
        OperationStage.Render => sp.GetService<RenderExecutor>(),
        _ => null,
    };
});


builder.Services.AddSingleton<DownloadExecutor>();
builder.Services.AddSingleton<GenerateRenderSettingsExecutor>();
builder.Services.AddSingleton<UploadExecutor>();
builder.Services.AddSingleton<CleanExecutor>();

builder.Services.AddTransient<MultiExecutorResolver>(sp => operationStage =>
{
    return operationStage switch
    {
        OperationStage.Waiting => sp.GetService<DownloadExecutor>(),
        OperationStage.PrepareRender => sp.GetService<GenerateRenderSettingsExecutor>(),
        OperationStage.SavingRender => sp.GetService<UploadExecutor>(),
        OperationStage.Finished => sp.GetService<CleanExecutor>(),
        _ => null,
    };
});

builder.Services.AddMediatR(cfg => cfg.RegisterServicesFromAssembly(Assembly.GetExecutingAssembly()));
builder.Services.AddHostedService<OperationListener>();


builder.Services.Configure<DocumentDBOptions>(options =>
    builder.Configuration.GetSection(nameof(DocumentDBOptions)).Bind(options));

builder.Services.Configure<NerfStudioOptions>(options =>
{
    builder.Configuration.GetSection(nameof(NerfStudioOptions)).Bind(options);

    string environmentPath = options.EnvironmentDirectory!;
    string scriptsPath = $@"{environmentPath}\Scripts";
    string libraryPath = $@"{environmentPath}\Library";
    string binPath = $@"{environmentPath}\bin";
    string exeutablePath = @$"{environmentPath}\Library\bin";
    string mingwBinPath = $@"{environmentPath}\Library\mingw-w64\bin";
    string oldPath = Environment.GetEnvironmentVariable("Path")!;
    Environment.SetEnvironmentVariable("PATH", $"{environmentPath};{scriptsPath};{libraryPath};{binPath};{exeutablePath};{mingwBinPath};{oldPath}", EnvironmentVariableTarget.Process);
    Environment.SetEnvironmentVariable("PYTHONUTF8", "1");
});

builder.Services.Configure<RenderOptions>(options =>
    builder.Configuration.GetSection(nameof(RenderOptions)).Bind(options));

builder.Services.Configure<ProcessingOptions>(options =>
    builder.Configuration.GetSection(nameof(ProcessingOptions)).Bind(options));


using IHost host = builder.Build();
host.Run();