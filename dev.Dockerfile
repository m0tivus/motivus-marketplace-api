FROM elixir:1.13.1

WORKDIR /app

RUN mix local.hex --force
RUN mix local.rebar --force

EXPOSE 4000

