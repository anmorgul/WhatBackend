#!/bin/sh
sed -i -r "s|(\"http\":.*)|\"http\": \"$APIURL\"|" /app/appsettings.DevelopmentLocalhost.json
# sed -i -r "s|(\"Http\":.*)|\"Http\": \"$APIURL\",|" /app/appsettings.json
# sed -i -r "s|(\"Https\":.*)|\"Https\": \"$APIURL\"|" /app/appsettings.json

sed -i -r "s|(\"Http\":.*)|\"Http\": \"http://$APIURL\",|" /app/appsettings.json
sed -i -r "s|(\"Https\":.*)|\"Https\": \"http://$APIURL\"|" /app/appsettings.json

dotnet CharlieBackend.Panel.dll