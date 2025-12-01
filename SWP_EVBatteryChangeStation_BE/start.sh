#!/bin/bash
set -e

# Navigate to the .NET project directory
cd SWP_EVBatteryChangeStation_BE

# Set PORT if provided by Railway/Railpack
if [ -n "$PORT" ]; then
    export ASPNETCORE_URLS="http://+:$PORT"
fi

# If Railpack has already published the app, run the published DLL
# Otherwise, build and run directly
if [ -f "/app/out/EV_BatteryChangeStation.dll" ]; then
    cd /app/out
    exec dotnet EV_BatteryChangeStation.dll
elif [ -f "bin/Release/net8.0/EV_BatteryChangeStation.dll" ]; then
    exec dotnet bin/Release/net8.0/EV_BatteryChangeStation.dll
else
    # Fallback: build and run
    dotnet build -c Release
    exec dotnet run --project EV_BatteryChangeStation/EV_BatteryChangeStation.csproj --no-build
fi

