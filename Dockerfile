FROM elixir:1.8-alpine

ENV TERM=xterm

RUN addgroup docker -g 1000 && \
    adduser docker -u 1000 -s /bin/ash -SDG docker && \
    apk add --update sudo && \
    echo "docker ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN \
    apk --update upgrade musl && \
    apk --no-cache add git make g++ &&\
    rm -rf /var/cache/apk/*

ENV USER docker
ENV APP ex_job_processing/
ENV HOME=/home/$USER

USER $USER
WORKDIR $HOME/$APP

RUN mix local.hex --force && \
    mix local.rebar --force

COPY . ./

RUN mix do deps.get

ENV SHELL=/bin/sh

CMD ["mix", "phx.server"]
