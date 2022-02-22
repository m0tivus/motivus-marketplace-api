#!/bin/sh
set -e

# Update mix client
mix local.hex --force
mix local.rebar --force

# Ensure the app's dependencies are installed
mix deps.get
# Potentially Set up the database

MIX_ENV="${MIX_ENV:=dev}"

if [ $MIX_ENV = 'prod' ]; then
  mix ecto.create --no-compile
  mix ecto.migrate --no-compile
  echo " Launching Phoenix web server..."
  mix phx.server --no-compile
else
  mix ecto.create
  mix ecto.migrate
  echo " Launching Phoenix web server..."
  mix phx.server
fi
