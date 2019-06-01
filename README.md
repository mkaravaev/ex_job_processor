# ExJobProcessor

## Build docker image
> docker build -t ex_job_processor .

## Run test (better run in container for not executing command localy)
> docker run -it --rm ex_job_processor mix test

## Start API
> docker run --rm -it -p 127.0.0.1:4000:4000 ex_job_processor mix phx.server

## Endpoints
headers: application/json

#### POST http://localhost:4000/
#### POST http://localhost:4000/to_bash
>
