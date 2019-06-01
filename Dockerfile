FROM elixir:1.8-alpine

ENV TERM=xterm

RUN \
    apk --update upgrade musl && \
    apk --no-cache add git make g++ &&\
    rm -rf /var/cache/apk/*


ENV USER=docker
ENV APP=ex_job_processing/
ENV HOME=/home/$USER

RUN mkdir /app
COPY . ./app
WORKDIR /app

RUN mix local.hex --force && \
  mix local.rebar --force

RUN mix do deps.get, deps.compile

ENV SHELL=/bin/sh

CMD ["mix", "phx.server"]
