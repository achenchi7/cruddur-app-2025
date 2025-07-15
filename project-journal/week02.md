export HONEYCOMB_API_KEY="fkFC2xDJ9zIfEFrHxxrRuB"
gp env HONEYCOMB_API_KEY="fkFC2xDJ9zIfEFrHxxrRuB"




## Notes from the livestream 
- Whole project needs to use the same Honeycomb API key so that the little stories from the different services can be put together.

- Each piece of the project should have it's own service name

This env variables are added to the `docker compose` file
```yml
OTEL_SERVICE_NAME: "backend-flask"
OTEL_EXPORTER_OTLP_ENDPOINT: "https://api.honeycomb.io"
OTEL_EXPORTER_OTLP_HEADERS: "x-honeycomb-team=${HONEYCOMB_API_KEY}"
```

OTEL - Open Telemetry
