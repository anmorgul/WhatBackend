#!/bin/sh
sed -i -r "s|(\"Http\": \"http:\/\/.*\")|\"$APIURL\"|" /app/appsettings.DevelopmentLocalhost.json
sed -i -r "s|(\"Http\": \"http:\/\/.*\")|\"$APIURL\"|" /app/appsettings.json
sed -i -r "s|(\"Https\": \"http:\/\/.*\")|\"$APIURL\"|" /app/appsettings.json

dotnet CharlieBackend.Panel.dll