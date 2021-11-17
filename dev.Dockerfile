FROM elixir:1.10.4

WORKDIR /app

RUN mix local.hex --force
RUN mix local.rebar --force

EXPOSE 4000

