#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["Pipeline.PrimeiraAPI/Pipeline.PrimeiraAPI.csproj", "Pipeline.PrimeiraAPI/"]
RUN dotnet restore "Pipeline.PrimeiraAPI/Pipeline.PrimeiraAPI.csproj"
COPY . .
WORKDIR "/src/Pipeline.PrimeiraAPI"
RUN dotnet build "Pipeline.PrimeiraAPI.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Pipeline.PrimeiraAPI.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Pipeline.PrimeiraAPI.dll"]