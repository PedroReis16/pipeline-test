#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
    COPY ["Pipeline.SegundaAPI/Pipeline.SegundaAPI.csproj", "Pipeline.SegundaAPI/"]
RUN dotnet restore "Pipeline.SegundaAPI/Pipeline.SegundaAPI.csproj"
COPY . .
WORKDIR "/src/Pipeline.SegundaAPI"
RUN dotnet build "Pipeline.SegundaAPI.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Pipeline.SegundaAPI.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Pipeline.SegundaAPI.dll"]