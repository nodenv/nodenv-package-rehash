#!/usr/bin/env bash


if [[ ! $npm_config_argv =~ "[\"$npm_package_name\"]" ]]; then
  exit
fi

nodenv rehash