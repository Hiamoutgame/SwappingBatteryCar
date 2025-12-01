# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy all .csproj files (from root context, copy to flat structure)
COPY SWP_EVBatteryChangeStation_BE/EV_BatteryChangeStation/EV_BatteryChangeStation.csproj EV_BatteryChangeStation/
COPY SWP_EVBatteryChangeStation_BE/EV_BatteryChangeStation_Common/EV_BatteryChangeStation_Common.csproj EV_BatteryChangeStation_Common/
COPY SWP_EVBatteryChangeStation_BE/EV_BatteryChangeStation_Repository/EV_BatteryChangeStation_Repository.csproj EV_BatteryChangeStation_Repository/
COPY SWP_EVBatteryChangeStation_BE/EV_BatteryChangeStation_Service/EV_BatteryChangeStation_Service.csproj EV_BatteryChangeStation_Service/

# Restore dependencies
RUN dotnet restore EV_BatteryChangeStation/EV_BatteryChangeStation.csproj

# Copy everything else (contents of SWP_EVBatteryChangeStation_BE to current directory)
COPY SWP_EVBatteryChangeStation_BE/ .

# Double-check appsettings.json is copied
RUN ls -la EV_BatteryChangeStation

# Publish the application
RUN dotnet publish EV_BatteryChangeStation/EV_BatteryChangeStation.csproj -c Release -o /app/out

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/out .

# Expose port (Railway will set PORT env var at runtime)
EXPOSE 80

ENTRYPOINT ["dotnet", "EV_BatteryChangeStation.dll"]
